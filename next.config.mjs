/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  images: {
    unoptimized: true,
  },
  // Add base path if deploying to a subfolder on GH Pages
  // basePath: '/portfolio',
};

export default nextConfig;
