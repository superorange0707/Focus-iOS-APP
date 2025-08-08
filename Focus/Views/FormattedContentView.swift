import SwiftUI

struct FormattedPrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    getFormattedContent()
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func getFormattedContent() -> some View {
        switch localizationManager.currentLanguage {
        case "zh":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed 隐私政策")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("生效日期：2025年1月24日")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                SectionView(title: "我们收集的信息") {
                    Text("SkipFeed 致力于保护您的隐私。我们设计应用时遵循数据最小化原则。")
                        .font(.body)
                    
                    SubsectionView(title: "本地存储的数据") {
                        BulletPoint("搜索历史：您的搜索查询仅存储在您的设备上")
                        BulletPoint("使用统计：搜索次数和使用时间等统计信息")
                        BulletPoint("应用设置：语言偏好、平台顺序等个人设置")
                    }
                    
                    SubsectionView(title: "我们不收集的信息") {
                        BulletPoint("个人身份信息")
                        BulletPoint("位置数据")
                        BulletPoint("联系人信息")
                        BulletPoint("设备标识符")
                    }
                }
                
                SectionView(title: "数据使用") {
                    Text("所有数据仅用于：")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("改善您的应用体验")
                        BulletPoint("提供个性化搜索建议")
                        BulletPoint("显示使用统计信息")
                    }
                }
                
                SectionView(title: "数据共享") {
                    Text("我们不会与第三方共享您的任何数据。您的搜索历史和使用数据完全保留在您的设备上。")
                        .font(.body)
                }
                
                SectionView(title: "数据安全") {
                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("所有数据使用 iOS 标准加密存储")
                        BulletPoint("数据仅存储在您的设备本地")
                        BulletPoint("我们无法访问您的任何个人数据")
                    }
                }
                
                SectionView(title: "您的权利") {
                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("随时删除搜索历史")
                        BulletPoint("重置使用统计数据")
                        BulletPoint("完全卸载应用以删除所有数据")
                    }
                }
                
                SectionView(title: "联系我们") {
                    Text("如有隐私相关问题，请联系：support@skipfeed.app")
                        .font(.body)
                }
            }
        default:
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed Privacy Policy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Effective Date: July 24, 2025")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                SectionView(title: "Information We Collect") {
                    Text("SkipFeed is committed to protecting your privacy. We've designed our app with data minimization in mind.")
                        .font(.body)
                    
                    SubsectionView(title: "Data Stored Locally") {
                        BulletPoint("Search History: Your search queries are stored only on your device")
                        BulletPoint("Usage Analytics: Statistics like search counts and time saved")
                        BulletPoint("App Preferences: Language settings, platform order, and other personal preferences")
                    }
                    
                    SubsectionView(title: "Information We Don't Collect") {
                        BulletPoint("Personal identifying information")
                        BulletPoint("Location data")
                        BulletPoint("Contact information")
                        BulletPoint("Device identifiers")
                    }
                }
                
                SectionView(title: "How We Use Data") {
                    Text("All data is used solely to:")
                        .font(.body)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Improve your app experience")
                        BulletPoint("Provide personalized search suggestions")
                        BulletPoint("Display usage statistics")
                    }
                }
                
                SectionView(title: "Data Sharing") {
                    Text("We do not share any of your data with third parties. Your search history and usage data remain completely on your device.")
                        .font(.body)
                }
                
                SectionView(title: "Data Security") {
                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("All data is encrypted using iOS standard encryption")
                        BulletPoint("Data is stored locally on your device only")
                        BulletPoint("We have no access to any of your personal data")
                    }
                }
                
                SectionView(title: "Your Rights") {
                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Delete search history at any time")
                        BulletPoint("Reset usage statistics")
                        BulletPoint("Completely uninstall the app to remove all data")
                    }
                }
                
                SectionView(title: "Contact Us") {
                    Text("For privacy-related questions, contact: support@skipfeed.app")
                        .font(.body)
                }
            }
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            content
        }
    }
}

struct SubsectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top, 8)
            
            content
        }
    }
}

struct BulletPoint: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.body)
                .foregroundColor(.primary)
            Text(text)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct FormattedTermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var localizationManager: LocalizationManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    getFormattedContent()
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Terms of Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func getFormattedContent() -> some View {
        switch localizationManager.currentLanguage {
        case "zh":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed 服务条款")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("生效日期：2025年1月24日")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)

                SectionView(title: "接受条款") {
                    Text("使用 SkipFeed 即表示您同意这些服务条款。")
                        .font(.body)
                }

                SectionView(title: "服务描述") {
                    Text("SkipFeed 是一个搜索聚合应用，帮助您在多个平台上进行高效搜索：")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("YouTube、Reddit、X (Twitter)、TikTok、Instagram、Facebook")
                        BulletPoint("提供直接搜索和应用内浏览功能")
                        BulletPoint("搜索历史和使用统计")
                    }
                }

                SectionView(title: "使用许可") {
                    Text("我们授予您有限的、非独占的、不可转让的许可来使用 SkipFeed。")
                        .font(.body)
                }

                SectionView(title: "用户责任") {
                    Text("您同意：")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("遵守所有适用的法律法规")
                        BulletPoint("不滥用或干扰服务")
                        BulletPoint("不尝试逆向工程应用")
                        BulletPoint("尊重第三方平台的服务条款")
                    }
                }

                SectionView(title: "知识产权") {
                    Text("SkipFeed 及其所有内容均受版权和其他知识产权法保护。")
                        .font(.body)
                }

                SectionView(title: "免责声明") {
                    Text("SkipFeed 按\"现状\"提供，不提供任何明示或暗示的保证。")
                        .font(.body)
                }

                SectionView(title: "责任限制") {
                    Text("在法律允许的最大范围内，我们不对任何间接、偶然或后果性损害承担责任。")
                        .font(.body)
                }

                SectionView(title: "条款变更") {
                    Text("我们可能会更新这些条款。重大变更将通过应用内通知告知用户。")
                        .font(.body)
                }

                SectionView(title: "联系信息") {
                    Text("如有问题，请联系：support@skipfeed.app")
                        .font(.body)
                }
            }
        default:
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed Terms of Service")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Effective Date: July 24, 2025")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)

                SectionView(title: "Acceptance of Terms") {
                    Text("By using SkipFeed, you agree to these Terms of Service.")
                        .font(.body)
                }

                SectionView(title: "Service Description") {
                    Text("SkipFeed is a search aggregation app that helps you search efficiently across multiple platforms:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook")
                        BulletPoint("Provides direct search and in-app browsing capabilities")
                        BulletPoint("Search history and usage analytics")
                    }
                }

                SectionView(title: "License to Use") {
                    Text("We grant you a limited, non-exclusive, non-transferable license to use SkipFeed.")
                        .font(.body)
                }

                SectionView(title: "User Responsibilities") {
                    Text("You agree to:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Comply with all applicable laws and regulations")
                        BulletPoint("Not abuse or interfere with the service")
                        BulletPoint("Not attempt to reverse engineer the app")
                        BulletPoint("Respect third-party platform terms of service")
                    }
                }

                SectionView(title: "Intellectual Property") {
                    Text("SkipFeed and all its content are protected by copyright and other intellectual property laws.")
                        .font(.body)
                }

                SectionView(title: "Disclaimer") {
                    Text("SkipFeed is provided \"as is\" without any express or implied warranties.")
                        .font(.body)
                }

                SectionView(title: "Limitation of Liability") {
                    Text("To the maximum extent permitted by law, we are not liable for any indirect, incidental, or consequential damages.")
                        .font(.body)
                }

                SectionView(title: "Changes to Terms") {
                    Text("We may update these terms. Significant changes will be communicated through in-app notifications.")
                        .font(.body)
                }

                SectionView(title: "Contact Information") {
                    Text("For questions, contact: support@skipfeed.app")
                        .font(.body)
                }
            }
        }
    }
}

