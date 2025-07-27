import SwiftUI

// MARK: - About Content Views

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(getPrivacyPolicyContent())
                        .font(.body)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.privacyPolicy))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString(.done)) {
                        dismiss()
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
            }
        }
    }
    
    private func getPrivacyPolicyContent() -> String {
        switch localizationManager.currentLanguage {
        case "zh":
            return """
            # SkipFeed 隐私政策
            
            **生效日期：2025年1月24日**
            
            ## 我们收集的信息
            
            SkipFeed 致力于保护您的隐私。我们设计应用时遵循数据最小化原则。
            
            ### 本地存储的数据
            - **搜索历史**：您的搜索查询仅存储在您的设备上
            - **使用统计**：搜索次数和使用时间等统计信息
            - **应用设置**：语言偏好、平台顺序等个人设置
            
            ### 我们不收集的信息
            - 个人身份信息
            - 位置数据
            - 联系人信息
            - 设备标识符
            
            ## 数据使用
            
            所有数据仅用于：
            - 改善您的应用体验
            - 提供个性化搜索建议
            - 显示使用统计信息
            
            ## 数据共享
            
            我们不会与第三方共享您的任何数据。您的搜索历史和使用数据完全保留在您的设备上。
            
            ## 数据安全
            
            - 所有数据使用 iOS 标准加密存储
            - 数据仅存储在您的设备本地
            - 我们无法访问您的任何个人数据
            
            ## 您的权利
            
            - 随时删除搜索历史
            - 重置使用统计数据
            - 完全卸载应用以删除所有数据
            
            ## 联系我们
            
            如有隐私相关问题，请联系：support@skipfeed.app
            """
        default:
            return """
            # SkipFeed Privacy Policy
            
            **Effective Date: January 24, 2025**
            
            ## Information We Collect
            
            SkipFeed is committed to protecting your privacy. We've designed our app with data minimization in mind.
            
            ### Data Stored Locally
            - **Search History**: Your search queries are stored only on your device
            - **Usage Analytics**: Statistics like search counts and time saved
            - **App Preferences**: Language settings, platform order, and other personal preferences
            
            ### Information We Don't Collect
            - Personal identifying information
            - Location data
            - Contact information
            - Device identifiers
            
            ## How We Use Data
            
            All data is used solely to:
            - Improve your app experience
            - Provide personalized search suggestions
            - Display usage statistics
            
            ## Data Sharing
            
            We do not share any of your data with third parties. Your search history and usage data remain completely on your device.
            
            ## Data Security
            
            - All data is encrypted using iOS standard encryption
            - Data is stored locally on your device only
            - We have no access to any of your personal data
            
            ## Your Rights
            
            - Delete search history at any time
            - Reset usage statistics
            - Completely uninstall the app to remove all data
            
            ## Contact Us
            
            For privacy-related questions, contact: support@skipfeed.app
            """
        }
    }
}

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(getTermsContent())
                        .font(.body)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.termsOfService))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString(.done)) {
                        dismiss()
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
            }
        }
    }
    
    private func getTermsContent() -> String {
        switch localizationManager.currentLanguage {
        case "zh":
            return """
            # SkipFeed 服务条款
            
            **生效日期：2025年1月24日**
            
            ## 接受条款
            
            使用 SkipFeed 即表示您同意这些服务条款。
            
            ## 服务描述
            
            SkipFeed 是一个搜索聚合应用，帮助您在多个平台上进行高效搜索：
            - YouTube、Reddit、X (Twitter)、TikTok、Instagram、Facebook
            - 提供直接搜索和应用内浏览功能
            - 搜索历史和使用统计
            
            ## 使用许可
            
            我们授予您有限的、非独占的、不可转让的许可来使用 SkipFeed。
            
            ## 用户责任
            
            您同意：
            - 遵守所有适用的法律法规
            - 不滥用或干扰服务
            - 不尝试逆向工程应用
            - 尊重第三方平台的服务条款
            
            ## 知识产权
            
            SkipFeed 及其所有内容均受版权和其他知识产权法保护。
            
            ## 免责声明
            
            SkipFeed 按"现状"提供，不提供任何明示或暗示的保证。
            
            ## 责任限制
            
            在法律允许的最大范围内，我们不对任何间接、偶然或后果性损害承担责任。
            
            ## 条款变更
            
            我们可能会更新这些条款。重大变更将通过应用内通知告知用户。
            
            ## 联系信息
            
            如有问题，请联系：support@skipfeed.app
            """
        default:
            return """
            # SkipFeed Terms of Service
            
            **Effective Date: January 24, 2025**
            
            ## Acceptance of Terms
            
            By using SkipFeed, you agree to these Terms of Service.
            
            ## Service Description
            
            SkipFeed is a search aggregation app that helps you search efficiently across multiple platforms:
            - YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook
            - Provides direct search and in-app browsing capabilities
            - Search history and usage analytics
            
            ## License to Use
            
            We grant you a limited, non-exclusive, non-transferable license to use SkipFeed.
            
            ## User Responsibilities
            
            You agree to:
            - Comply with all applicable laws and regulations
            - Not abuse or interfere with the service
            - Not attempt to reverse engineer the app
            - Respect third-party platform terms of service
            
            ## Intellectual Property
            
            SkipFeed and all its content are protected by copyright and other intellectual property laws.
            
            ## Disclaimers
            
            SkipFeed is provided "as is" without any express or implied warranties.
            
            ## Limitation of Liability
            
            To the maximum extent permitted by law, we are not liable for any indirect, incidental, or consequential damages.
            
            ## Changes to Terms
            
            We may update these terms. Significant changes will be communicated through in-app notifications.
            
            ## Contact Information
            
            For questions, contact: support@skipfeed.app
            """
        }
    }
}

