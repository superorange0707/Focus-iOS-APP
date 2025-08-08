'use client';

import { useTranslations, useLocale } from 'next-intl';
import { motion } from 'framer-motion';

export default function TermsPage() {
  const t = useTranslations();
  const locale = useLocale();

  const getTermsContent = () => {
    switch (locale) {
      case 'zh':
        return {
          title: 'SkipFeed 服务条款',
          lastUpdated: '生效日期：2025年7月24日',
          sections: [
            {
              title: '接受条款',
              content: '使用 SkipFeed 即表示您同意这些服务条款。'
            },
            {
              title: '服务描述',
              content: 'SkipFeed 是一个搜索聚合应用，帮助您在多个平台上进行高效搜索：',
              items: [
                'YouTube、Reddit、X (Twitter)、TikTok、Instagram、Facebook',
                '提供直接搜索和应用内浏览功能',
                '搜索历史和使用统计'
              ]
            },
            {
              title: '使用许可',
              content: '我们授予您有限的、非独占的、不可转让的许可来使用 SkipFeed。'
            },
            {
              title: '用户责任',
              content: '您同意：',
              items: [
                '遵守所有适用的法律法规',
                '不滥用或干扰服务',
                '不尝试逆向工程应用',
                '尊重第三方平台的服务条款'
              ]
            },
            {
              title: '知识产权',
              content: 'SkipFeed 及其所有内容均受版权和其他知识产权法保护。'
            },
            {
              title: '免责声明',
              content: 'SkipFeed 按"现状"提供，不提供任何明示或暗示的保证。'
            },
            {
              title: '责任限制',
              content: '在法律允许的最大范围内，我们不对任何间接、偶然或后果性损害承担责任。'
            },
            {
              title: '条款变更',
              content: '我们可能会更新这些条款。重大变更将通过应用内通知告知用户。'
            },
            {
              title: '联系信息',
              content: '如有问题，请联系：support@skipfeed.app'
            }
          ]
        };
      case 'es':
        return {
          title: 'Términos de Servicio de SkipFeed',
          lastUpdated: 'Fecha de vigencia: 24 de julio de 2025',
          sections: [
            {
              title: 'Aceptación de Términos',
              content: 'Al usar SkipFeed, aceptas estos Términos de Servicio.'
            },
            {
              title: 'Descripción del Servicio',
              content: 'SkipFeed es una app de agregación de búsquedas que te ayuda a buscar eficientemente en múltiples plataformas:',
              items: [
                'YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook',
                'Proporciona capacidades de búsqueda directa y navegación in-app',
                'Historial de búsquedas y análisis de uso'
              ]
            },
            {
              title: 'Licencia de Uso',
              content: 'Te otorgamos una licencia limitada, no exclusiva y no transferible para usar SkipFeed.'
            },
            {
              title: 'Responsabilidades del Usuario',
              content: 'Aceptas:',
              items: [
                'Cumplir con todas las leyes y regulaciones aplicables',
                'No abusar o interferir con el servicio',
                'No intentar hacer ingeniería inversa de la app',
                'Respetar los términos de servicio de plataformas de terceros'
              ]
            },
            {
              title: 'Propiedad Intelectual',
              content: 'SkipFeed y todo su contenido están protegidos por derechos de autor y otras leyes de propiedad intelectual.'
            },
            {
              title: 'Exenciones de Responsabilidad',
              content: 'SkipFeed se proporciona "tal como está" sin garantías expresas o implícitas.'
            },
            {
              title: 'Limitación de Responsabilidad',
              content: 'En la máxima medida permitida por la ley, no somos responsables de daños indirectos, incidentales o consecuentes.'
            },
            {
              title: 'Cambios en los Términos',
              content: 'Podemos actualizar estos términos. Los cambios significativos se comunicarán a través de notificaciones in-app.'
            },
            {
              title: 'Información de Contacto',
              content: 'Para preguntas, contacta: support@skipfeed.app'
            }
          ]
        };
      default:
        return {
          title: 'SkipFeed Terms of Service',
          lastUpdated: 'Effective Date: July 24, 2025',
          sections: [
            {
              title: 'Acceptance of Terms',
              content: 'By using SkipFeed, you agree to these Terms of Service.'
            },
            {
              title: 'Service Description',
              content: 'SkipFeed is a search aggregation app that helps you search efficiently across multiple platforms:',
              items: [
                'YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook',
                'Provides direct search and in-app browsing capabilities',
                'Search history and usage analytics'
              ]
            },
            {
              title: 'License to Use',
              content: 'We grant you a limited, non-exclusive, non-transferable license to use SkipFeed.'
            },
            {
              title: 'User Responsibilities',
              content: 'You agree to:',
              items: [
                'Comply with all applicable laws and regulations',
                'Not abuse or interfere with the service',
                'Not attempt to reverse engineer the app',
                'Respect third-party platform terms of service'
              ]
            },
            {
              title: 'Intellectual Property',
              content: 'SkipFeed and all its content are protected by copyright and other intellectual property laws.'
            },
            {
              title: 'Disclaimers',
              content: 'SkipFeed is provided "as is" without any express or implied warranties.'
            },
            {
              title: 'Limitation of Liability',
              content: 'To the maximum extent permitted by law, we are not liable for any indirect, incidental, or consequential damages.'
            },
            {
              title: 'Changes to Terms',
              content: 'We may update these terms. Significant changes will be communicated through in-app notifications.'
            },
            {
              title: 'Contact Information',
              content: 'For questions, contact: support@skipfeed.app'
            }
          ]
        };
    }
  };

  const content = getTermsContent();

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
                <p className="text-gray-700 mb-4 leading-relaxed">
                  {section.content}
                </p>
                {section.items && (
                  <ul className="space-y-2 text-gray-700">
                    {section.items.map((item, itemIndex) => (
                      <li key={itemIndex} className="flex items-start">
                        <span className="w-2 h-2 bg-blue-600 rounded-full mt-2 mr-3 flex-shrink-0"></span>
                        <span>{item}</span>
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
