# SkipFeed Official Website

🌐 **Modern, multilingual website for the SkipFeed app**

![Next.js](https://img.shields.io/badge/Next.js-14.2.5-black)
![TypeScript](https://img.shields.io/badge/TypeScript-5.5.2-blue)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-3.4.4-38B2AC)
![Framer Motion](https://img.shields.io/badge/Framer_Motion-11.2.10-ff69b4)

## ✨ Features

- 🎨 **Modern iOS-style design** with glass morphism effects
- 🌍 **11 languages supported** with automatic detection
- 📱 **Fully responsive** mobile-first design
- ⚡ **Lightning fast** with Next.js 14 and SSG
- 🔒 **Privacy-focused** with complete App Store compliance
- 🎭 **Smooth animations** powered by Framer Motion
- 🚀 **Production-ready** with Docker and Nginx Proxy Manager support

## 🌐 Supported Languages

- 🇺🇸 English
- 🇨🇳 Chinese (中文)
- 🇪🇸 Spanish (Español)
- 🇫🇷 French (Français)
- 🇩🇪 German (Deutsch)
- 🇮🇹 Italian (Italiano)
- 🇵🇹 Portuguese (Português)
- 🇷🇺 Russian (Русский)
- 🇯🇵 Japanese (日本語)
- 🇰🇷 Korean (한국어)
- 🇸🇦 Arabic (العربية)

## 📱 Pages

- **Homepage** - Hero section, features, platform showcase
- **Support & FAQ** - Comprehensive help documentation
- **Privacy Policy** - Complete privacy documentation for App Store
- **Terms of Service** - Legal terms and conditions

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- Docker (for production deployment)
- Nginx Proxy Manager (recommended)

### Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Open browser
open http://localhost:3001
```

### Production Deployment

#### Option 1: Docker + Nginx Proxy Manager (Recommended)

```bash
# Make deployment script executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

#### Option 2: Manual Docker

```bash
# Build and run with Docker Compose
docker-compose up -d --build
```

#### Option 3: Build for Static Hosting

```bash
# Build for production
npm run build

# Start production server
npm start
```

## 🔧 Configuration

### Nginx Proxy Manager Setup

1. **Add Proxy Host:**
   - Domain: `skipfeed.app`
   - Forward Hostname: `skipfeed-website`
   - Forward Port: `3001`

2. **SSL Configuration:**
   - Force SSL: ✅ Yes
   - HTTP/2 Support: ✅ Yes
   - HSTS Enabled: ✅ Yes

3. **Custom Nginx Configuration:**
   Use the configuration from `nginx.conf` file

### Environment Variables

```bash
NODE_ENV=production
HOSTNAME=0.0.0.0
PORT=3001
```

## 📁 Project Structure

```
skipfeed-website/
├── 📁 src/
│   ├── 📁 app/
│   │   ├── 📁 [locale]/           # Internationalized routes
│   │   │   ├── page.tsx           # Homepage
│   │   │   ├── privacy/page.tsx   # Privacy Policy
│   │   │   ├── terms/page.tsx     # Terms of Service
│   │   │   ├── support/page.tsx   # Support & FAQ
│   │   │   └── layout.tsx         # Locale layout
│   │   └── globals.css            # Global styles
│   ├── 📁 components/
│   │   ├── Navigation.tsx         # Header navigation
│   │   ├── LanguageSwitcher.tsx   # Language dropdown
│   │   └── Footer.tsx             # Footer component
│   ├── 📁 messages/               # Translation files
│   │   ├── en.json
│   │   ├── zh.json
│   │   ├── es.json
│   │   └── ...
│   ├── i18n.ts                    # Internationalization config
│   └── middleware.ts              # Next.js middleware
├── 📁 public/                     # Static assets
├── Dockerfile                     # Docker configuration
├── docker-compose.yml             # Docker Compose setup
├── nginx.conf                     # Nginx configuration
├── deploy.sh                      # Deployment script
└── README.md
```

## 🎨 Design System

### Colors

- **Primary**: Blue to Purple gradient (`from-blue-600 to-purple-600`)
- **Background**: Soft gradient (`from-blue-50 via-white to-purple-50`)
- **Glass Effect**: `bg-white/10 backdrop-blur-md`

### Typography

- **Font Family**: SF Pro Display, -apple-system, system-ui
- **Headings**: Bold weights with gradient text effects
- **Body**: Clean, readable text with proper line spacing

### Components

- **iOS Cards**: Rounded corners with glass morphism
- **Buttons**: Hover and active state animations
- **Navigation**: Fixed header with blur background
- **Language Switcher**: Dropdown with flags and native names

## 📱 Responsive Design

- **Mobile First**: Optimized for mobile devices
- **Breakpoints**: sm, md, lg, xl following Tailwind CSS
- **Touch Friendly**: Large tap targets and smooth interactions
- **Performance**: Optimized images and lazy loading

## 🔒 Security & Privacy

- **HTTPS Only**: Force SSL redirection
- **Security Headers**: CSP, HSTS, X-Frame-Options
- **No Tracking**: Privacy-first approach
- **Local Data**: All analytics stay on device

## 🚀 Performance

- **Next.js 14**: Latest React features and optimizations
- **Static Generation**: Pre-rendered pages for maximum speed
- **Image Optimization**: Automatic image compression and formats
- **Code Splitting**: Automatic bundle optimization
- **Caching**: Browser and CDN caching strategies

## 📊 SEO Optimization

- **Meta Tags**: Complete OpenGraph and Twitter Card support
- **Structured Data**: Schema.org markup
- **Sitemap**: Automatic sitemap generation
- **Language Tags**: Proper hreflang implementation
- **Canonical URLs**: Duplicate content prevention

## 🌐 Deployment Options

### 1. Vercel (Easiest)
```bash
npm install -g vercel
vercel --prod
```

### 2. Your Server + Nginx Proxy Manager
```bash
./deploy.sh
```

### 3. Static Hosting (Netlify, Cloudflare Pages)
```bash
npm run build
# Upload .next/out folder
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For technical support or questions about the website:

- 📧 Email: support@skipfeed.app
- 🌐 Website: https://skipfeed.app
- 📱 App Store: [Download SkipFeed](https://apps.apple.com/app/skipfeed)

---

**Made with ❤️ for the SkipFeed community**