struct SupportFAQView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(getSupportContent())
                        .font(.body)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.supportAndFAQ))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(localizationManager.localizedString(.done)) {
                        dismiss()
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                }
            }
        }
    }

    private func getSupportContent() -> String {
        switch localizationManager.currentLanguage {
        case "zh":
            return """
            # SkipFeed 支持与常见问题

            ## 常见问题

            ### 🔍 如何使用 SkipFeed？
            1. 选择您想要搜索的平台
            2. 输入搜索关键词
            3. 点击搜索按钮
            4. 选择在原生应用或浏览器中打开结果

            ### 📱 支持哪些平台？
            - **YouTube** - 视频搜索
            - **Reddit** - 社区讨论
            - **X (Twitter)** - 实时动态
            - **TikTok** - 短视频内容
            - **Instagram** - 图片和视频
            - **Facebook** - 社交内容

            ### 🌍 如何更改语言？
            1. 打开设置页面
            2. 点击"语言"选项
            3. 选择您偏好的语言或开启自动检测

            ### 📊 如何查看使用统计？
            点击主界面右上角的统计图标查看：
            - 总搜索次数
            - 今日搜索次数
            - 节省的时间
            - 平台使用情况

            ### 🔄 如何清除搜索历史？
            在设置页面中点击"清除最近搜索"按钮。

            ### 💎 高级功能有哪些？
            - **应用内浏览**：在 SkipFeed 内直接浏览内容
            - **自动勿扰**：打开应用时自动启用勿扰模式
            - **AI 摘要**：智能内容摘要功能
            - **无限搜索**：移除每日搜索限制

            ## 故障排除

            ### 搜索结果无法打开
            - 确保目标应用已安装
            - 检查网络连接
            - 尝试在浏览器中打开

            ### 应用运行缓慢
            - 重启应用
            - 清除搜索历史
            - 重启设备

            ### 语言切换不生效
            - 确保已选择正确的语言
            - 重启应用
            - 检查系统语言设置

            ## 功能请求

            我们欢迎您的建议！如果您希望添加新功能或支持新平台，请联系我们。

            ## 技术支持

            如需进一步帮助，请联系：
            - **邮箱**：support@skipfeed.app
            - **响应时间**：24-48小时

            ## 版本信息

            当前版本包含的新功能：
            - 完整的多语言支持
            - 改进的搜索体验
            - 增强的使用统计
            - 现代化的界面设计
            """
        default:
            return """
            # SkipFeed Support & FAQ

            ## Frequently Asked Questions

            ### 🔍 How do I use SkipFeed?
            1. Select the platform you want to search
            2. Enter your search keywords
            3. Tap the search button
            4. Choose to open results in native app or browser

            ### 📱 Which platforms are supported?
            - **YouTube** - Video search
            - **Reddit** - Community discussions
            - **X (Twitter)** - Real-time updates
            - **TikTok** - Short-form videos
            - **Instagram** - Photos and videos
            - **Facebook** - Social content

            ### 🌍 How do I change the language?
            1. Open Settings
            2. Tap "Language"
            3. Select your preferred language or enable auto-detect

            ### 📊 How do I view usage statistics?
            Tap the stats icon in the top-right corner to see:
            - Total searches
            - Today's searches
            - Time saved
            - Platform usage

            ### 🔄 How do I clear search history?
            Tap "Clear Recent Searches" in the Settings page.

            ### 💎 What premium features are available?
            - **In-App Browsing**: Browse content directly within SkipFeed
            - **Auto Do Not Disturb**: Automatically enable focus mode
            - **AI Summarization**: Smart content summarization
            - **Unlimited Searches**: Remove daily search limits

            ## Troubleshooting

            ### Search results won't open
            - Ensure the target app is installed
            - Check your internet connection
            - Try opening in browser instead

            ### App is running slowly
            - Restart the app
            - Clear search history
            - Restart your device

            ### Language switching not working
            - Ensure correct language is selected
            - Restart the app
            - Check system language settings

            ## Feature Requests

            We welcome your suggestions! If you'd like new features or platform support, please contact us.

            ## Technical Support

            For further assistance, contact:
            - **Email**: support@skipfeed.app
            - **Response Time**: 24-48 hours

            ## Version Information

            Current version includes:
            - Complete multilingual support
            - Improved search experience
            - Enhanced usage analytics
            - Modern interface design
            """
        }
    }
}
