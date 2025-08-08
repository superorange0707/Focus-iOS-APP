'use client';

import { useTranslations } from 'next-intl';
import { motion } from 'framer-motion';
import { 
  MagnifyingGlassIcon, 
  ChartBarIcon, 
  DevicePhoneMobileIcon,
  GlobeAltIcon,
  BoltIcon,
  ShieldCheckIcon
} from '@heroicons/react/24/outline';

export default function HomePage() {
  const t = useTranslations();

  const features = [
    {
      icon: MagnifyingGlassIcon,
      title: t('homepage.features.search.title'),
      description: t('homepage.features.search.description'),
      color: 'from-blue-500 to-purple-600'
    },
    {
      icon: ChartBarIcon,
      title: t('homepage.features.analytics.title'),
      description: t('homepage.features.analytics.description'),
      color: 'from-green-500 to-blue-500'
    },
    {
      icon: DevicePhoneMobileIcon,
      title: t('homepage.features.widgets.title'),
      description: t('homepage.features.widgets.description'),
      color: 'from-purple-500 to-pink-500'
    },
    {
      icon: GlobeAltIcon,
      title: t('homepage.features.languages.title'),
      description: t('homepage.features.languages.description'),
      color: 'from-orange-500 to-red-500'
    },
    {
      icon: BoltIcon,
      title: t('homepage.features.efficiency.title'),
      description: t('homepage.features.efficiency.description'),
      color: 'from-yellow-500 to-orange-500'
    },
    {
      icon: ShieldCheckIcon,
      title: t('homepage.features.privacy.title'),
      description: t('homepage.features.privacy.description'),
      color: 'from-teal-500 to-green-500'
    }
  ];

  const platforms = [
    { name: 'YouTube', icon: '/images/platforms/youtube.png', color: 'bg-red-500' },
    { name: 'Reddit', icon: '/images/platforms/reddit.png', color: 'bg-orange-500' },
    { name: 'X (Twitter)', icon: '/images/platforms/x.png', color: 'bg-black' },
    { name: 'TikTok', icon: '/images/platforms/tiktok.png', color: 'bg-pink-500' },
    { name: 'Instagram', icon: '/images/platforms/instagram.png', color: 'bg-gradient-to-r from-purple-500 to-pink-500' },
    { name: 'Facebook', icon: '/images/platforms/facebook.png', color: 'bg-blue-600' }
  ];

  return (
    <div className="overflow-hidden">
      {/* Hero Section */}
      <section className="relative min-h-screen flex items-center justify-center px-4 sm:px-6 lg:px-8">
        <div className="absolute inset-0 bg-gradient-to-br from-blue-600/20 via-purple-600/20 to-pink-600/20" />
        <div className="relative max-w-7xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
          >
            <h1 className="text-5xl sm:text-7xl lg:text-8xl font-black bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-6">
              SkipFeed
            </h1>
            <h2 className="text-2xl sm:text-3xl lg:text-4xl font-bold text-gray-800 mb-8">
              {t('homepage.hero.subtitle')}
            </h2>
            <p className="text-lg sm:text-xl text-gray-600 mb-12 max-w-3xl mx-auto leading-relaxed">
              {t('homepage.hero.description')}
            </p>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.2 }}
            className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-16"
          >
            <a 
              href="https://apps.apple.com/app/skipfeed" 
              className="ios-button bg-black text-white px-8 py-4 rounded-2xl text-lg font-semibold shadow-lg flex items-center gap-3 min-w-[200px]"
            >
              <img src="/images/app-icon.png" alt="SkipFeed" className="w-6 h-6" />
              {t('homepage.buttons.appStore')}
            </a>
          </motion.div>

          {/* App Screenshot */}
          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 1, delay: 0.4 }}
            className="relative mx-auto max-w-xs sm:max-w-sm"
          >
            <div className="relative">
              <div className="absolute inset-0 bg-gradient-to-r from-blue-600 to-purple-600 rounded-[3rem] blur-2xl opacity-30 scale-105" />
              <div className="relative bg-black rounded-[3rem] p-2 shadow-2xl">
                <img 
                  src="/images/app/homepage_bright.png" 
                  alt="SkipFeed App Screenshot" 
                  className="w-full h-auto rounded-[2.5rem]"
                />
              </div>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Supported Platforms Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8 bg-white/50 backdrop-blur-sm">
        <div className="max-w-7xl mx-auto text-center">
          <motion.h2 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="text-3xl sm:text-4xl font-bold text-gray-800 mb-4"
          >
            {t('homepage.platforms.title')}
          </motion.h2>
          <motion.p 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.1 }}
            className="text-lg text-gray-600 mb-12 max-w-2xl mx-auto"
          >
            {t('homepage.platforms.description')}
          </motion.p>

          <div className="grid grid-cols-2 sm:grid-cols-4 gap-6">
            {platforms.map((platform, index) => (
              <motion.div
                key={platform.name}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                className="ios-card p-6 text-center group hover:scale-105 transition-all duration-300"
              >
                <div className={`w-16 h-16 mx-auto mb-4 rounded-2xl ${platform.color} flex items-center justify-center shadow-lg p-3`}>
                  <img 
                    src={platform.icon} 
                    alt={platform.name} 
                    className="w-10 h-10 object-contain"
                  />
                </div>
                <h3 className="font-semibold text-gray-800">{platform.name}</h3>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="text-center mb-16"
          >
            <h2 className="text-3xl sm:text-4xl font-bold text-gray-800 mb-4">
              {t('homepage.features.title')}
            </h2>
            <p className="text-lg text-gray-600 max-w-2xl mx-auto">
              {t('homepage.features.description')}
            </p>
          </motion.div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {features.map((feature, index) => (
              <motion.div
                key={feature.title}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: index * 0.1 }}
                className="ios-card p-8 group hover:scale-105 transition-all duration-300"
              >
                <div className={`w-16 h-16 bg-gradient-to-r ${feature.color} rounded-2xl flex items-center justify-center mb-6 shadow-lg`}>
                  <feature.icon className="w-8 h-8 text-white" />
                </div>
                <h3 className="text-xl font-bold text-gray-800 mb-4">{feature.title}</h3>
                <p className="text-gray-600 leading-relaxed">{feature.description}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8 bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600">
        <div className="max-w-4xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            <h2 className="text-3xl sm:text-4xl font-bold text-white mb-6">
              {t('homepage.cta.title')}
            </h2>
            <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
              {t('homepage.cta.description')}
            </p>
            <div className="flex justify-center">
              <a 
                href="https://apps.apple.com/app/skipfeed" 
                className="ios-button bg-white text-gray-800 px-8 py-4 rounded-2xl text-lg font-semibold shadow-lg flex items-center justify-center gap-3 min-w-[200px]"
              >
                <img src="/images/app-icon.png" alt="SkipFeed" className="w-6 h-6" />
                {t('homepage.buttons.downloadFree')}
              </a>
            </div>
          </motion.div>
        </div>
      </section>
    </div>
  );
}