struct FormattedSupportFAQView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var localizationManager: LocalizationManager

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    getFormattedContent()
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
            .navigationTitle("Support & FAQ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func getFormattedContent() -> some View {
        switch localizationManager.currentLanguage {
        case "zh":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed 支持与常见问题")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "常见问题") {
                    FAQItem(
                        question: "🔍 如何使用 SkipFeed？",
                        answer: "1. 选择您想要搜索的平台\n2. 输入搜索关键词\n3. 点击搜索按钮\n4. 内容会直接在原生应用（如已安装）或浏览器中打开\n\nReddit 特别功能：您可以选择直接模式（在 Reddit 应用/浏览器中打开）或应用内模式（在 SkipFeed 内浏览）"
                    )

                    FAQItem(
                        question: "📱 支持哪些平台？",
                        answer: "• YouTube - 视频搜索\n• Reddit - 社区讨论（支持应用内浏览）\n• X (Twitter) - 实时动态\n• TikTok - 短视频发现\n• Instagram - 图片和视频\n• Facebook - 社交内容\n• Google - 网络搜索\n• Bing - 替代网络搜索"
                    )

                    FAQItem(
                        question: "📊 如何访问数据视图？",
                        answer: "点击左上角的图表图标查看全面的分析数据：\n• 总搜索次数和今日计数\n• 平台使用情况分析\n• 相比无限滚动节省的时间\n• 专注评分和效率洞察\n• 按日期查看搜索历史\n• 特定平台的使用统计"
                    )

                    FAQItem(
                        question: "🕒 搜索历史功能如何工作？",
                        answer: "在数据视图中访问完整的搜索历史：\n• 按日期组织查看搜索记录（今天、昨天、本周）\n• 在历史记录中搜索\n• 按特定平台筛选\n• 在日期分组和平铺列表视图间切换\n• 配置自动清理设置（7-365天）\n• 清除单个项目或全部历史"
                    )

                    FAQItem(
                        question: "🏠 如何设置小组件？",
                        answer: "将 SkipFeed 小组件添加到主屏幕：\n• 小号组件：显示今日节省时间和搜索次数\n• 中号组件：显示详细统计和平台使用情况\n• 显示每日和总搜索次数\n• 实时计算节省的时间\n• 点击组件直接打开应用"
                    )

                    FAQItem(
                        question: "🌍 语言自适应如何工作？",
                        answer: "SkipFeed 会自动适应您的语言：\n• 根据系统语言/地区自动检测\n• 支持10+种语言，包括中文、英文、西班牙文、法文、德文、意大利文、葡萄牙文、俄文、日文、韩文\n• 可在设置中手动更改\n• 平台顺序会根据地区偏好调整"
                    )

                    FAQItem(
                        question: "📈 平台排序如何工作？",
                        answer: "平台按钮会根据您的使用情况自动重新排序：\n• 最常用的平台会出现在前面\n• 适应您的个人搜索模式\n• 帮助您更快访问偏好的平台\n• 顺序会随时间动态更新"
                    )

                    FAQItem(
                        question: "🔄 直接模式和应用内模式有什么区别？",
                        answer: "选择您想要的内容浏览方式：\n• 直接模式：在原生应用或浏览器中打开内容（适用于所有平台）\n• 应用内模式：直接在 SkipFeed 内浏览 Reddit 内容，使用 API 集成\n\n注意：应用内模式目前仅适用于 Reddit，提供无缝浏览体验，包含完整的帖子详情、评论和媒体内容。"
                    )
                }

                SectionView(title: "故障排除") {
                    FAQItem(
                        question: "搜索结果无法打开",
                        answer: "• 确保目标应用已安装\n• 检查网络连接\n• 对于 Reddit 尝试切换到直接模式\n• 尝试在浏览器中打开"
                    )

                    FAQItem(
                        question: "Reddit 应用内模式无法使用",
                        answer: "• 检查网络连接\n• 下拉列表刷新重试\n• 临时切换到直接模式\n• 如需要可清除搜索历史"
                    )

                    FAQItem(
                        question: "小组件无法更新",
                        answer: "• 移除并重新添加小组件\n• 确保 SkipFeed 已启用后台应用刷新\n• 重启设备\n• 检查 iOS 设置中的小组件设置"
                    )

                    FAQItem(
                        question: "数据视图显示错误统计",
                        answer: "• 统计数据基于搜索历史计算\n• 如需要可清除并重建搜索历史\n• 确保使用最新版本\n• 如问题持续请联系技术支持"
                    )

                    FAQItem(
                        question: "语言切换不生效",
                        answer: "• 确保在设置中已选择正确的语言\n• 重启应用以应用更改\n• 检查系统语言设置\n• 尝试关闭并重新开启自动检测"
                    )

                    FAQItem(
                        question: "平台顺序没有更新",
                        answer: "• 平台顺序会根据使用情况随时间更新\n• 进行更多搜索以查看变化\n• 清除搜索历史后顺序可能会重置\n• 变化是渐进的，不会立即显现"
                    )
                }

                SectionView(title: "功能请求") {
                    Text("我们欢迎您的建议！如果您希望添加新功能或支持新平台，请联系我们。")
                        .font(.body)
                }

                SectionView(title: "技术支持") {
                    Text("如需进一步帮助，请联系：")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("邮箱：support@skipfeed.app")
                        BulletPoint("响应时间：24-48小时")
                    }
                }

                SectionView(title: "版本 1.0 功能") {
                    Text("当前版本包含的新功能：")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 全面的数据视图和使用分析")
                        BulletPoint("🕒 高级搜索历史，支持日期分组和筛选")
                        BulletPoint("🏠 主屏幕小组件，快速查看统计")
                        BulletPoint("🌍 自动语言适应（支持10+种语言）")
                        BulletPoint("📈 基于使用频率的动态平台排序")
                        BulletPoint("🔍 直接搜索到原生应用和浏览器")
                        BulletPoint("💬 Reddit 应用内浏览，集成 API")
                        BulletPoint("⏰ 时间节省计算和效率洞察")
                        BulletPoint("🎨 现代直观的界面设计")
                        BulletPoint("🔧 可自定义的自动清理设置")
                    }
                }
            }
        case "es":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed Soporte y Preguntas Frecuentes")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "Preguntas Frecuentes") {
                    FAQItem(
                        question: "🔍 ¿Cómo usar SkipFeed?",
                        answer: "1. Selecciona la plataforma que quieres buscar\n2. Ingresa tus palabras clave\n3. Toca el botón de búsqueda\n4. El contenido se abre directamente en la app nativa (si está instalada) o en el navegador\n\nPara Reddit: Puedes elegir entre modo Directo (abre en la app/navegador de Reddit) o modo In-App (navega dentro de SkipFeed)"
                    )

                    FAQItem(
                        question: "📱 ¿Qué plataformas están soportadas?",
                        answer: "• YouTube - Búsqueda de videos\n• Reddit - Discusiones comunitarias (con navegación in-app)\n• X (Twitter) - Actualizaciones en tiempo real\n• TikTok - Descubrimiento de videos cortos\n• Instagram - Fotos y videos\n• Facebook - Contenido social\n• Google - Búsqueda web\n• Bing - Búsqueda web alternativa"
                    )

                    FAQItem(
                        question: "📊 ¿Cómo acceder a la Vista de Datos?",
                        answer: "Toca el ícono de gráfico en la esquina superior izquierda para ver análisis completos:\n• Total de búsquedas y conteo de hoy\n• Desglose de uso por plataforma\n• Tiempo ahorrado vs desplazamiento infinito\n• Puntuación de enfoque e insights de eficiencia\n• Historial de búsquedas por fecha\n• Estadísticas específicas por plataforma"
                    )

                    FAQItem(
                        question: "🕒 ¿Cómo funciona el Historial de Búsquedas?",
                        answer: "Accede a tu historial completo en la Vista de Datos:\n• Ver búsquedas organizadas por fecha (Hoy, Ayer, Esta Semana)\n• Buscar dentro de tu historial\n• Filtrar por plataformas específicas\n• Alternar entre vistas agrupadas por fecha y lista plana\n• Configurar ajustes de limpieza automática (7-365 días)\n• Borrar elementos individuales o todo el historial"
                    )

                    FAQItem(
                        question: "🏠 ¿Cómo configurar Widgets?",
                        answer: "Agrega widgets de SkipFeed a tu pantalla de inicio:\n• Widget pequeño: Muestra tiempo ahorrado hoy y conteo de búsquedas\n• Widget mediano: Muestra estadísticas detalladas y uso de plataformas\n• Muestra conteos de búsquedas diarias y totales\n• Cálculos de tiempo ahorrado en tiempo real\n• Toca el widget para abrir la app"
                    )

                    FAQItem(
                        question: "🌍 ¿Cómo funciona la adaptación de idioma?",
                        answer: "SkipFeed se adapta automáticamente a tu idioma:\n• Auto-detecta basado en tu idioma/región del sistema\n• Soporta 10+ idiomas incluyendo inglés, chino, español, francés, alemán, italiano, portugués, ruso, japonés, coreano\n• Puede cambiarse manualmente en Configuración\n• El orden de plataformas se adapta según preferencias regionales"
                    )

                    FAQItem(
                        question: "📈 ¿Cómo funciona el ordenamiento de plataformas?",
                        answer: "Los botones de plataforma se reordenan automáticamente según tu uso:\n• Las plataformas más utilizadas aparecen primero\n• Se adapta a tus patrones de búsqueda personales\n• Te ayuda a acceder más rápido a tus plataformas preferidas\n• El orden se actualiza dinámicamente con el tiempo"
                    )

                    FAQItem(
                        question: "🔄 ¿Cuál es la diferencia entre modos Directo e In-App?",
                        answer: "Elige cómo quieres navegar el contenido:\n• Modo Directo: Abre contenido en apps nativas o navegador (disponible para todas las plataformas)\n• Modo In-App: Navega contenido de Reddit directamente dentro de SkipFeed con integración API\n\nNota: El modo In-App está actualmente disponible solo para Reddit y proporciona una experiencia de navegación fluida con detalles completos de posts, comentarios y medios."
                    )
                }

                SectionView(title: "Solución de Problemas") {
                    FAQItem(
                        question: "Los resultados de búsqueda no se abren",
                        answer: "• Asegúrate de que la app objetivo esté instalada\n• Verifica tu conexión a internet\n• Intenta cambiar a modo Directo para Reddit\n• Prueba abrir en el navegador"
                    )

                    FAQItem(
                        question: "El modo In-App de Reddit no funciona",
                        answer: "• Verifica tu conexión a internet\n• Intenta refrescar deslizando hacia abajo en la lista\n• Cambia temporalmente a modo Directo\n• Borra el historial de búsquedas si es necesario"
                    )

                    FAQItem(
                        question: "El widget no se actualiza",
                        answer: "• Quita y vuelve a agregar el widget\n• Asegúrate de que SkipFeed tenga la actualización en segundo plano habilitada\n• Reinicia tu dispositivo\n• Verifica la configuración del widget en Configuración de iOS"
                    )

                    FAQItem(
                        question: "La Vista de Datos muestra estadísticas incorrectas",
                        answer: "• Las estadísticas se calculan desde el historial de búsquedas\n• Borra y reconstruye el historial si es necesario\n• Asegúrate de usar la versión más reciente\n• Contacta soporte si los problemas persisten"
                    )

                    FAQItem(
                        question: "El cambio de idioma no funciona",
                        answer: "• Asegúrate de haber seleccionado el idioma correcto en Configuración\n• Reinicia la app para aplicar los cambios\n• Verifica la configuración de idioma del sistema\n• Intenta desactivar y reactivar la detección automática"
                    )

                    FAQItem(
                        question: "El orden de plataformas no se actualiza",
                        answer: "• El orden de plataformas se actualiza según el uso a lo largo del tiempo\n• Realiza más búsquedas para ver cambios\n• El orden puede restablecerse después de borrar el historial\n• Los cambios aparecen gradualmente, no inmediatamente"
                    )
                }

                SectionView(title: "Solicitudes de Características") {
                    Text("¡Damos la bienvenida a tus sugerencias! Si te gustaría nuevas características o soporte para plataformas, por favor contáctanos.")
                        .font(.body)
                }

                SectionView(title: "Soporte Técnico") {
                    Text("Para asistencia adicional, contacta:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Email: support@skipfeed.app")
                        BulletPoint("Tiempo de Respuesta: 24-48 horas")
                    }
                }

                SectionView(title: "Características de Versión 1.0") {
                    Text("La versión actual incluye:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 Vista de Datos completa con análisis de uso")
                        BulletPoint("🕒 Historial de Búsquedas avanzado con agrupación por fechas y filtros")
                        BulletPoint("🏠 Widgets de pantalla de inicio para acceso rápido a estadísticas")
                        BulletPoint("🌍 Adaptación automática de idioma (10+ idiomas)")
                        BulletPoint("📈 Ordenamiento dinámico de plataformas basado en uso")
                        BulletPoint("🔍 Búsqueda directa a apps nativas y navegadores")
                        BulletPoint("💬 Navegación In-App de Reddit")
                        BulletPoint("⏰ Cálculos de tiempo ahorrado e insights de eficiencia")
                        BulletPoint("🎨 Diseño de interfaz moderno e intuitivo")
                        BulletPoint("🔧 Configuraciones de limpieza automática personalizables")
                    }
                }
            }
        case "fr":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed Support et FAQ")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "Questions Fréquemment Posées") {
                    FAQItem(
                        question: "🔍 Comment utiliser SkipFeed ?",
                        answer: "1. Sélectionnez la plateforme que vous souhaitez rechercher\n2. Entrez vos mots-clés\n3. Appuyez sur le bouton de recherche\n4. Le contenu s'ouvre directement dans l'app native (si installée) ou dans le navigateur\n\nPour Reddit : Vous pouvez choisir entre le mode Direct (ouvre dans l'app/navigateur Reddit) ou le mode In-App (navigue dans SkipFeed)"
                    )

                    FAQItem(
                        question: "📱 Quelles plateformes sont supportées ?",
                        answer: "• YouTube - Recherche de vidéos\n• Reddit - Discussions communautaires (avec navigation in-app)\n• X (Twitter) - Mises à jour en temps réel\n• TikTok - Découverte de vidéos courtes\n• Instagram - Photos et vidéos\n• Facebook - Contenu social\n• Google - Recherche web\n• Bing - Recherche web alternative"
                    )

                    FAQItem(
                        question: "📊 Comment accéder à la Vue des Données ?",
                        answer: "Appuyez sur l'icône graphique en haut à gauche pour voir les analyses complètes :\n• Total des recherches et comptage d'aujourd'hui\n• Répartition d'utilisation par plateforme\n• Temps économisé vs défilement infini\n• Score de concentration et insights d'efficacité\n• Historique des recherches par date\n• Statistiques spécifiques par plateforme"
                    )

                    FAQItem(
                        question: "🕒 Comment fonctionne l'Historique des Recherches ?",
                        answer: "Accédez à votre historique complet dans la Vue des Données :\n• Voir les recherches organisées par date (Aujourd'hui, Hier, Cette Semaine)\n• Rechercher dans votre historique\n• Filtrer par plateformes spécifiques\n• Basculer entre les vues groupées par date et liste plate\n• Configurer les paramètres de nettoyage automatique (7-365 jours)\n• Effacer des éléments individuels ou tout l'historique"
                    )

                    FAQItem(
                        question: "🏠 Comment configurer les Widgets ?",
                        answer: "Ajoutez des widgets SkipFeed à votre écran d'accueil :\n• Petit widget : Affiche le temps économisé aujourd'hui et le comptage des recherches\n• Widget moyen : Affiche des statistiques détaillées et l'utilisation des plateformes\n• Affiche les comptages de recherches quotidiennes et totales\n• Calculs de temps économisé en temps réel\n• Appuyez sur le widget pour ouvrir l'app"
                    )

                    FAQItem(
                        question: "🌍 Comment fonctionne l'adaptation linguistique ?",
                        answer: "SkipFeed s'adapte automatiquement à votre langue :\n• Détection automatique basée sur votre langue/région système\n• Supporte 10+ langues incluant anglais, chinois, espagnol, français, allemand, italien, portugais, russe, japonais, coréen\n• Peut être changé manuellement dans les Paramètres\n• L'ordre des plateformes s'adapte selon les préférences régionales"
                    )

                    FAQItem(
                        question: "📈 Comment fonctionne l'ordre des plateformes ?",
                        answer: "Les boutons de plateforme se réorganisent automatiquement selon votre utilisation :\n• Les plateformes les plus utilisées apparaissent en premier\n• S'adapte à vos modèles de recherche personnels\n• Vous aide à accéder plus rapidement à vos plateformes préférées\n• L'ordre se met à jour dynamiquement au fil du temps"
                    )

                    FAQItem(
                        question: "🔄 Quelle est la différence entre les modes Direct et In-App ?",
                        answer: "Choisissez comment vous voulez naviguer le contenu :\n• Mode Direct : Ouvre le contenu dans les apps natives ou le navigateur (disponible pour toutes les plateformes)\n• Mode In-App : Navigue le contenu Reddit directement dans SkipFeed avec intégration API\n\nNote : Le mode In-App est actuellement disponible uniquement pour Reddit et fournit une expérience de navigation fluide avec les détails complets des posts, commentaires et médias."
                    )
                }

                SectionView(title: "Dépannage") {
                    FAQItem(
                        question: "Les résultats de recherche ne s'ouvrent pas",
                        answer: "• Assurez-vous que l'app cible est installée\n• Vérifiez votre connexion internet\n• Essayez de passer en mode Direct pour Reddit\n• Essayez d'ouvrir dans le navigateur"
                    )

                    FAQItem(
                        question: "Le mode In-App de Reddit ne fonctionne pas",
                        answer: "• Vérifiez votre connexion internet\n• Essayez de rafraîchir en glissant vers le bas sur la liste\n• Passez temporairement en mode Direct\n• Effacez l'historique de recherche si nécessaire"
                    )

                    FAQItem(
                        question: "Le widget ne se met pas à jour",
                        answer: "• Supprimez et rajoutez le widget\n• Assurez-vous que SkipFeed a l'actualisation en arrière-plan activée\n• Redémarrez votre appareil\n• Vérifiez les paramètres du widget dans les Réglages iOS"
                    )

                    FAQItem(
                        question: "La Vue des Données affiche des statistiques incorrectes",
                        answer: "• Les statistiques sont calculées à partir de l'historique de recherche\n• Effacez et reconstruisez l'historique si nécessaire\n• Assurez-vous d'utiliser la version la plus récente\n• Contactez le support si les problèmes persistent"
                    )

                    FAQItem(
                        question: "Le changement de langue ne fonctionne pas",
                        answer: "• Assurez-vous d'avoir sélectionné la bonne langue dans les Paramètres\n• Redémarrez l'app pour appliquer les changements\n• Vérifiez les paramètres de langue du système\n• Essayez de désactiver et réactiver la détection automatique"
                    )

                    FAQItem(
                        question: "L'ordre des plateformes ne se met pas à jour",
                        answer: "• L'ordre des plateformes se met à jour selon l'utilisation au fil du temps\n• Effectuez plus de recherches pour voir les changements\n• L'ordre peut se réinitialiser après avoir effacé l'historique\n• Les changements apparaissent graduellement, pas immédiatement"
                    )
                }

                SectionView(title: "Demandes de Fonctionnalités") {
                    Text("Nous accueillons vos suggestions ! Si vous aimeriez de nouvelles fonctionnalités ou le support de plateformes, veuillez nous contacter.")
                        .font(.body)
                }

                SectionView(title: "Support Technique") {
                    Text("Pour une assistance supplémentaire, contactez :")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Email : support@skipfeed.app")
                        BulletPoint("Temps de Réponse : 24-48 heures")
                    }
                }

                SectionView(title: "Fonctionnalités Version 1.0") {
                    Text("La version actuelle inclut :")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 Vue des Données complète avec analyses d'utilisation")
                        BulletPoint("🕒 Historique de Recherche avancé avec groupement par dates et filtres")
                        BulletPoint("🏠 Widgets d'écran d'accueil pour accès rapide aux statistiques")
                        BulletPoint("🌍 Adaptation automatique de langue (10+ langues)")
                        BulletPoint("📈 Ordre dynamique des plateformes basé sur l'utilisation")
                        BulletPoint("🔍 Recherche directe vers apps natives et navigateurs")
                        BulletPoint("💬 Navigation In-App Reddit")
                        BulletPoint("⏰ Calculs de temps économisé et insights d'efficacité")
                        BulletPoint("🎨 Design d'interface moderne et intuitif")
                        BulletPoint("🔧 Paramètres de nettoyage automatique personnalisables")
                    }
                }
            }
        case "de":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed Support & FAQ")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "Häufig gestellte Fragen") {
                    FAQItem(
                        question: "🔍 Wie verwende ich SkipFeed?",
                        answer: "1. Wählen Sie die Plattform aus, die Sie durchsuchen möchten\n2. Geben Sie Ihre Suchbegriffe ein\n3. Tippen Sie auf die Suchtaste\n4. Inhalte öffnen sich direkt in der nativen App (falls installiert) oder im Browser\n\nFür Reddit: Sie können zwischen dem Direktmodus (öffnet in Reddit App/Browser) oder dem In-App-Modus (navigiert innerhalb von SkipFeed) wählen"
                    )

                    FAQItem(
                        question: "📱 Welche Plattformen werden unterstützt?",
                        answer: "• YouTube - Video-Suche\n• Reddit - Community-Diskussionen (mit In-App-Navigation)\n• X (Twitter) - Echtzeit-Updates\n• TikTok - Kurzvideo-Entdeckung\n• Instagram - Fotos und Videos\n• Facebook - Soziale Inhalte\n• Google - Web-Suche\n• Bing - Alternative Web-Suche"
                    )

                    FAQItem(
                        question: "📊 Wie greife ich auf die Datenansicht zu?",
                        answer: "Tippen Sie auf das Diagramm-Symbol oben links, um umfassende Analysen zu sehen:\n• Gesamtsuchen und heutige Anzahl\n• Nutzungsaufschlüsselung nach Plattform\n• Gesparte Zeit vs. endloses Scrollen\n• Fokus-Score und Effizienz-Einblicke\n• Suchverlauf nach Datum\n• Plattformspezifische Statistiken"
                    )

                    FAQItem(
                        question: "🕒 Wie funktioniert der Suchverlauf?",
                        answer: "Greifen Sie auf Ihren vollständigen Verlauf in der Datenansicht zu:\n• Suchen nach Datum organisiert anzeigen (Heute, Gestern, Diese Woche)\n• In Ihrem Verlauf suchen\n• Nach spezifischen Plattformen filtern\n• Zwischen datumsgruppierter und flacher Listenansicht wechseln\n• Auto-Cleanup-Einstellungen konfigurieren (7-365 Tage)\n• Einzelne Elemente oder gesamten Verlauf löschen"
                    )

                    FAQItem(
                        question: "🏠 Wie richte ich Widgets ein?",
                        answer: "Fügen Sie SkipFeed-Widgets zu Ihrem Startbildschirm hinzu:\n• Kleines Widget: Zeigt heute gesparte Zeit und Suchanzahl\n• Mittleres Widget: Zeigt detaillierte Statistiken und Plattformnutzung\n• Zeigt tägliche und gesamte Suchanzahl\n• Echtzeit-Berechnungen der gesparten Zeit\n• Tippen Sie auf das Widget, um die App zu öffnen"
                    )

                    FAQItem(
                        question: "🌍 Wie funktioniert die Sprachanpassung?",
                        answer: "SkipFeed passt sich automatisch an Ihre Sprache an:\n• Auto-Erkennung basierend auf Ihrer System-Sprache/-Region\n• Unterstützt 10+ Sprachen einschließlich Englisch, Chinesisch, Spanisch, Französisch, Deutsch, Italienisch, Portugiesisch, Russisch, Japanisch, Koreanisch\n• Kann manuell in den Einstellungen geändert werden\n• Plattform-Reihenfolge passt sich an regionale Präferenzen an"
                    )

                    FAQItem(
                        question: "📈 Wie funktioniert die Plattform-Sortierung?",
                        answer: "Plattform-Schaltflächen ordnen sich automatisch nach Ihrer Nutzung um:\n• Die am häufigsten genutzten Plattformen erscheinen zuerst\n• Passt sich an Ihre persönlichen Suchmuster an\n• Hilft Ihnen, schneller auf Ihre bevorzugten Plattformen zuzugreifen\n• Reihenfolge aktualisiert sich dynamisch über die Zeit"
                    )

                    FAQItem(
                        question: "🔄 Was ist der Unterschied zwischen Direkt- und In-App-Modi?",
                        answer: "Wählen Sie, wie Sie Inhalte durchsuchen möchten:\n• Direktmodus: Öffnet Inhalte in nativen Apps oder Browser (verfügbar für alle Plattformen)\n• In-App-Modus: Navigiert Reddit-Inhalte direkt innerhalb von SkipFeed mit API-Integration\n\nHinweis: Der In-App-Modus ist derzeit nur für Reddit verfügbar und bietet eine nahtlose Browser-Erfahrung mit vollständigen Post-Details, Kommentaren und Medien."
                    )
                }

                SectionView(title: "Fehlerbehebung") {
                    FAQItem(
                        question: "Suchergebnisse öffnen sich nicht",
                        answer: "• Stellen Sie sicher, dass die Ziel-App installiert ist\n• Überprüfen Sie Ihre Internetverbindung\n• Versuchen Sie für Reddit zum Direktmodus zu wechseln\n• Versuchen Sie im Browser zu öffnen"
                    )

                    FAQItem(
                        question: "Reddit In-App-Modus funktioniert nicht",
                        answer: "• Überprüfen Sie Ihre Internetverbindung\n• Versuchen Sie zu aktualisieren, indem Sie die Liste nach unten ziehen\n• Wechseln Sie vorübergehend zum Direktmodus\n• Löschen Sie bei Bedarf den Suchverlauf"
                    )

                    FAQItem(
                        question: "Widget aktualisiert sich nicht",
                        answer: "• Entfernen Sie das Widget und fügen Sie es erneut hinzu\n• Stellen Sie sicher, dass SkipFeed die Hintergrund-App-Aktualisierung aktiviert hat\n• Starten Sie Ihr Gerät neu\n• Überprüfen Sie die Widget-Einstellungen in den iOS-Einstellungen"
                    )

                    FAQItem(
                        question: "Datenansicht zeigt falsche Statistiken",
                        answer: "• Statistiken werden aus dem Suchverlauf berechnet\n• Löschen Sie bei Bedarf den Verlauf und erstellen Sie ihn neu\n• Stellen Sie sicher, dass Sie die neueste Version verwenden\n• Kontaktieren Sie den Support, wenn Probleme bestehen bleiben"
                    )

                    FAQItem(
                        question: "Sprachwechsel funktioniert nicht",
                        answer: "• Stellen Sie sicher, dass Sie die richtige Sprache in den Einstellungen ausgewählt haben\n• Starten Sie die App neu, um Änderungen anzuwenden\n• Überprüfen Sie Ihre System-Spracheinstellungen\n• Versuchen Sie, die automatische Erkennung aus- und wieder einzuschalten"
                    )

                    FAQItem(
                        question: "Plattform-Reihenfolge aktualisiert sich nicht",
                        answer: "• Plattform-Reihenfolge aktualisiert sich basierend auf Nutzung über die Zeit\n• Führen Sie mehr Suchen durch, um Änderungen zu sehen\n• Reihenfolge kann sich nach dem Löschen des Verlaufs zurücksetzen\n• Änderungen erscheinen allmählich, nicht sofort"
                    )
                }

                SectionView(title: "Feature-Anfragen") {
                    Text("Wir begrüßen Ihre Vorschläge! Wenn Sie neue Features oder Plattform-Support wünschen, kontaktieren Sie uns bitte.")
                        .font(.body)
                }

                SectionView(title: "Technischer Support") {
                    Text("Für weitere Unterstützung kontaktieren Sie:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("E-Mail: support@skipfeed.app")
                        BulletPoint("Antwortzeit: 24-48 Stunden")
                    }
                }

                SectionView(title: "Version 1.0 Features") {
                    Text("Die aktuelle Version umfasst:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 Umfassende Datenansicht mit Nutzungsanalysen")
                        BulletPoint("🕒 Erweiterte Suchhistorie mit Datumsgruppierung und Filtern")
                        BulletPoint("🏠 Startbildschirm-Widgets für schnellen Statistik-Zugriff")
                        BulletPoint("🌍 Automatische Sprachanpassung (10+ Sprachen)")
                        BulletPoint("📈 Dynamische Plattform-Sortierung basierend auf Nutzung")
                        BulletPoint("🔍 Direkte Suche zu nativen Apps und Browsern")
                        BulletPoint("💬 Reddit In-App-Navigation")
                        BulletPoint("⏰ Gesparte Zeit-Berechnungen und Effizienz-Einblicke")
                        BulletPoint("🎨 Modernes, intuitives Interface-Design")
                        BulletPoint("🔧 Anpassbare Auto-Cleanup-Einstellungen")
                    }
                }
            }
        case "it":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed Supporto e FAQ")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "Domande Frequenti") {
                    FAQItem(
                        question: "🔍 Come usare SkipFeed?",
                        answer: "1. Seleziona la piattaforma che vuoi cercare\n2. Inserisci le tue parole chiave\n3. Tocca il pulsante di ricerca\n4. I contenuti si aprono direttamente nell'app nativa (se installata) o nel browser\n\nPer Reddit: Puoi scegliere tra modalità Diretta (apre nell'app/browser Reddit) o modalità In-App (naviga all'interno di SkipFeed)"
                    )

                    FAQItem(
                        question: "📱 Quali piattaforme sono supportate?",
                        answer: "• YouTube - Ricerca video\n• Reddit - Discussioni della comunità (con navigazione in-app)\n• X (Twitter) - Aggiornamenti in tempo reale\n• TikTok - Scoperta video brevi\n• Instagram - Foto e video\n• Facebook - Contenuti social\n• Google - Ricerca web\n• Bing - Ricerca web alternativa"
                    )

                    FAQItem(
                        question: "📊 Come accedere alla Vista Dati?",
                        answer: "Tocca l'icona del grafico in alto a sinistra per vedere analisi complete:\n• Ricerche totali e conteggio di oggi\n• Suddivisione utilizzo per piattaforma\n• Tempo risparmiato vs scorrimento infinito\n• Punteggio di concentrazione e insight di efficienza\n• Cronologia ricerche per data\n• Statistiche specifiche per piattaforma"
                    )

                    FAQItem(
                        question: "🕒 Come funziona la Cronologia Ricerche?",
                        answer: "Accedi alla tua cronologia completa nella Vista Dati:\n• Visualizza ricerche organizzate per data (Oggi, Ieri, Questa Settimana)\n• Cerca nella tua cronologia\n• Filtra per piattaforme specifiche\n• Alterna tra visualizzazioni raggruppate per data e lista piatta\n• Configura impostazioni di pulizia automatica (7-365 giorni)\n• Cancella elementi individuali o tutta la cronologia"
                    )

                    FAQItem(
                        question: "🏠 Come configurare i Widget?",
                        answer: "Aggiungi widget SkipFeed alla tua schermata principale:\n• Widget piccolo: Mostra tempo risparmiato oggi e conteggio ricerche\n• Widget medio: Mostra statistiche dettagliate e utilizzo piattaforme\n• Mostra conteggi ricerche giornaliere e totali\n• Calcoli tempo risparmiato in tempo reale\n• Tocca il widget per aprire l'app"
                    )

                    FAQItem(
                        question: "🌍 Come funziona l'adattamento linguistico?",
                        answer: "SkipFeed si adatta automaticamente alla tua lingua:\n• Rilevamento automatico basato sulla lingua/regione del sistema\n• Supporta 10+ lingue inclusi inglese, cinese, spagnolo, francese, tedesco, italiano, portoghese, russo, giapponese, coreano\n• Può essere cambiato manualmente nelle Impostazioni\n• L'ordine delle piattaforme si adatta alle preferenze regionali"
                    )

                    FAQItem(
                        question: "📈 Come funziona l'ordinamento delle piattaforme?",
                        answer: "I pulsanti delle piattaforme si riordinano automaticamente in base al tuo utilizzo:\n• Le piattaforme più utilizzate appaiono per prime\n• Si adatta ai tuoi modelli di ricerca personali\n• Ti aiuta ad accedere più velocemente alle tue piattaforme preferite\n• L'ordine si aggiorna dinamicamente nel tempo"
                    )

                    FAQItem(
                        question: "🔄 Qual è la differenza tra modalità Diretta e In-App?",
                        answer: "Scegli come vuoi navigare i contenuti:\n• Modalità Diretta: Apre contenuti nelle app native o browser (disponibile per tutte le piattaforme)\n• Modalità In-App: Naviga contenuti Reddit direttamente all'interno di SkipFeed con integrazione API\n\nNota: La modalità In-App è attualmente disponibile solo per Reddit e fornisce un'esperienza di navigazione fluida con dettagli completi di post, commenti e media."
                    )
                }

                SectionView(title: "Risoluzione Problemi") {
                    FAQItem(
                        question: "I risultati di ricerca non si aprono",
                        answer: "• Assicurati che l'app di destinazione sia installata\n• Controlla la tua connessione internet\n• Prova a passare alla modalità Diretta per Reddit\n• Prova ad aprire nel browser"
                    )

                    FAQItem(
                        question: "La modalità In-App di Reddit non funziona",
                        answer: "• Controlla la tua connessione internet\n• Prova ad aggiornare trascinando verso il basso sulla lista\n• Passa temporaneamente alla modalità Diretta\n• Cancella la cronologia ricerche se necessario"
                    )

                    FAQItem(
                        question: "Il widget non si aggiorna",
                        answer: "• Rimuovi e riaggiunge il widget\n• Assicurati che SkipFeed abbia l'aggiornamento app in background abilitato\n• Riavvia il tuo dispositivo\n• Controlla le impostazioni widget nelle Impostazioni iOS"
                    )

                    FAQItem(
                        question: "La Vista Dati mostra statistiche errate",
                        answer: "• Le statistiche sono calcolate dalla cronologia ricerche\n• Cancella e ricostruisci la cronologia se necessario\n• Assicurati di usare la versione più recente\n• Contatta il supporto se i problemi persistono"
                    )

                    FAQItem(
                        question: "Il cambio lingua non funziona",
                        answer: "• Assicurati di aver selezionato la lingua corretta nelle Impostazioni\n• Riavvia l'app per applicare le modifiche\n• Controlla le impostazioni lingua del sistema\n• Prova a disattivare e riattivare il rilevamento automatico"
                    )

                    FAQItem(
                        question: "L'ordine delle piattaforme non si aggiorna",
                        answer: "• L'ordine delle piattaforme si aggiorna basandosi sull'utilizzo nel tempo\n• Effettua più ricerche per vedere i cambiamenti\n• L'ordine può reimpostarsi dopo aver cancellato la cronologia\n• I cambiamenti appaiono gradualmente, non immediatamente"
                    )
                }

                SectionView(title: "Richieste Funzionalità") {
                    Text("Accogliamo i tuoi suggerimenti! Se desideri nuove funzionalità o supporto per piattaforme, contattaci.")
                        .font(.body)
                }

                SectionView(title: "Supporto Tecnico") {
                    Text("Per ulteriore assistenza, contatta:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Email: support@skipfeed.app")
                        BulletPoint("Tempo di Risposta: 24-48 ore")
                    }
                }

                SectionView(title: "Funzionalità Versione 1.0") {
                    Text("La versione attuale include:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 Vista Dati completa con analisi di utilizzo")
                        BulletPoint("🕒 Cronologia Ricerche avanzata con raggruppamento per date e filtri")
                        BulletPoint("🏠 Widget schermata principale per accesso rapido alle statistiche")
                        BulletPoint("🌍 Adattamento automatico lingua (10+ lingue)")
                        BulletPoint("📈 Ordinamento dinamico piattaforme basato sull'utilizzo")
                        BulletPoint("🔍 Ricerca diretta verso app native e browser")
                        BulletPoint("💬 Navigazione In-App Reddit")
                        BulletPoint("⏰ Calcoli tempo risparmiato e insight efficienza")
                        BulletPoint("🎨 Design interfaccia moderno e intuitivo")
                        BulletPoint("🔧 Impostazioni pulizia automatica personalizzabili")
                    }
                }
            }
        case "pt":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed Suporte e FAQ")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "Perguntas Frequentes") {
                    FAQItem(
                        question: "🔍 Como usar o SkipFeed?",
                        answer: "1. Selecione a plataforma que deseja pesquisar\n2. Digite suas palavras-chave\n3. Toque no botão de pesquisa\n4. O conteúdo abre diretamente no app nativo (se instalado) ou no navegador\n\nPara Reddit: Você pode escolher entre modo Direto (abre no app/navegador Reddit) ou modo In-App (navega dentro do SkipFeed)"
                    )

                    FAQItem(
                        question: "📱 Quais plataformas são suportadas?",
                        answer: "• YouTube - Pesquisa de vídeos\n• Reddit - Discussões da comunidade (com navegação in-app)\n• X (Twitter) - Atualizações em tempo real\n• TikTok - Descoberta de vídeos curtos\n• Instagram - Fotos e vídeos\n• Facebook - Conteúdo social\n• Google - Pesquisa web\n• Bing - Pesquisa web alternativa"
                    )

                    FAQItem(
                        question: "📊 Como acessar a Visualização de Dados?",
                        answer: "Toque no ícone de gráfico no canto superior esquerdo para ver análises completas:\n• Total de pesquisas e contagem de hoje\n• Divisão de uso por plataforma\n• Tempo economizado vs rolagem infinita\n• Pontuação de foco e insights de eficiência\n• Histórico de pesquisas por data\n• Estatísticas específicas por plataforma"
                    )

                    FAQItem(
                        question: "🕒 Como funciona o Histórico de Pesquisas?",
                        answer: "Acesse seu histórico completo na Visualização de Dados:\n• Ver pesquisas organizadas por data (Hoje, Ontem, Esta Semana)\n• Pesquisar dentro do seu histórico\n• Filtrar por plataformas específicas\n• Alternar entre visualizações agrupadas por data e lista simples\n• Configurar ajustes de limpeza automática (7-365 dias)\n• Limpar itens individuais ou todo o histórico"
                    )

                    FAQItem(
                        question: "🏠 Como configurar Widgets?",
                        answer: "Adicione widgets do SkipFeed à sua tela inicial:\n• Widget pequeno: Mostra tempo economizado hoje e contagem de pesquisas\n• Widget médio: Mostra estatísticas detalhadas e uso de plataformas\n• Mostra contagens de pesquisas diárias e totais\n• Cálculos de tempo economizado em tempo real\n• Toque no widget para abrir o app"
                    )

                    FAQItem(
                        question: "🌍 Como funciona a adaptação de idioma?",
                        answer: "O SkipFeed se adapta automaticamente ao seu idioma:\n• Detecção automática baseada no idioma/região do sistema\n• Suporta 10+ idiomas incluindo inglês, chinês, espanhol, francês, alemão, italiano, português, russo, japonês, coreano\n• Pode ser alterado manualmente nas Configurações\n• A ordem das plataformas se adapta às preferências regionais"
                    )

                    FAQItem(
                        question: "📈 Como funciona a ordenação de plataformas?",
                        answer: "Os botões das plataformas se reorganizam automaticamente com base no seu uso:\n• As plataformas mais usadas aparecem primeiro\n• Se adapta aos seus padrões de pesquisa pessoais\n• Ajuda você a acessar suas plataformas preferidas mais rapidamente\n• A ordem se atualiza dinamicamente ao longo do tempo"
                    )

                    FAQItem(
                        question: "🔄 Qual é a diferença entre modos Direto e In-App?",
                        answer: "Escolha como você quer navegar o conteúdo:\n• Modo Direto: Abre conteúdo em apps nativos ou navegador (disponível para todas as plataformas)\n• Modo In-App: Navega conteúdo do Reddit diretamente dentro do SkipFeed com integração API\n\nNota: O modo In-App está atualmente disponível apenas para Reddit e fornece uma experiência de navegação fluida com detalhes completos de posts, comentários e mídia."
                    )
                }

                SectionView(title: "Solução de Problemas") {
                    FAQItem(
                        question: "Resultados de pesquisa não abrem",
                        answer: "• Certifique-se de que o app de destino está instalado\n• Verifique sua conexão com a internet\n• Tente mudar para modo Direto para Reddit\n• Tente abrir no navegador"
                    )

                    FAQItem(
                        question: "Modo In-App do Reddit não funciona",
                        answer: "• Verifique sua conexão com a internet\n• Tente atualizar puxando para baixo na lista\n• Mude temporariamente para modo Direto\n• Limpe o histórico de pesquisas se necessário"
                    )

                    FAQItem(
                        question: "Widget não atualiza",
                        answer: "• Remova e adicione o widget novamente\n• Certifique-se de que o SkipFeed tem atualização de app em segundo plano habilitada\n• Reinicie seu dispositivo\n• Verifique as configurações do widget nas Configurações do iOS"
                    )
                }

                SectionView(title: "Suporte Técnico") {
                    Text("Para assistência adicional, contate:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Email: support@skipfeed.app")
                        BulletPoint("Tempo de Resposta: 24-48 horas")
                    }
                }

                SectionView(title: "Recursos Versão 1.0") {
                    Text("A versão atual inclui:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 Visualização de Dados completa com análises de uso")
                        BulletPoint("🕒 Histórico de Pesquisas avançado com agrupamento por datas e filtros")
                        BulletPoint("🏠 Widgets de tela inicial para acesso rápido às estatísticas")
                        BulletPoint("🌍 Adaptação automática de idioma (10+ idiomas)")
                        BulletPoint("📈 Ordenação dinâmica de plataformas baseada no uso")
                        BulletPoint("🔍 Pesquisa direta para apps nativos e navegadores")
                        BulletPoint("💬 Navegação In-App do Reddit")
                        BulletPoint("⏰ Cálculos de tempo economizado e insights de eficiência")
                        BulletPoint("🎨 Design de interface moderno e intuitivo")
                        BulletPoint("🔧 Configurações de limpeza automática personalizáveis")
                    }
                }
            }
        case "ru":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed Поддержка и FAQ")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "Часто Задаваемые Вопросы") {
                    FAQItem(
                        question: "🔍 Как использовать SkipFeed?",
                        answer: "1. Выберите платформу для поиска\n2. Введите ключевые слова\n3. Нажмите кнопку поиска\n4. Контент открывается прямо в нативном приложении (если установлено) или браузере\n\nДля Reddit: Вы можете выбрать между режимом Прямой (открывает в приложении/браузере Reddit) или режимом В-Приложении (навигация внутри SkipFeed)"
                    )

                    FAQItem(
                        question: "📱 Какие платформы поддерживаются?",
                        answer: "• YouTube - Поиск видео\n• Reddit - Обсуждения сообщества (с навигацией в приложении)\n• X (Twitter) - Обновления в реальном времени\n• TikTok - Открытие коротких видео\n• Instagram - Фото и видео\n• Facebook - Социальный контент\n• Google - Веб-поиск\n• Bing - Альтернативный веб-поиск"
                    )

                    FAQItem(
                        question: "📊 Как получить доступ к Просмотру Данных?",
                        answer: "Нажмите на иконку графика в верхнем левом углу для полной аналитики:\n• Общее количество поисков и сегодняшний счет\n• Разбивка использования по платформам\n• Сэкономленное время против бесконечной прокрутки\n• Счет фокуса и аналитика эффективности\n• История поиска по датам\n• Статистика по конкретным платформам"
                    )

                    FAQItem(
                        question: "🕒 Как работает История Поиска?",
                        answer: "Получите доступ к полной истории в Просмотре Данных:\n• Просматривайте поиски, организованные по датам (Сегодня, Вчера, На Этой Неделе)\n• Ищите в своей истории\n• Фильтруйте по конкретным платформам\n• Переключайтесь между сгруппированными по датам и плоскими представлениями\n• Настраивайте автоматическую очистку (7-365 дней)\n• Очищайте отдельные элементы или всю историю"
                    )

                    FAQItem(
                        question: "🏠 Как настроить Виджеты?",
                        answer: "Добавьте виджеты SkipFeed на главный экран:\n• Маленький виджет: Показывает сэкономленное время сегодня и количество поисков\n• Средний виджет: Показывает детальную статистику и использование платформ\n• Показывает ежедневные и общие счетчики поисков\n• Расчеты сэкономленного времени в реальном времени\n• Нажмите на виджет, чтобы открыть приложение"
                    )

                    FAQItem(
                        question: "🌍 Как работает адаптация языка?",
                        answer: "SkipFeed автоматически адаптируется к вашему языку:\n• Автоматическое определение на основе языка/региона системы\n• Поддерживает 10+ языков включая английский, китайский, испанский, французский, немецкий, итальянский, португальский, русский, японский, корейский\n• Может быть изменен вручную в Настройках\n• Порядок платформ адаптируется к региональным предпочтениям"
                    )

                    FAQItem(
                        question: "📈 Как работает сортировка платформ?",
                        answer: "Кнопки платформ автоматически переупорядочиваются на основе вашего использования:\n• Наиболее используемые платформы появляются первыми\n• Адаптируется к вашим личным паттернам поиска\n• Помогает быстрее получить доступ к предпочитаемым платформам\n• Порядок обновляется динамически со временем"
                    )

                    FAQItem(
                        question: "🔄 В чем разница между режимами Прямой и В-Приложении?",
                        answer: "Выберите, как вы хотите навигировать контент:\n• Режим Прямой: Открывает контент в нативных приложениях или браузере (доступно для всех платформ)\n• Режим В-Приложении: Навигация контента Reddit прямо внутри SkipFeed с интеграцией API\n\nПримечание: Режим В-Приложении в настоящее время доступен только для Reddit и обеспечивает плавную навигацию с полными деталями постов, комментариев и медиа."
                    )
                }

                SectionView(title: "Устранение Неполадок") {
                    FAQItem(
                        question: "Результаты поиска не открываются",
                        answer: "• Убедитесь, что целевое приложение установлено\n• Проверьте интернет-соединение\n• Попробуйте переключиться на режим Прямой для Reddit\n• Попробуйте открыть в браузере"
                    )

                    FAQItem(
                        question: "Режим В-Приложении Reddit не работает",
                        answer: "• Проверьте интернет-соединение\n• Попробуйте обновить, потянув вниз в списке\n• Временно переключитесь на режим Прямой\n• Очистите историю поиска при необходимости"
                    )

                    FAQItem(
                        question: "Виджет не обновляется",
                        answer: "• Удалите и снова добавьте виджет\n• Убедитесь, что у SkipFeed включено фоновое обновление приложения\n• Перезагрузите устройство\n• Проверьте настройки виджета в Настройках iOS"
                    )
                }

                SectionView(title: "Техническая Поддержка") {
                    Text("Для дополнительной помощи обращайтесь:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Email: support@skipfeed.app")
                        BulletPoint("Время Ответа: 24-48 часов")
                    }
                }

                SectionView(title: "Функции Версии 1.0") {
                    Text("Текущая версия включает:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 Полный Просмотр Данных с аналитикой использования")
                        BulletPoint("🕒 Расширенная История Поиска с группировкой по датам и фильтрами")
                        BulletPoint("🏠 Виджеты главного экрана для быстрого доступа к статистике")
                        BulletPoint("🌍 Автоматическая адаптация языка (10+ языков)")
                        BulletPoint("📈 Динамическая сортировка платформ на основе использования")
                        BulletPoint("🔍 Прямой поиск к нативным приложениям и браузерам")
                        BulletPoint("💬 Навигация Reddit В-Приложении")
                        BulletPoint("⏰ Расчеты сэкономленного времени и аналитика эффективности")
                        BulletPoint("🎨 Современный, интуитивный дизайн интерфейса")
                        BulletPoint("🔧 Настраиваемые параметры автоочистки")
                    }
                }
            }
        case "ja":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed サポート & FAQ")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "よくある質問") {
                    FAQItem(
                        question: "🔍 SkipFeedの使い方は？",
                        answer: "1. 検索したいプラットフォームを選択\n2. キーワードを入力\n3. 検索ボタンをタップ\n4. コンテンツはネイティブアプリ（インストール済みの場合）またはブラウザで直接開きます\n\nRedditの場合：ダイレクトモード（Redditアプリ/ブラウザで開く）またはインアプリモード（SkipFeed内でナビゲート）を選択できます"
                    )

                    FAQItem(
                        question: "📱 サポートされているプラットフォームは？",
                        answer: "• YouTube - 動画検索\n• Reddit - コミュニティディスカッション（インアプリナビゲーション付き）\n• X (Twitter) - リアルタイム更新\n• TikTok - ショート動画発見\n• Instagram - 写真と動画\n• Facebook - ソーシャルコンテンツ\n• Google - ウェブ検索\n• Bing - 代替ウェブ検索"
                    )

                    FAQItem(
                        question: "📊 データビューへのアクセス方法は？",
                        answer: "左上のグラフアイコンをタップして包括的な分析を表示：\n• 総検索数と今日のカウント\n• プラットフォーム別使用状況の内訳\n• 無限スクロールと比較した節約時間\n• フォーカススコアと効率性の洞察\n• 日付別検索履歴\n• プラットフォーム固有の統計"
                    )

                    FAQItem(
                        question: "🕒 検索履歴の仕組みは？",
                        answer: "データビューで完全な履歴にアクセス：\n• 日付別に整理された検索を表示（今日、昨日、今週）\n• 履歴内を検索\n• 特定のプラットフォームでフィルタリング\n• 日付でグループ化されたビューとフラットビューを切り替え\n• 自動クリーンアップ設定を構成（7-365日）\n• 個別アイテムまたは全履歴をクリア"
                    )

                    FAQItem(
                        question: "🏠 ウィジェットの設定方法は？",
                        answer: "ホーム画面にSkipFeedウィジェットを追加：\n• スモールウィジェット：今日の節約時間と検索カウントを表示\n• ミディアムウィジェット：詳細統計とプラットフォーム使用状況を表示\n• 日次および総検索カウントを表示\n• リアルタイム節約時間計算\n• ウィジェットをタップしてアプリを開く"
                    )

                    FAQItem(
                        question: "🌍 言語適応の仕組みは？",
                        answer: "SkipFeedは自動的にあなたの言語に適応：\n• システム言語/地域に基づく自動検出\n• 英語、中国語、スペイン語、フランス語、ドイツ語、イタリア語、ポルトガル語、ロシア語、日本語、韓国語を含む10+言語をサポート\n• 設定で手動変更可能\n• プラットフォーム順序が地域の好みに適応"
                    )

                    FAQItem(
                        question: "📈 プラットフォームソートの仕組みは？",
                        answer: "プラットフォームボタンは使用状況に基づいて自動的に再配置：\n• 最も使用されるプラットフォームが最初に表示\n• 個人的な検索パターンに適応\n• 好みのプラットフォームにより早くアクセス可能\n• 順序は時間とともに動的に更新"
                    )

                    FAQItem(
                        question: "🔄 ダイレクトモードとインアプリモードの違いは？",
                        answer: "コンテンツのナビゲート方法を選択：\n• ダイレクトモード：ネイティブアプリまたはブラウザでコンテンツを開く（全プラットフォームで利用可能）\n• インアプリモード：API統合によりSkipFeed内でRedditコンテンツを直接ナビゲート\n\n注意：インアプリモードは現在Redditのみで利用可能で、投稿、コメント、メディアの完全な詳細によるスムーズなナビゲーション体験を提供します。"
                    )
                }

                SectionView(title: "トラブルシューティング") {
                    FAQItem(
                        question: "検索結果が開かない",
                        answer: "• ターゲットアプリがインストールされていることを確認\n• インターネット接続を確認\n• Redditでダイレクトモードに切り替えてみる\n• ブラウザで開いてみる"
                    )

                    FAQItem(
                        question: "Redditのインアプリモードが動作しない",
                        answer: "• インターネット接続を確認\n• リストを下にプルして更新してみる\n• 一時的にダイレクトモードに切り替える\n• 必要に応じて検索履歴をクリア"
                    )

                    FAQItem(
                        question: "ウィジェットが更新されない",
                        answer: "• ウィジェットを削除して再追加\n• SkipFeedでバックグラウンドアプリ更新が有効になっていることを確認\n• デバイスを再起動\n• iOS設定でウィジェット設定を確認"
                    )
                }

                SectionView(title: "テクニカルサポート") {
                    Text("追加サポートについては、お問い合わせください：")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Email: support@skipfeed.app")
                        BulletPoint("応答時間：24-48時間")
                    }
                }

                SectionView(title: "バージョン1.0機能") {
                    Text("現在のバージョンには以下が含まれます：")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 使用状況分析を含む包括的なデータビュー")
                        BulletPoint("🕒 日付グループ化とフィルタを含む高度な検索履歴")
                        BulletPoint("🏠 統計への迅速アクセス用ホーム画面ウィジェット")
                        BulletPoint("🌍 自動言語適応（10+言語）")
                        BulletPoint("📈 使用状況ベースの動的プラットフォームソート")
                        BulletPoint("🔍 ネイティブアプリとブラウザへの直接検索")
                        BulletPoint("💬 Redditインアプリナビゲーション")
                        BulletPoint("⏰ 節約時間計算と効率性洞察")
                        BulletPoint("🎨 モダンで直感的なインターフェースデザイン")
                        BulletPoint("🔧 カスタマイズ可能な自動クリーンアップ設定")
                    }
                }
            }
        case "ko":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed 지원 및 FAQ")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "자주 묻는 질문") {
                    FAQItem(
                        question: "🔍 SkipFeed 사용 방법은?",
                        answer: "1. 검색하고 싶은 플랫폼 선택\n2. 키워드 입력\n3. 검색 버튼 누르기\n4. 콘텐츠가 네이티브 앱(설치된 경우) 또는 브라우저에서 직접 열림\n\nReddit의 경우: 다이렉트 모드(Reddit 앱/브라우저에서 열기) 또는 인앱 모드(SkipFeed 내에서 탐색) 중 선택 가능"
                    )

                    FAQItem(
                        question: "📱 지원되는 플랫폼은?",
                        answer: "• YouTube - 비디오 검색\n• Reddit - 커뮤니티 토론 (인앱 탐색 포함)\n• X (Twitter) - 실시간 업데이트\n• TikTok - 숏폼 비디오 발견\n• Instagram - 사진 및 비디오\n• Facebook - 소셜 콘텐츠\n• Google - 웹 검색\n• Bing - 대체 웹 검색"
                    )

                    FAQItem(
                        question: "📊 데이터 뷰 액세스 방법은?",
                        answer: "왼쪽 상단의 그래프 아이콘을 눌러 포괄적인 분석 보기:\n• 총 검색 수 및 오늘 카운트\n• 플랫폼별 사용량 분석\n• 무한 스크롤 대비 절약 시간\n• 집중 점수 및 효율성 인사이트\n• 날짜별 검색 기록\n• 플랫폼별 통계"
                    )

                    FAQItem(
                        question: "🕒 검색 기록 작동 방식은?",
                        answer: "데이터 뷰에서 전체 기록에 액세스:\n• 날짜별로 정리된 검색 보기 (오늘, 어제, 이번 주)\n• 기록 내 검색\n• 특정 플랫폼으로 필터링\n• 날짜 그룹화 및 플랫 뷰 간 전환\n• 자동 정리 설정 구성 (7-365일)\n• 개별 항목 또는 전체 기록 지우기"
                    )

                    FAQItem(
                        question: "🏠 위젯 설정 방법은?",
                        answer: "홈 화면에 SkipFeed 위젯 추가:\n• 소형 위젯: 오늘 절약 시간 및 검색 카운트 표시\n• 중형 위젯: 상세 통계 및 플랫폼 사용량 표시\n• 일일 및 전체 검색 카운트 표시\n• 실시간 절약 시간 계산\n• 위젯을 눌러 앱 열기"
                    )

                    FAQItem(
                        question: "🌍 언어 적응 작동 방식은?",
                        answer: "SkipFeed는 자동으로 언어에 적응:\n• 시스템 언어/지역 기반 자동 감지\n• 영어, 중국어, 스페인어, 프랑스어, 독일어, 이탈리아어, 포르투갈어, 러시아어, 일본어, 한국어 포함 10개 이상 언어 지원\n• 설정에서 수동 변경 가능\n• 플랫폼 순서가 지역 선호도에 적응"
                    )

                    FAQItem(
                        question: "📈 플랫폼 정렬 작동 방식은?",
                        answer: "플랫폼 버튼이 사용량에 따라 자동으로 재배열:\n• 가장 많이 사용하는 플랫폼이 먼저 나타남\n• 개인 검색 패턴에 적응\n• 선호 플랫폼에 더 빠르게 액세스 도움\n• 시간에 따라 순서가 동적으로 업데이트"
                    )

                    FAQItem(
                        question: "🔄 다이렉트 모드와 인앱 모드의 차이점은?",
                        answer: "콘텐츠 탐색 방식 선택:\n• 다이렉트 모드: 네이티브 앱 또는 브라우저에서 콘텐츠 열기 (모든 플랫폼에서 사용 가능)\n• 인앱 모드: API 통합으로 SkipFeed 내에서 Reddit 콘텐츠 직접 탐색\n\n참고: 인앱 모드는 현재 Reddit에서만 사용 가능하며 게시물, 댓글, 미디어의 완전한 세부 정보로 원활한 탐색 경험을 제공합니다."
                    )
                }

                SectionView(title: "문제 해결") {
                    FAQItem(
                        question: "검색 결과가 열리지 않음",
                        answer: "• 대상 앱이 설치되어 있는지 확인\n• 인터넷 연결 확인\n• Reddit에서 다이렉트 모드로 전환 시도\n• 브라우저에서 열기 시도"
                    )

                    FAQItem(
                        question: "Reddit 인앱 모드가 작동하지 않음",
                        answer: "• 인터넷 연결 확인\n• 목록에서 아래로 당겨서 새로고침 시도\n• 일시적으로 다이렉트 모드로 전환\n• 필요시 검색 기록 지우기"
                    )

                    FAQItem(
                        question: "위젯이 업데이트되지 않음",
                        answer: "• 위젯 제거 후 다시 추가\n• SkipFeed에서 백그라운드 앱 새로고침이 활성화되어 있는지 확인\n• 기기 재시작\n• iOS 설정에서 위젯 설정 확인"
                    )
                }

                SectionView(title: "기술 지원") {
                    Text("추가 지원이 필요하시면 연락하세요:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("이메일: support@skipfeed.app")
                        BulletPoint("응답 시간: 24-48시간")
                    }
                }

                SectionView(title: "버전 1.0 기능") {
                    Text("현재 버전에는 다음이 포함됩니다:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 사용량 분석을 포함한 포괄적인 데이터 뷰")
                        BulletPoint("🕒 날짜 그룹화 및 필터를 포함한 고급 검색 기록")
                        BulletPoint("🏠 통계 빠른 액세스용 홈 화면 위젯")
                        BulletPoint("🌍 자동 언어 적응 (10개 이상 언어)")
                        BulletPoint("📈 사용량 기반 동적 플랫폼 정렬")
                        BulletPoint("🔍 네이티브 앱 및 브라우저로의 직접 검색")
                        BulletPoint("💬 Reddit 인앱 탐색")
                        BulletPoint("⏰ 절약 시간 계산 및 효율성 인사이트")
                        BulletPoint("🎨 현대적이고 직관적인 인터페이스 디자인")
                        BulletPoint("🔧 사용자 정의 가능한 자동 정리 설정")
                    }
                }
            }
        case "ar":
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed الدعم والأسئلة الشائعة")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "الأسئلة الشائعة") {
                    FAQItem(
                        question: "🔍 كيفية استخدام SkipFeed؟",
                        answer: "1. اختر المنصة التي تريد البحث فيها\n2. أدخل الكلمات المفتاحية\n3. اضغط على زر البحث\n4. يفتح المحتوى مباشرة في التطبيق الأصلي (إذا كان مثبتاً) أو المتصفح\n\nبالنسبة لـ Reddit: يمكنك الاختيار بين الوضع المباشر (يفتح في تطبيق/متصفح Reddit) أو الوضع داخل التطبيق (التصفح داخل SkipFeed)"
                    )

                    FAQItem(
                        question: "📱 ما هي المنصات المدعومة؟",
                        answer: "• YouTube - البحث في الفيديوهات\n• Reddit - مناقشات المجتمع (مع التصفح داخل التطبيق)\n• X (Twitter) - التحديثات الفورية\n• TikTok - اكتشاف الفيديوهات القصيرة\n• Instagram - الصور والفيديوهات\n• Facebook - المحتوى الاجتماعي\n• Google - البحث على الويب\n• Bing - البحث البديل على الويب"
                    )

                    FAQItem(
                        question: "📊 كيفية الوصول إلى عرض البيانات؟",
                        answer: "اضغط على أيقونة الرسم البياني في أعلى اليسار لرؤية التحليل الشامل:\n• إجمالي عمليات البحث وعدد اليوم\n• تفصيل الاستخدام حسب المنصة\n• الوقت المُوفر مقابل التمرير اللانهائي\n• نقاط التركيز ورؤى الكفاءة\n• تاريخ البحث حسب التاريخ\n• إحصائيات خاصة بالمنصة"
                    )

                    FAQItem(
                        question: "🕒 كيف يعمل تاريخ البحث؟",
                        answer: "الوصول إلى التاريخ الكامل في عرض البيانات:\n• عرض البحثات منظمة حسب التاريخ (اليوم، أمس، هذا الأسبوع)\n• البحث داخل تاريخك\n• فلترة حسب منصات محددة\n• التبديل بين العروض المجمعة حسب التاريخ والعروض المسطحة\n• تكوين إعدادات التنظيف التلقائي (7-365 يوم)\n• محو عناصر فردية أو التاريخ بالكامل"
                    )

                    FAQItem(
                        question: "🏠 كيفية إعداد الأدوات؟",
                        answer: "أضف أدوات SkipFeed إلى الشاشة الرئيسية:\n• أداة صغيرة: تظهر الوقت المُوفر اليوم وعدد البحثات\n• أداة متوسطة: تظهر إحصائيات مفصلة واستخدام المنصات\n• تظهر عدادات البحث اليومية والإجمالية\n• حسابات الوقت المُوفر في الوقت الفعلي\n• اضغط على الأداة لفتح التطبيق"
                    )

                    FAQItem(
                        question: "🌍 كيف يعمل التكيف اللغوي؟",
                        answer: "يتكيف SkipFeed تلقائياً مع لغتك:\n• الكشف التلقائي بناءً على لغة/منطقة النظام\n• يدعم أكثر من 10 لغات تشمل الإنجليزية والصينية والإسبانية والفرنسية والألمانية والإيطالية والبرتغالية والروسية واليابانية والكورية\n• يمكن تغييره يدوياً في الإعدادات\n• ترتيب المنصات يتكيف مع التفضيلات الإقليمية"
                    )

                    FAQItem(
                        question: "📈 كيف يعمل ترتيب المنصات؟",
                        answer: "أزرار المنصات تُعيد ترتيب نفسها تلقائياً بناءً على استخدامك:\n• المنصات الأكثر استخداماً تظهر أولاً\n• تتكيف مع أنماط البحث الشخصية\n• تساعدك في الوصول أسرع للمنصات المفضلة\n• الترتيب يتحدث ديناميكياً مع الوقت"
                    )

                    FAQItem(
                        question: "🔄 ما الفرق بين الوضع المباشر ووضع داخل التطبيق؟",
                        answer: "اختر كيفية تصفح المحتوى:\n• الوضع المباشر: فتح المحتوى في التطبيقات الأصلية أو المتصفح (متاح لجميع المنصات)\n• وضع داخل التطبيق: تصفح محتوى Reddit مباشرة داخل SkipFeed مع تكامل API\n\nملاحظة: الوضع داخل التطبيق متاح حالياً فقط لـ Reddit ويوفر تجربة تصفح سلسة مع تفاصيل كاملة للمنشورات والتعليقات والوسائط."
                    )
                }

                SectionView(title: "حل المشاكل") {
                    FAQItem(
                        question: "نتائج البحث لا تفتح",
                        answer: "• تأكد من تثبيت التطبيق المستهدف\n• تحقق من اتصال الإنترنت\n• جرب التبديل للوضع المباشر لـ Reddit\n• جرب الفتح في المتصفح"
                    )

                    FAQItem(
                        question: "وضع Reddit داخل التطبيق لا يعمل",
                        answer: "• تحقق من اتصال الإنترنت\n• جرب التحديث بالسحب للأسفل في القائمة\n• قم بالتبديل مؤقتاً للوضع المباشر\n• امح تاريخ البحث إذا لزم الأمر"
                    )

                    FAQItem(
                        question: "الأداة لا تتحدث",
                        answer: "• احذف وأعد إضافة الأداة\n• تأكد من تمكين تحديث التطبيق في الخلفية لـ SkipFeed\n• أعد تشغيل جهازك\n• تحقق من إعدادات الأداة في إعدادات iOS"
                    )
                }

                SectionView(title: "الدعم التقني") {
                    Text("للحصول على مساعدة إضافية، تواصل معنا:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("البريد الإلكتروني: support@skipfeed.app")
                        BulletPoint("وقت الاستجابة: 24-48 ساعة")
                    }
                }

                SectionView(title: "ميزات الإصدار 1.0") {
                    Text("الإصدار الحالي يشمل:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 عرض بيانات شامل مع تحليل الاستخدام")
                        BulletPoint("🕒 تاريخ بحث متقدم مع تجميع حسب التاريخ ومرشحات")
                        BulletPoint("🏠 أدوات الشاشة الرئيسية للوصول السريع للإحصائيات")
                        BulletPoint("🌍 التكيف التلقائي للغة (أكثر من 10 لغات)")
                        BulletPoint("📈 ترتيب ديناميكي للمنصات بناءً على الاستخدام")
                        BulletPoint("🔍 البحث المباشر للتطبيقات الأصلية والمتصفحات")
                        BulletPoint("💬 تصفح Reddit داخل التطبيق")
                        BulletPoint("⏰ حسابات الوقت المُوفر ورؤى الكفاءة")
                        BulletPoint("🎨 تصميم واجهة حديث وبديهي")
                        BulletPoint("🔧 إعدادات تنظيف تلقائي قابلة للتخصيص")
                    }
                }
            }
        default:
            VStack(alignment: .leading, spacing: 16) {
                Text("SkipFeed Support & FAQ")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                SectionView(title: "Frequently Asked Questions") {
                    FAQItem(
                        question: "🔍 How do I use SkipFeed?",
                        answer: "1. Select the platform you want to search\n2. Enter your search keywords\n3. Tap the search button\n4. Content opens directly in the native app (if installed) or browser\n\nFor Reddit: You can choose between Direct mode (opens in Reddit app/browser) or In-App mode (browse within SkipFeed)"
                    )

                    FAQItem(
                        question: "📱 Which platforms are supported?",
                        answer: "• YouTube - Video search\n• Reddit - Community discussions (with in-app browsing)\n• X (Twitter) - Real-time updates\n• TikTok - Short video discovery\n• Instagram - Photos and videos\n• Facebook - Social content\n• Google - Web search\n• Bing - Alternative web search"
                    )

                    FAQItem(
                        question: "📊 How do I access the Data View?",
                        answer: "Tap the chart icon in the top-left corner to view comprehensive analytics:\n• Total searches and today's count\n• Platform usage breakdown\n• Time saved vs endless scrolling\n• Focus score and efficiency insights\n• Search history by date\n• Platform-specific statistics"
                    )

                    FAQItem(
                        question: "🕒 How does Search History work?",
                        answer: "Access your complete search history in the Data View:\n• View searches organized by date (Today, Yesterday, This Week)\n• Search within your history\n• Filter by specific platforms\n• Toggle between date-grouped and flat list views\n• Configure auto-cleanup settings (7-365 days)\n• Clear individual items or all history"
                    )

                    FAQItem(
                        question: "🏠 How do I set up Widgets?",
                        answer: "Add SkipFeed widgets to your home screen:\n• Small widget: Shows time saved today and search count\n• Medium widget: Displays detailed stats and platform usage\n• Shows both daily and total search counts\n• Real-time time saved calculations\n• Tap widget to open the app"
                    )

                    FAQItem(
                        question: "🌍 How does language adaptation work?",
                        answer: "SkipFeed automatically adapts to your language:\n• Auto-detects based on your system language/region\n• Supports 10+ languages including English, Chinese, Spanish, French, German, Italian, Portuguese, Russian, Japanese, Korean\n• Can be manually changed in Settings\n• Platform order adapts based on regional preferences"
                    )

                    FAQItem(
                        question: "📈 How does platform ordering work?",
                        answer: "Platform buttons are automatically reordered based on your usage:\n• Most frequently used platforms appear first\n• Adapts to your personal search patterns\n• Helps you access your preferred platforms faster\n• Order updates dynamically over time"
                    )

                    FAQItem(
                        question: "🔄 What's the difference between Direct and In-App modes?",
                        answer: "Choose how you want to browse content:\n• Direct Mode: Opens content in native apps or browser (available for all platforms)\n• In-App Mode: Browse Reddit content directly within SkipFeed with API integration\n\nNote: In-App mode is currently only available for Reddit and provides a seamless browsing experience with full post details, comments, and media."
                    )
                }

                SectionView(title: "Troubleshooting") {
                    FAQItem(
                        question: "Search results won't open",
                        answer: "• Ensure the target app is installed\n• Check your internet connection\n• Try switching to Direct mode for Reddit\n• Try opening in browser instead"
                    )

                    FAQItem(
                        question: "Reddit In-App mode not working",
                        answer: "• Check your internet connection\n• Try refreshing by pulling down on the list\n• Switch to Direct mode temporarily\n• Clear search history if needed"
                    )

                    FAQItem(
                        question: "Widget not updating",
                        answer: "• Remove and re-add the widget\n• Ensure SkipFeed has background app refresh enabled\n• Restart your device\n• Check widget settings in iOS Settings"
                    )

                    FAQItem(
                        question: "Data View showing incorrect stats",
                        answer: "• Stats are calculated from search history\n• Clear and rebuild search history if needed\n• Ensure you're using the latest version\n• Contact support if issues persist"
                    )

                    FAQItem(
                        question: "Language switching doesn't work",
                        answer: "• Ensure you've selected the correct language in Settings\n• Restart the app to apply changes\n• Check your system language settings\n• Try toggling auto-detection off and on"
                    )

                    FAQItem(
                        question: "Platform order not updating",
                        answer: "• Platform order updates based on usage over time\n• Perform more searches to see changes\n• Order may reset after clearing search history\n• Changes appear gradually, not immediately"
                    )
                }

                SectionView(title: "Feature Requests") {
                    Text("We welcome your suggestions! If you'd like new features or platform support, please contact us.")
                        .font(.body)
                }

                SectionView(title: "Technical Support") {
                    Text("For further assistance, contact:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Email: support@skipfeed.app")
                        BulletPoint("Response Time: 24-48 hours")
                    }
                }

                SectionView(title: "Version 1.0 Features") {
                    Text("Current version includes:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("📊 Comprehensive Data View with usage analytics")
                        BulletPoint("🕒 Advanced Search History with date grouping and filters")
                        BulletPoint("🏠 Home Screen Widgets for quick stats access")
                        BulletPoint("🌍 Automatic language adaptation (10+ languages)")
                        BulletPoint("📈 Dynamic platform ordering based on usage")
                        BulletPoint("🔍 Direct search to native apps and browsers")
                        BulletPoint("💬 Reddit In-App browsing")
                        BulletPoint("⏰ Time saved calculations and efficiency insights")
                        BulletPoint("🎨 Modern, intuitive interface design")
                        BulletPoint("🔧 Customizable auto-cleanup settings")
                    }
                }
            }
        }
    }
}

struct FAQItem: View {
    let question: String
    let answer: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.headline)
                .fontWeight(.medium)

            Text(answer)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.bottom, 8)
    }
}
