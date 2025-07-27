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
                
                Text("Effective Date: January 24, 2025")
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

                Text("Effective Date: January 24, 2025")
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
                        answer: "1. 选择您想要搜索的平台\n2. 输入搜索关键词\n3. 点击搜索按钮\n4. 选择在原生应用或浏览器中打开结果"
                    )

                    FAQItem(
                        question: "📱 支持哪些平台？",
                        answer: "• YouTube - 视频搜索\n• Reddit - 社区讨论\n• X (Twitter) - 实时动态\n• TikTok - 短视频内容\n• Instagram - 图片和视频\n• Facebook - 社交内容"
                    )

                    FAQItem(
                        question: "🌍 如何更改语言？",
                        answer: "1. 打开设置页面\n2. 点击\"语言\"选项\n3. 选择您偏好的语言或开启自动检测"
                    )

                    FAQItem(
                        question: "📊 如何查看使用统计？",
                        answer: "点击主界面右上角的统计图标查看：\n• 总搜索次数\n• 今日搜索次数\n• 节省的时间\n• 平台使用情况"
                    )

                    FAQItem(
                        question: "🔄 如何清除搜索历史？",
                        answer: "在设置页面中点击\"清除最近搜索\"按钮。"
                    )

                    FAQItem(
                        question: "💎 高级功能有哪些？",
                        answer: "• 应用内浏览：在 SkipFeed 内直接浏览内容\n• 自动勿扰：打开应用时自动启用勿扰模式\n• AI 摘要：智能内容摘要功能\n• 无限搜索：移除每日搜索限制"
                    )
                }

                SectionView(title: "故障排除") {
                    FAQItem(
                        question: "搜索结果无法打开",
                        answer: "• 确保目标应用已安装\n• 检查网络连接\n• 尝试在浏览器中打开"
                    )

                    FAQItem(
                        question: "应用运行缓慢",
                        answer: "• 重启应用\n• 清除搜索历史\n• 重启设备"
                    )

                    FAQItem(
                        question: "语言切换不生效",
                        answer: "• 确保已选择正确的语言\n• 重启应用\n• 检查系统语言设置"
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

                SectionView(title: "版本信息") {
                    Text("当前版本包含的新功能：")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("完整的多语言支持")
                        BulletPoint("改进的搜索体验")
                        BulletPoint("增强的使用统计")
                        BulletPoint("现代化的界面设计")
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
                        answer: "1. Select the platform you want to search\n2. Enter your search keywords\n3. Tap the search button\n4. Choose to open results in the native app or browser"
                    )

                    FAQItem(
                        question: "📱 Which platforms are supported?",
                        answer: "• YouTube - Video search\n• Reddit - Community discussions\n• X (Twitter) - Real-time updates\n• TikTok - Short video content\n• Instagram - Photos and videos\n• Facebook - Social content"
                    )

                    FAQItem(
                        question: "🌍 How do I change the language?",
                        answer: "1. Open the Settings page\n2. Tap \"Language\" option\n3. Select your preferred language or enable auto-detection"
                    )

                    FAQItem(
                        question: "📊 How do I view usage statistics?",
                        answer: "Tap the statistics icon in the top-right corner of the main screen to view:\n• Total searches\n• Today's searches\n• Time saved\n• Platform usage breakdown"
                    )

                    FAQItem(
                        question: "🔄 How do I clear search history?",
                        answer: "In the Settings page, tap the \"Clear Recent Searches\" button."
                    )

                    FAQItem(
                        question: "💎 What are the premium features?",
                        answer: "• In-app browsing: Browse content directly within SkipFeed\n• Auto Do Not Disturb: Automatically enable DND when opening the app\n• AI Summaries: Intelligent content summarization\n• Unlimited searches: Remove daily search limits"
                    )
                }

                SectionView(title: "Troubleshooting") {
                    FAQItem(
                        question: "Search results won't open",
                        answer: "• Ensure the target app is installed\n• Check your internet connection\n• Try opening in browser instead"
                    )

                    FAQItem(
                        question: "App is running slowly",
                        answer: "• Restart the app\n• Clear search history\n• Restart your device"
                    )

                    FAQItem(
                        question: "Language switching doesn't work",
                        answer: "• Ensure you've selected the correct language\n• Restart the app\n• Check your system language settings"
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

                SectionView(title: "Version Information") {
                    Text("Current version includes:")
                        .font(.body)

                    VStack(alignment: .leading, spacing: 4) {
                        BulletPoint("Complete multi-language support")
                        BulletPoint("Improved search experience")
                        BulletPoint("Enhanced usage statistics")
                        BulletPoint("Modern interface design")
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
