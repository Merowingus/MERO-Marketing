/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  async rewrites() {
    return [
      // Clean URL for the architecture map page (served from /public/architecture.html)
      { source: "/architecture", destination: "/architecture.html" },
    ];
  },
};

export default nextConfig;
