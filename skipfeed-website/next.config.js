const withNextIntl = require('next-intl/plugin')('./src/i18n.ts');

/** @type {import('next').NextConfig} */
const nextConfig = {
  // 启用 standalone 输出以减小 Docker 镜像体积
  output: 'standalone',
  typescript: {
    // 跳过类型检查以加快构建
    ignoreBuildErrors: true,
  },
  eslint: {
    // 跳过 ESLint 检查以加快构建
    ignoreDuringBuilds: true,
  },
  // 禁用 SWC minification 以加快构建速度
  swcMinify: false,
  // 禁用 source maps 以加快构建速度
  productionBrowserSourceMaps: false,
  images: {
    domains: ['skipfeed.app'],
  },
  async redirects() {
    return [
      {
        source: '/',
        destination: '/en',
        permanent: true,
      },
    ];
  },
};

module.exports = withNextIntl(nextConfig);
