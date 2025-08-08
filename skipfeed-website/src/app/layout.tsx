import './globals.css'

export const metadata = {
  title: 'SkipFeed - Skip the scroll, find what matters',
  description: 'Multi-platform search aggregation app for efficient content discovery',
  keywords: 'search, social media, productivity, app, iOS, Android',
  authors: [{ name: 'SkipFeed Team' }],
  icons: {
    icon: [
      { url: '/images/app-icon.png', sizes: '1024x1024', type: 'image/png' },
      { url: '/icon-120.png', sizes: '120x120', type: 'image/png' },
      { url: '/icon-80.png', sizes: '80x80', type: 'image/png' },
      { url: '/icon-40.png', sizes: '40x40', type: 'image/png' },
    ],
    shortcut: '/images/app-icon.png',
    apple: [
      { url: '/images/app-icon.png', sizes: '1024x1024', type: 'image/png' },
      { url: '/icon-120.png', sizes: '120x120', type: 'image/png' },
    ],
  },
  openGraph: {
    title: 'SkipFeed - Skip the scroll, find what matters',
    description: 'Multi-platform search aggregation app for efficient content discovery',
    url: 'https://skipfeed.app',
    siteName: 'SkipFeed',
    locale: 'en_US',
    type: 'website',
    images: [
      {
        url: '/images/app-icon.png',
        width: 1024,
        height: 1024,
        alt: 'SkipFeed App Icon',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'SkipFeed - Skip the scroll, find what matters',
    description: 'Multi-platform search aggregation app for efficient content discovery',
    images: ['/images/app-icon.png'],
  },
  robots: {
    index: true,
    follow: true,
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html>
      <body>{children}</body>
    </html>
  )
}
