import {NextIntlClientProvider} from 'next-intl';
import {getMessages, setRequestLocale} from 'next-intl/server';
import {notFound} from 'next/navigation';
import Navigation from '@/components/Navigation';
import Footer from '@/components/Footer';

const locales = ['en', 'zh', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'ja', 'ko', 'ar'];

export function generateStaticParams() {
  return locales.map((locale) => ({locale}));
}

export async function generateMetadata({params: {locale}}: {params: {locale: string}}) {
  const messages = await getMessages();
  
  return {
    title: messages.meta?.title || 'SkipFeed - Skip the scroll, find what matters',
    description: messages.meta?.description || 'Multi-platform search aggregation app for efficient content discovery',
    alternates: {
      canonical: `https://skipfeed.app/${locale}`,
      languages: {
        'en': 'https://skipfeed.app/en',
        'zh': 'https://skipfeed.app/zh',
        'es': 'https://skipfeed.app/es',
        'fr': 'https://skipfeed.app/fr',
        'de': 'https://skipfeed.app/de',
        'it': 'https://skipfeed.app/it',
        'pt': 'https://skipfeed.app/pt',
        'ru': 'https://skipfeed.app/ru',
        'ja': 'https://skipfeed.app/ja',
        'ko': 'https://skipfeed.app/ko',
        'ar': 'https://skipfeed.app/ar',
      }
    },
  };
}

export default async function LocaleLayout({
  children,
  params: {locale}
}: {
  children: React.ReactNode;
  params: {locale: string};
}) {
  // Validate locale
  if (!locales.includes(locale)) {
    notFound();
  }

  // Enable static rendering for next-intl
  setRequestLocale(locale);

  const messages = await getMessages();

  return (
    <html lang={locale} dir={locale === 'ar' ? 'rtl' : 'ltr'}>
      <body className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
        <NextIntlClientProvider messages={messages}>
          <Navigation />
          <main className="pt-16">
            {children}
          </main>
          <Footer />
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
