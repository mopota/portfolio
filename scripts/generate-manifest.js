const fs = require('fs');
const path = require('path');

const appsDir = path.join(__dirname, '../apps');
const outputFile = path.join(__dirname, '../data/apps-manifest.json');

const imageExtensions = ['.png', '.jpg', '.jpeg', '.webp', '.svg'];

function findImage(dir, baseName) {
    for (const ext of imageExtensions) {
        const file = `${baseName}${ext}`;
        if (fs.existsSync(path.join(dir, file))) {
            return file;
        }
    }
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
                const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

                // Auto Detect Assets
                const icon = findImage(appPath, 'icon');
                const banner = findImage(appPath, 'banner');
                const cover = findImage(appPath, 'cover');

                const screenshots = getImagesInDir(path.join(appPath, 'screenshots'))
                    .map(img => `screenshots/${img}`);

                const assets = getImagesInDir(path.join(appPath, 'assets'))
                    .map(img => `assets/${img}`);

                manifest.push({
                    ...config,
                    folder: folder,
                    appFile: `apps/${folder}/app.json`,
                    icon: icon ? `apps/${folder}/${icon}` : null,
                    banner: banner ? `apps/${folder}/${banner}` : null,
                    cover: cover ? `apps/${folder}/${cover}` : null,
                    screenshots: screenshots.map(s => `apps/${folder}/${s}`),
                    assets: assets.map(a => `apps/${folder}/${a}`),
                    lastUpdated: fs.statSync(configPath).mtime
                });
            }
        }
    });
}

// Sort by date (Newest first)
manifest.sort((a, b) => new Date(b.lastUpdated) - new Date(a.lastUpdated));

fs.writeFileSync(outputFile, JSON.stringify(manifest, null, 2));
console.log(`✅ Manifest generated with ${manifest.length} apps.`);
