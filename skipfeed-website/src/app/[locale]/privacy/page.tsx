'use client';

import { useTranslations, useLocale } from 'next-intl';
import { motion } from 'framer-motion';

export default function PrivacyPage() {
  const t = useTranslations();
  const locale = useLocale();

  // Function to convert markdown bold (**text**) to HTML
  const formatText = (text: string) => {
    return text.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
  };

  const getPrivacyContent = () => {
    switch (locale) {
      case 'zh':
        return {
          title: 'SkipFeed 隐私政策',
          lastUpdated: '生效日期：2025年7月24日',
          sections: [
            {
              title: '我们收集的信息',
              content: 'SkipFeed 致力于保护您的隐私。我们设计应用时遵循数据最小化原则。'
            },
            {
              title: '本地存储的数据',
              items: [
                '**搜索历史**：您的搜索查询仅存储在您的设备上',
                '**使用统计**：搜索次数和使用时间等统计信息',
                '**应用设置**：语言偏好、平台顺序等个人设置'
              ]
            },
            {
              title: '我们不收集的信息',
              items: [
                '个人身份信息',
                '位置数据',
                '联系人信息',
                '设备标识符'
              ]
            },
            {
              title: '数据使用',
              content: '所有数据仅用于：',
              items: [
                '改善您的应用体验',
                '提供个性化搜索建议',
                '显示使用统计信息'
              ]
            },
            {
              title: '数据共享',
              content: '我们不会与第三方共享您的任何数据。您的搜索历史和使用数据完全保留在您的设备上。'
            },
            {
              title: '数据安全',
              items: [
                '所有数据使用 iOS 标准加密存储',
                '数据仅存储在您的设备本地',
                '我们无法访问您的任何个人数据'
              ]
            },
            {
              title: '您的权利',
              items: [
                '随时删除搜索历史',
                '重置使用统计数据',
                '完全卸载应用以删除所有数据'
              ]
            },
            {
              title: '联系我们',
              content: '如有隐私相关问题，请联系：support@skipfeed.app'
            }
          ]
        };
      case 'es':
        return {
          title: 'Política de Privacidad de SkipFeed',
          lastUpdated: 'Fecha de vigencia: 24 de julio de 2025',
          sections: [
            {
              title: 'Información que Recopilamos',
              content: 'SkipFeed está comprometido con proteger tu privacidad. Hemos diseñado nuestra app con la minimización de datos en mente.'
            },
            {
              title: 'Datos Almacenados Localmente',
              items: [
                '**Historial de Búsquedas**: Tus consultas de búsqueda se almacenan solo en tu dispositivo',
                '**Análisis de Uso**: Estadísticas como conteos de búsquedas y tiempo ahorrado',
                '**Preferencias de la App**: Configuraciones de idioma, orden de plataformas y otras preferencias personales'
              ]
            },
            {
              title: 'Información que NO Recopilamos',
              items: [
                'Información de identificación personal',
                'Datos de ubicación',
                'Información de contacto',
                'Identificadores del dispositivo'
              ]
            },
            {
              title: 'Cómo Usamos los Datos',
              content: 'Todos los datos se usan únicamente para:',
              items: [
                'Mejorar tu experiencia en la app',
                'Proporcionar sugerencias de búsqueda personalizadas',
                'Mostrar estadísticas de uso'
              ]
            },
            {
              title: 'Compartir Datos',
              content: 'No compartimos ninguno de tus datos con terceros. Tu historial de búsquedas y datos de uso permanecen completamente en tu dispositivo.'
            },
            {
              title: 'Seguridad de Datos',
              items: [
                'Todos los datos están encriptados usando el cifrado estándar de iOS',
                'Los datos se almacenan localmente solo en tu dispositivo',
                'No tenemos acceso a ninguno de tus datos personales'
              ]
            },
            {
              title: 'Tus Derechos',
              items: [
                'Eliminar el historial de búsquedas en cualquier momento',
                'Restablecer estadísticas de uso',
                'Desinstalar completamente la app para eliminar todos los datos'
              ]
            },
            {
              title: 'Contáctanos',
              content: 'Para preguntas relacionadas con privacidad, contacta: support@skipfeed.app'
            }
          ]
        };
      default:
        return {
          title: 'SkipFeed Privacy Policy',
          lastUpdated: 'Effective Date: July 24, 2025',
          sections: [
            {
              title: 'Information We Collect',
              content: 'SkipFeed is committed to protecting your privacy. We\'ve designed our app with data minimization in mind.'
            },
            {
              title: 'Data Stored Locally',
              items: [
                '**Search History**: Your search queries are stored only on your device',
                '**Usage Analytics**: Statistics like search counts and time saved',
                '**App Preferences**: Language settings, platform order, and other personal preferences'
              ]
            },
            {
              title: 'Information We Don\'t Collect',
              items: [
                'Personal identifying information',
                'Location data',
                'Contact information',
                'Device identifiers'
              ]
            },
            {
              title: 'How We Use Data',
              content: 'All data is used solely to:',
              items: [
                'Improve your app experience',
                'Provide personalized search suggestions',
                'Display usage statistics'
              ]
            },
            {
              title: 'Data Sharing',
              content: 'We do not share any of your data with third parties. Your search history and usage data remain completely on your device.'
            },
            {
              title: 'Data Security',
              items: [
                'All data is encrypted using iOS standard encryption',
                'Data is stored locally on your device only',
                'We have no access to any of your personal data'
              ]
            },
            {
              title: 'Your Rights',
              items: [
                'Delete search history at any time',
                'Reset usage statistics',
                'Completely uninstall the app to remove all data'
              ]
            },
            {
              title: 'Contact Us',
              content: 'For privacy-related questions, contact: support@skipfeed.app'
            }
          ]
        };
    }
  };

  const content = getPrivacyContent();

  return (
    <div className="min-h-screen py-16 px-4 sm:px-6 lg:px-8 bg-gradient-to-br from-blue-50 via-white to-purple-50">
      <div className="max-w-4xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="text-center mb-12"
        >
          <h1 className="text-4xl sm:text-5xl font-bold text-gray-900 mb-4">
            {content.title}
          </h1>
          <p className="text-lg text-gray-600">{content.lastUpdated}</p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.2 }}
          className="ios-card bg-white/80 backdrop-blur-md p-8 lg:p-12"
        >
          <div className="prose prose-lg max-w-none">
            {content.sections.map((section, index) => (
              <motion.div
                key={section.title}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.1 * index }}
                className="mb-8"
              >
                <h2 className="text-2xl font-bold text-gray-900 mb-4">
                  {section.title}
                </h2>
                {section.content && (
                  <p className="text-gray-700 mb-4 leading-relaxed">
                    {section.content}
                  </p>
                )}
                {section.items && (
                  <ul className="space-y-2 text-gray-700">
                    {section.items.map((item, itemIndex) => (
                      <li key={itemIndex} className="flex items-start">
                        <span className="w-2 h-2 bg-blue-600 rounded-full mt-2 mr-3 flex-shrink-0"></span>
                        <span dangerouslySetInnerHTML={{ __html: formatText(item) }} />
                      </li>
                    ))}
                  </ul>
                )}
              </motion.div>
            ))}
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, delay: 0.4 }}
          className="text-center mt-12"
        >
          <a
            href={`/${locale}`}
            className="ios-button bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-2xl text-lg font-semibold shadow-lg inline-flex items-center gap-3"
          >
            ← Back to Home
          </a>
        </motion.div>
      </div>
    </div>
  );
}
