# Mohamed Taha - Professional Portfolio

A premium, high-performance portfolio website built with Next.js, Tailwind CSS, and Framer Motion.

## 🚀 Key Features

- **Modern Visuals**: Glassmorphism, smooth animations, and a premium dark theme.
- **Auto-Discovery System**: Simply add a folder in `/projects` with a `project.json` and images, and it will be automatically added to the site.
- **Responsive Design**: Optimized for all devices from Mobile to 4K.
- **RTL Support**: Native support for Arabic and English.
- **SEO Optimized**: Built-in metadata, sitemap, and robots.txt.
- **CI/CD**: Automated deployment to GitHub Pages via GitHub Actions.

## 📂 Project Management

To add a new project:

1. Create a new folder in `/projects/[project-id]`.
2. Add a `project.json` file:
   ```json
   {
     "title": "Project Title",
     "shortDescription": "Short tagline",
     "description": "Full description",
     "version": "1.0.0",
     "category": "Mobile",
     "technologies": ["Flutter", "Firebase"],
     "featured": true
   }
   ```
3. (Optional) Add an `icon/` folder with your app icon.
4. (Optional) Add a `screenshots/` folder with your app screenshots.
5. Run `npm run generate` to update the manifest.

## 🛠️ Tech Stack

- **Framework**: Next.js 14 (App Router)
- **Styling**: Tailwind CSS
- **Animations**: Framer Motion
- **Icons**: Lucide React
- **Deployment**: GitHub Pages

## 📖 Getting Started

1. Install dependencies:
   ```bash
   npm install
   ```
2. Generate project manifest:
   ```bash
   npm run generate
   ```
3. Run development server:
   ```bash
   npm run dev
   ```
4. Build for production:
   ```bash
   npm run build
   ```
