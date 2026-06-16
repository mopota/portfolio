const fs = require('fs');
const path = require('path');

const appsDir = path.join(__dirname, '../apps');
const outputFile = path.join(__dirname, '../data/apps-manifest.json');
const imageExtensions = ['.png', '.jpg', '.jpeg', '.webp', '.svg'];

/**
 * Smart Asset Discovery
 */
function findAsset(appPath, folder, baseName) {
    const searchLocations = [
        appPath,                    // Root of app folder
        path.join(appPath, 'assets') // assets/ subfolder
    ];

    // 1. Try exact matches with extensions
    for (const dir of searchLocations) {
        if (!fs.existsSync(dir)) continue;
        for (const ext of imageExtensions) {
            const file = `${baseName}${ext}`;
            const fullPath = path.join(dir, file);
            if (fs.existsSync(fullPath)) {
                const relativePath = path.relative(path.join(__dirname, '..'), fullPath).replace(/\\/g, '/');
                console.log(`[DEBUG] Found ${baseName}: ${relativePath}`);
                return relativePath;
            }
        }
    }

    // 2. Fallback: Search for partial matches (icon, logo, etc) if looking for 'icon'
    if (baseName === 'icon') {
        const keywords = ['icon', 'logo', 'app-icon'];
        for (const dir of searchLocations) {
            if (!fs.existsSync(dir)) continue;
            const files = fs.readdirSync(dir);
            for (const file of files) {
                const lowerFile = file.toLowerCase();
                if (keywords.some(k => lowerFile.includes(k)) && imageExtensions.includes(path.extname(lowerFile))) {
                    const relativePath = path.relative(path.join(__dirname, '..'), path.join(dir, file)).replace(/\\/g, '/');
                    console.log(`[DEBUG] Smart Found ${baseName} (partial match): ${relativePath}`);
                    return relativePath;
                }
            }
        }
    }

    console.warn(`[WARN] Missing ${baseName} for app in: ${appPath}`);
    return null;
}

function getImagesInDir(dir) {
    if (!fs.existsSync(dir)) return [];
    return fs.readdirSync(dir)
        .filter(file => imageExtensions.includes(path.extname(file).toLowerCase()))
        .sort((a, b) => a.localeCompare(b, undefined, { numeric: true, sensitivity: 'base' }));
}

const manifest = [];

if (fs.existsSync(appsDir)) {
    const folders = fs.readdirSync(appsDir);

    folders.forEach(folder => {
        const appPath = path.join(appsDir, folder);
        if (fs.lstatSync(appPath).isDirectory()) {
            const configPath = path.join(appPath, 'app.json');
            if (fs.existsSync(configPath)) {
                try {
                    const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

                    // Smart Discovery for Icon, Banner, Cover
                    const icon = findAsset(appPath, folder, 'icon');
                    const banner = findAsset(appPath, folder, 'banner');
                    const cover = findAsset(appPath, folder, 'cover');

                    const screenshots = getImagesInDir(path.join(appPath, 'screenshots'))
                        .map(img => `apps/${folder}/screenshots/${img}`);

                    const assets = getImagesInDir(path.join(appPath, 'assets'))
                        .map(img => `apps/${folder}/assets/${img}`);

                    manifest.push({
                        ...config,
                        id: config.id || folder,
                        folder: folder,
                        appFile: `apps/${folder}/app.json`,
                        icon: icon,
                        banner: banner,
                        cover: cover,
                        screenshots: screenshots,
                        assets: assets,
                        lastUpdated: fs.statSync(configPath).mtime
                    });
                } catch (e) {
                    console.error(`[ERROR] Parsing app.json in ${folder}:`, e.message);
                }
            }
        }
    });
}

manifest.sort((a, b) => new Date(b.lastUpdated) - new Date(a.lastUpdated));

// Ensure data directory exists
const dataDir = path.dirname(outputFile);
if (!fs.existsSync(dataDir)) fs.mkdirSync(dataDir, { recursive: true });

fs.writeFileSync(outputFile, JSON.stringify(manifest, null, 2));
console.log(`\n✅ Autonomous Manifest generated with ${manifest.length} apps.`);
