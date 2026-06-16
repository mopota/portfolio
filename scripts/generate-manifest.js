const fs = require('fs');
const path = require('path');

/**
 * PROJECT DISCOVERY & MANIFEST GENERATION SCRIPT
 * Developed for Mohamed Taha Portfolio
 *
 * This script automates the discovery of projects, copies assets to the public
 * folder for static serving, and generates a manifest file for the frontend.
 */

const PROJECTS_ROOT = path.join(process.cwd(), 'projects');
const PUBLIC_DEST = path.join(process.cwd(), 'public/projects');
const MANIFEST_DEST = path.join(process.cwd(), 'src/data/projects-manifest.json');

const isProd = process.env.NODE_ENV === 'production';
const BASE_PATH = isProd ? '/portfolio' : '';

const SUPPORTED_IMAGE_EXT = ['.png', '.jpg', '.jpeg', '.webp', '.svg'];

console.log('--------------------------------------------------');
console.log('🚀 PORTFOLIO BUILD SYSTEM: Project Discovery');
console.log('--------------------------------------------------');
console.log(`📍 Root: ${process.cwd()}`);
console.log(`🌐 Mode: ${isProd ? 'Production' : 'Development'}`);
console.log(`🔗 Base Path: ${BASE_PATH || '/'}`);

// Validation & Setup
if (!fs.existsSync(PROJECTS_ROOT)) {
    console.error('❌ FATAL: /projects directory not found at root.');
    process.exit(1);
}

// Clean Public Projects Directory
try {
    if (fs.existsSync(PUBLIC_DEST)) {
        fs.rmSync(PUBLIC_DEST, { recursive: true, force: true });
    }
    fs.mkdirSync(PUBLIC_DEST, { recursive: true });
} catch (err) {
    console.error(`❌ ERROR: Failed to prepare public directory: ${err.message}`);
}

const getFiles = (dir, exts) => {
    if (!fs.existsSync(dir)) return [];
    return fs.readdirSync(dir).filter(f => exts.includes(path.extname(f).toLowerCase()));
};

const generateManifest = () => {
    const projects = [];
    const folders = fs.readdirSync(PROJECTS_ROOT);
    let stats = { projects: 0, images: 0, icons: 0, errors: [] };

    folders.forEach(folder => {
        const pPath = path.join(PROJECTS_ROOT, folder);
        if (!fs.lstatSync(pPath).isDirectory()) return;

        const configPath = path.join(pPath, 'project.json');
        if (!fs.existsSync(configPath)) {
            stats.errors.push(`[${folder}] Missing project.json`);
            return;
        }

        try {
            const data = JSON.parse(fs.readFileSync(configPath, 'utf8'));
            const publicProjDir = path.join(PUBLIC_DEST, folder);
            fs.mkdirSync(publicProjDir, { recursive: true });

            // 1. Icon Discovery
            const iconDir = path.join(pPath, 'icon');
            const iconFiles = getFiles(iconDir, SUPPORTED_IMAGE_EXT);
            let iconUrl = null;
            if (iconFiles.length > 0) {
                const iconName = iconFiles[0];
                const dest = path.join(publicProjDir, 'icon');
                fs.mkdirSync(dest, { recursive: true });
                fs.copyFileSync(path.join(iconDir, iconName), path.join(dest, iconName));
                iconUrl = `${BASE_PATH}/projects/${folder}/icon/${iconName}`;
                stats.icons++;
            }

            // 2. Screenshots Discovery
            const ssDir = path.join(pPath, 'screenshots');
            const ssFiles = getFiles(ssDir, SUPPORTED_IMAGE_EXT);
            const ssUrls = [];
            if (ssFiles.length > 0) {
                const dest = path.join(publicProjDir, 'screenshots');
                fs.mkdirSync(dest, { recursive: true });
                ssFiles.forEach(file => {
                    fs.copyFileSync(path.join(ssDir, file), path.join(dest, file));
                    ssUrls.push(`${BASE_PATH}/projects/${folder}/screenshots/${file}`);
                    stats.images++;
                });
            }

            projects.push({
                ...data,
                id: folder,
                icon: iconUrl,
                screenshots: ssUrls,
                lastUpdated: new Date().toISOString()
            });

            stats.projects++;
            console.log(`✅ [${folder.padEnd(20)}] Found | ${ssFiles.length} images | ${iconUrl ? 'Icon detected' : 'No icon'}`);

        } catch (err) {
            stats.errors.push(`[${folder}] Processing error: ${err.message}`);
        }
    });

    // Write Manifest
    fs.mkdirSync(path.dirname(MANIFEST_DEST), { recursive: true });
    fs.writeFileSync(MANIFEST_DEST, JSON.stringify(projects, null, 2));

    console.log('--------------------------------------------------');
    console.log('📊 BUILD SUMMARY');
    console.log(`📦 Projects Processed : ${stats.projects}`);
    console.log(`🖼  Icons Discovered   : ${stats.icons}`);
    console.log(`📸 Images Discovered  : ${stats.images}`);

    if (stats.errors.length > 0) {
        console.log('\n⚠️  ISSUES FOUND:');
        stats.errors.forEach(e => console.log(`   - ${e}`));
    }

    console.log('--------------------------------------------------');
    console.log('🚀 Manifest generation complete. Ready for build.');
    console.log('--------------------------------------------------\n');
};

generateManifest();
