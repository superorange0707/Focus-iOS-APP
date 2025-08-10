'use client';

import { useTranslations, useLocale } from 'next-intl';
import { motion } from 'framer-motion';
import { 
  MagnifyingGlassIcon, 
  ChartBarIcon, 
  DevicePhoneMobileIcon,
  GlobeAltIcon,
  Cog6ToothIcon,
  QuestionMarkCircleIcon
} from '@heroicons/react/24/outline';

export default function SupportPage() {
  const t = useTranslations();
  const locale = useLocale();

  const getSupportContent = () => {
    switch (locale) {
      case 'zh':
        return {
          title: 'SkipFeed 支持和 FAQ',
          description: '找到您需要的答案',
          sections: [
            {
              title: '常见问题',
              icon: QuestionMarkCircleIcon,
              items: [
                {
                  question: '🔍 如何使用 SkipFeed？',
                  answer: '1. 选择要搜索的平台\n2. 输入关键词\n3. 点击搜索按钮\n4. 内容将在本机应用（如已安装）或浏览器中直接打开\n\n对于 Reddit：您可以选择直接模式（在 Reddit 应用/浏览器中打开）或应用内模式（在 SkipFeed 内浏览）'
                },
                {
                  question: '📱 支持哪些平台？',
                  answer: '• YouTube - 视频搜索\n• Reddit - 社区讨论（支持应用内浏览）\n• X (Twitter) - 实时更新\n• TikTok - 短视频发现\n• Instagram - 图片和视频\n• Facebook - 社交内容\n• Google - 网页搜索\n• Bing - 替代网页搜索'
                },
                {
                  question: '📊 如何访问统计数据？',
                  answer: '通过统计标签页访问全面的分析数据：\n• 导航到底部的统计标签页\n• 查看7天和30天搜索趋势\n• 总搜索次数和今日计数\n• 带图表的平台使用情况分析\n• 相比无限滚动节省的时间\n• 一天中不同时间的使用分析和洞察\n• 搜索历史可通过历史标签页访问'
                },
                {
                  question: '🏠 如何设置小组件？',
                  answer: '将 SkipFeed 小组件添加到主屏幕：\n• 小号组件：显示今日节省时间和搜索次数\n• 中号组件：显示详细统计和平台使用情况\n• 显示每日和总搜索次数\n• 实时计算节省的时间\n• 点击组件直接打开应用'
                },
                {
                  question: '🌍 语言自适应如何工作？',
                  answer: 'SkipFeed 会自动适应您的语言：\n• 根据系统语言/地区自动检测\n• 支持10+种语言，包括中文、英文、西班牙文、法文、德文、意大利文、葡萄牙文、俄文、日文、韩文\n• 可在设置中手动更改\n• 平台顺序会根据地区偏好调整'
                },
                {
                  question: '📤 如何导出我的数据？',
                  answer: '从设置中导出您的搜索历史和统计信息：\n• 进入设置 > 导出数据\n• 选择格式：CSV、TXT 或 JSON\n• 选择时间范围：最近7天、30天或全部时间\n• 选择要包含的内容：搜索查询、平台使用情况和/或统计数据\n• 点击"导出数据"来保存或分享文件\n\n非常适合备份数据或分析使用模式！'
                }
              ]
            },
            {
              title: '故障排除',
              icon: Cog6ToothIcon,
              items: [
                {
                  question: '搜索结果无法打开',
                  answer: '• 确保目标应用已安装\n• 检查网络连接\n• 对于 Reddit 尝试切换到直接模式\n• 尝试在浏览器中打开'
                },
                {
                  question: 'Reddit 应用内模式无法使用',
                  answer: '• 检查网络连接\n• 下拉列表刷新重试\n• 临时切换到直接模式\n• 如需要可清除搜索历史'
                },
                {
                  question: '小组件无法更新',
                  answer: '• 移除并重新添加小组件\n• 确保 SkipFeed 已启用后台应用刷新\n• 重启设备\n• 检查 iOS 设置中的小组件设置'
                }
              ]
            },
            {
              title: '联系支持',
              icon: GlobeAltIcon,
              items: [
                {
                  question: '需要更多帮助？',
                  answer: '如果您有其他问题或需要技术支持，请通过以下方式联系我们：\n\n📧 电子邮件：support@skipfeed.app\n⏱️ 响应时间：24-48小时\n\n我们会尽快回复您的问题！'
                }
              ]
            }
          ]
        };
      case 'es':
        return {
          title: 'SkipFeed Soporte y FAQ',
          description: 'Encuentra las respuestas que necesitas',
          sections: [
            {
              title: 'Preguntas Frecuentes',
              icon: QuestionMarkCircleIcon,
              items: [
                {
                  question: '🔍 ¿Cómo usar SkipFeed?',
                  answer: '1. Selecciona la plataforma que quieres buscar\n2. Ingresa tus palabras clave\n3. Toca el botón de búsqueda\n4. El contenido se abre directamente en la app nativa (si está instalada) o en el navegador\n\nPara Reddit: Puedes elegir entre modo Directo (abre en app/navegador Reddit) o modo En-App (navega dentro de SkipFeed)'
                },
                {
                  question: '📱 ¿Qué plataformas son compatibles?',
                  answer: '• YouTube - Búsqueda de videos\n• Reddit - Discusiones comunitarias (con navegación en-app)\n• X (Twitter) - Actualizaciones en tiempo real\n• TikTok - Descubrimiento de videos cortos\n• Instagram - Fotos y videos\n• Facebook - Contenido social\n• Google - Búsqueda web\n• Bing - Búsqueda web alternativa'
                },
                {
                  question: '📊 ¿Cómo acceder a la Vista de Datos?',
                  answer: 'Toca el ícono de gráfico en la esquina superior izquierda para ver análisis completos:\n• Total de búsquedas y conteo de hoy\n• Desglose de uso por plataforma\n• Tiempo ahorrado vs. desplazamiento infinito\n• Puntuación de enfoque e insights de eficiencia\n• Historial de búsquedas por fecha\n• Estadísticas específicas por plataforma'
                }
              ]
            },
            {
              title: 'Solución de Problemas',
              icon: Cog6ToothIcon,
              items: [
                {
                  question: 'Los resultados de búsqueda no se abren',
                  answer: '• Asegúrate de que la app de destino esté instalada\n• Verifica tu conexión a internet\n• Para Reddit, intenta cambiar al modo Directo\n• Intenta abrir en el navegador'
                },
                {
                  question: 'El modo En-App de Reddit no funciona',
                  answer: '• Verifica tu conexión a internet\n• Intenta actualizar deslizando hacia abajo en la lista\n• Cambia temporalmente al modo Directo\n• Limpia el historial de búsquedas si es necesario'
                }
              ]
            }
          ]
        };
      default:
        return {
          title: 'SkipFeed Support & FAQ',
          description: 'Find the answers you need',
          sections: [
            {
              title: 'Frequently Asked Questions',
              icon: QuestionMarkCircleIcon,
              items: [
                {
                  question: '🔍 How to use SkipFeed?',
                  answer: '1. Select the platform you want to search\n2. Enter your keywords\n3. Tap the search button\n4. Content opens directly in the native app (if installed) or browser\n\nFor Reddit: You can choose between Direct mode (opens in Reddit app/browser) or In-App mode (browse within SkipFeed)'
                },
                {
                  question: '📱 What platforms are supported?',
                  answer: '• YouTube - Video search\n• Reddit - Community discussions (with in-app browsing)\n• X (Twitter) - Real-time updates\n• TikTok - Short-form video discovery\n• Instagram - Photos and videos\n• Facebook - Social content\n• Google - Web search\n• Bing - Alternative web search'
                },
                {
                  question: '📊 How to access Statistics?',
                  answer: 'Access comprehensive analytics through the Stats tab:\n• Navigate to the Stats tab at the bottom\n• View 7-day and 30-day search trends\n• See total searches and today\'s count\n• Platform usage breakdown with charts\n• Time saved vs infinite scrolling\n• Time of day analysis and insights\n• Search history accessible via History tab'
                },
                {
                  question: '🏠 How to set up Widgets?',
                  answer: 'Add SkipFeed widgets to your home screen:\n• Small widget: Shows today\'s time saved and search count\n• Medium widget: Shows detailed stats and platform usage\n• Displays daily and total search counts\n• Real-time time saved calculations\n• Tap widget to open app directly'
                },
                {
                  question: '🌍 How does language adaptation work?',
                  answer: 'SkipFeed automatically adapts to your language:\n• Auto-detection based on system language/region\n• Supports 10+ languages including English, Chinese, Spanish, French, German, Italian, Portuguese, Russian, Japanese, Korean\n• Can be changed manually in Settings\n• Platform order adapts to regional preferences'
                },
                {
                  question: '📤 How to export my data?',
                  answer: 'Export your search history and statistics from Settings:\n• Go to Settings > Export Data\n• Choose format: CSV, TXT, or JSON\n• Select time range: Last 7 days, 30 days, or All time\n• Choose what to include: Search queries, platform usage, and/or statistics\n• Tap Export Data to save or share the file\n\nPerfect for backing up your data or analyzing your usage patterns!'
                }
              ]
            },
            {
              title: 'Troubleshooting',
              icon: Cog6ToothIcon,
              items: [
                {
                  question: 'Search results won\'t open',
                  answer: '• Make sure the target app is installed\n• Check your internet connection\n• For Reddit, try switching to Direct mode\n• Try opening in browser'
                },
                {
                  question: 'Reddit In-App mode not working',
                  answer: '• Check your internet connection\n• Try refreshing by pulling down on the list\n• Temporarily switch to Direct mode\n• Clear search history if needed'
                },
                {
                  question: 'Widget not updating',
                  answer: '• Remove and re-add the widget\n• Ensure SkipFeed has background app refresh enabled\n• Restart your device\n• Check widget settings in iOS Settings'
                }
              ]
            },
            {
              title: 'Contact Support',
              icon: GlobeAltIcon,
              items: [
                {
                  question: 'Need more help?',
                  answer: 'If you have other questions or need technical support, contact us:\n\n📧 Email: support@skipfeed.app\n⏱️ Response time: 24-48 hours\n\nWe\'ll get back to you as soon as possible!'
                }
              ]
            }
          ]
        };
    }
  };

  const content = getSupportContent();

  return (
    <div className="min-h-screen py-16 px-4 sm:px-6 lg:px-8 bg-gradient-to-br from-blue-50 via-white to-purple-50">
      <div className="max-w-6xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          className="text-center mb-12"
        >
          <h1 className="text-4xl sm:text-5xl font-bold text-gray-900 mb-4">
            {content.title}
          </h1>
          <p className="text-lg text-gray-600">{content.description}</p>
        </motion.div>

        <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-8">
          {content.sections.map((section, sectionIndex) => (
            <motion.div
              key={section.title}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: sectionIndex * 0.1 }}
              className="ios-card bg-white/80 backdrop-blur-md p-6 lg:p-8 h-fit"
            >
              <div className="flex items-center mb-6">
                <div className="w-12 h-12 bg-gradient-to-r from-blue-600 to-purple-600 rounded-xl flex items-center justify-center mr-4">
                  <section.icon className="w-6 h-6 text-white" />
                </div>
                <h2 className="text-2xl font-bold text-gray-900">{section.title}</h2>
              </div>

              <div className="space-y-6">
                {section.items.map((item, itemIndex) => (
                  <motion.div
                    key={itemIndex}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.4, delay: (sectionIndex * 0.1) + (itemIndex * 0.05) }}
                  >
                    <h3 className="text-lg font-semibold text-gray-800 mb-3">
                      {item.question}
                    </h3>
                    <div className="text-gray-600 leading-relaxed">
                      {item.answer.split('\n').map((line, lineIndex) => (
                        <p key={lineIndex} className={lineIndex > 0 ? 'mt-2' : ''}>
                          {line}
                        </p>
                      ))}
                    </div>
                  </motion.div>
                ))}
              </div>
            </motion.div>
          ))}
        </div>

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
