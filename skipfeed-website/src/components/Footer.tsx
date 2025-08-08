'use client';

import { useTranslations } from 'next-intl';
import { useLocale } from 'next-intl';
import Link from 'next/link';

export default function Footer() {
  const t = useTranslations();
  const locale = useLocale();

  const footerLinks = [
    {
      title: t('footer.product.title'),
      links: [
        { href: `/${locale}`, label: t('footer.product.features') },
        { href: `/${locale}/support`, label: t('footer.product.support') },
        { href: 'https://apps.apple.com/app/skipfeed', label: t('footer.product.download') },
      ]
    },
    {
      title: t('footer.legal.title'),
      links: [
        { href: `/${locale}/privacy`, label: t('footer.legal.privacy') },
        { href: `/${locale}/terms`, label: t('footer.legal.terms') },
        { href: `mailto:support@skipfeed.app`, label: t('footer.legal.contact') },
      ]
    },
    {
      title: t('footer.social.title'),
      links: [
        { href: 'mailto:support@skipfeed.app', label: t('footer.social.email') },
      ]
    }
  ];

  return (
    <footer className="bg-gray-900 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {/* Brand */}
          <div className="lg:col-span-1">
            <Link href={`/${locale}`} className="flex items-center space-x-2 mb-6">
              <div className="w-8 h-8 rounded-lg flex items-center justify-center">
                <img src="/images/app-icon.png" alt="SkipFeed" className="w-8 h-8 rounded-lg" />
              </div>
              <span className="text-xl font-bold">SkipFeed</span>
            </Link>
            <p className="text-gray-400 mb-6 max-w-xs">
              {t('footer.description')}
            </p>
            <div className="flex space-x-4">
              <a 
                href="https://apps.apple.com/app/skipfeed" 
                className="bg-white text-gray-900 px-4 py-2 rounded-lg text-sm font-semibold hover:bg-gray-100 transition-colors duration-200 flex items-center gap-2"
              >
                <img src="/images/app-icon.png" alt="SkipFeed" className="w-4 h-4" />
                App Store
              </a>
            </div>
          </div>

          {/* Links */}
          {footerLinks.map((section) => (
            <div key={section.title}>
              <h3 className="text-lg font-semibold mb-4">{section.title}</h3>
              <ul className="space-y-3">
                {section.links.map((link) => (
                  <li key={link.href}>
                    {link.href.startsWith('http') || link.href.startsWith('mailto') ? (
                      <a
                        href={link.href}
                        className="text-gray-400 hover:text-white transition-colors duration-200"
                        target={link.href.startsWith('http') ? '_blank' : undefined}
                        rel={link.href.startsWith('http') ? 'noopener noreferrer' : undefined}
                      >
                        {link.label}
                      </a>
                    ) : (
                      <Link
                        href={link.href}
                        className="text-gray-400 hover:text-white transition-colors duration-200"
                      >
                        {link.label}
                      </Link>
                    )}
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="border-t border-gray-800 mt-16 pt-8 flex flex-col md:flex-row justify-between items-center">
          <p className="text-gray-400 text-sm">
            © {new Date().getFullYear()} SkipFeed. {t('footer.copyright')}
          </p>
          <div className="flex items-center space-x-6 mt-4 md:mt-0">
            <span className="text-gray-400 text-sm">{t('footer.madeWith')} ❤️</span>
          </div>
        </div>
      </div>
    </footer>
  );
}
