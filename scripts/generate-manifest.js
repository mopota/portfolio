const fs = require('fs');
const path = require('path');

const PROJECTS_DIR = path.join(__dirname, '../projects');
const OUTPUT_FILE = path.join(__dirname, '../src/data/projects-manifest.json');
const PUBLIC_PROJECTS_DIR = path.join(__dirname, '../public/projects');

// Ensure directories exist
if (!fs.existsSync(path.join(__dirname, '../src/data'))) {
    fs.mkdirSync(path.join(__dirname, '../src/data'), { recursive: true });
}

function getFiles(dir, extensions) {
    if (!fs.existsSync(dir)) return [];
    return fs.readdirSync(dir).filter(file =>
        extensions.includes(path.extname(file).toLowerCase())
    );
}

function generateManifest() {
    if (!fs.existsSync(PROJECTS_DIR)) {
        console.log('No projects directory found.');
        fs.writeFileSync(OUTPUT_FILE, JSON.stringify([], null, 2));
        return;
    }

    const projects = [];
    const projectFolders = fs.readdirSync(PROJECTS_DIR);

    projectFolders.forEach(folder => {
        const projectPath = path.join(PROJECTS_DIR, folder);
        if (!fs.lstatSync(projectPath).isDirectory()) return;

        const jsonPath = path.join(projectPath, 'project.json');
        if (!fs.existsSync(jsonPath)) return;

        const projectData = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));

        // Auto Icon Detection
        const iconDir = path.join(projectPath, 'icon');
        const iconFiles = getFiles(iconDir, ['.png', '.jpg', '.jpeg', '.webp', '.svg']);
        const icon = iconFiles.length > 0 ? `/projects/${folder}/icon/${iconFiles[0]}` : null;

        // Auto Screenshots Detection
        const screenshotsDir = path.join(projectPath, 'screenshots');
        const screenshotFiles = getFiles(screenshotsDir, ['.png', '.jpg', '.jpeg', '.webp', '.svg']);
        const screenshots = screenshotFiles.map(file => `/projects/${folder}/screenshots/${file}`);

        projects.push({
            ...projectData,
            id: folder,
            icon,
            screenshots
        });

        // In a real build, we'd need to copy these to public/projects
        // But for this setup, we'll assume the user might serve from public/projects
        // or we use a custom loader. Let's assume we copy them for simplicity in Next.js static export.
    });

    fs.writeFileSync(OUTPUT_FILE, JSON.stringify(projects, null, 2));
    console.log(`Manifest generated with ${projects.length} projects.`);
}

generateManifest();
