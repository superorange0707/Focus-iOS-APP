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
            
            **生效日期：2025年7月24日**
            
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
        case "es":
            return """
            # Política de Privacidad de SkipFeed
            
            **Fecha de vigencia: 24 de julio de 2025**
            
            ## Información que Recopilamos
            
            SkipFeed está comprometido con proteger tu privacidad. Hemos diseñado nuestra app con la minimización de datos en mente.
            
            ### Datos Almacenados Localmente
            - **Historial de Búsquedas**: Tus consultas de búsqueda se almacenan solo en tu dispositivo
            - **Análisis de Uso**: Estadísticas como conteos de búsquedas y tiempo ahorrado
            - **Preferencias de la App**: Configuraciones de idioma, orden de plataformas y otras preferencias personales
            
            ### Información que NO Recopilamos
            - Información de identificación personal
            - Datos de ubicación
            - Información de contacto
            - Identificadores del dispositivo
            
            ## Cómo Usamos los Datos
            
            Todos los datos se usan únicamente para:
            - Mejorar tu experiencia en la app
            - Proporcionar sugerencias de búsqueda personalizadas
            - Mostrar estadísticas de uso
            
            ## Compartir Datos
            
            No compartimos ninguno de tus datos con terceros. Tu historial de búsquedas y datos de uso permanecen completamente en tu dispositivo.
            
            ## Seguridad de Datos
            
            - Todos los datos están encriptados usando el cifrado estándar de iOS
            - Los datos se almacenan localmente solo en tu dispositivo
            - No tenemos acceso a ninguno de tus datos personales
            
            ## Tus Derechos
            
            - Eliminar el historial de búsquedas en cualquier momento
            - Restablecer estadísticas de uso
            - Desinstalar completamente la app para eliminar todos los datos
            
            ## Contáctanos
            
            Para preguntas relacionadas con privacidad, contacta: support@skipfeed.app
            """
        case "fr":
            return """
            # Politique de Confidentialité SkipFeed
            
            **Date d'entrée en vigueur : 24 juillet 2025**
            
            ## Informations que Nous Collectons
            
            SkipFeed s'engage à protéger votre vie privée. Nous avons conçu notre application en gardant à l'esprit la minimisation des données.
            
            ### Données Stockées Localement
            - **Historique de Recherche** : Vos requêtes de recherche sont stockées uniquement sur votre appareil
            - **Analyses d'Utilisation** : Statistiques comme les comptages de recherches et le temps économisé
            - **Préférences de l'App** : Paramètres de langue, ordre des plateformes et autres préférences personnelles
            
            ### Informations que Nous NE Collectons PAS
            - Informations d'identification personnelle
            - Données de localisation
            - Informations de contact
            - Identifiants d'appareil
            
            ## Comment Nous Utilisons les Données
            
            Toutes les données sont utilisées uniquement pour :
            - Améliorer votre expérience d'application
            - Fournir des suggestions de recherche personnalisées
            - Afficher les statistiques d'utilisation
            
            ## Partage de Données
            
            Nous ne partageons aucune de vos données avec des tiers. Votre historique de recherche et vos données d'utilisation restent complètement sur votre appareil.
            
            ## Sécurité des Données
            
            - Toutes les données sont chiffrées en utilisant le chiffrement standard iOS
            - Les données sont stockées localement sur votre appareil uniquement
            - Nous n'avons accès à aucune de vos données personnelles
            
            ## Vos Droits
            
            - Supprimer l'historique de recherche à tout moment
            - Réinitialiser les statistiques d'utilisation
            - Désinstaller complètement l'application pour supprimer toutes les données
            
            ## Nous Contacter
            
            Pour les questions liées à la confidentialité, contactez : support@skipfeed.app
            """
        case "de":
            return """
            # SkipFeed Datenschutzrichtlinie
            
            **Gültigkeitsdatum: 24. Juli 2025**
            
            ## Informationen, die Wir Sammeln
            
            SkipFeed ist dem Schutz Ihrer Privatsphäre verpflichtet. Wir haben unsere App mit Datenminimierung im Sinn entwickelt.
            
            ### Lokal Gespeicherte Daten
            - **Suchverlauf**: Ihre Suchanfragen werden nur auf Ihrem Gerät gespeichert
            - **Nutzungsanalysen**: Statistiken wie Suchzählungen und gesparte Zeit
            - **App-Einstellungen**: Spracheinstellungen, Plattform-Reihenfolge und andere persönliche Einstellungen
            
            ### Informationen, die Wir NICHT Sammeln
            - Persönlich identifizierende Informationen
            - Standortdaten
            - Kontaktinformationen
            - Gerätekennungen
            
            ## Wie Wir Daten Verwenden
            
            Alle Daten werden ausschließlich verwendet, um:
            - Ihre App-Erfahrung zu verbessern
            - Personalisierte Suchvorschläge zu bieten
            - Nutzungsstatistiken anzuzeigen
            
            ## Datenfreigabe
            
            Wir teilen keine Ihrer Daten mit Dritten. Ihr Suchverlauf und Nutzungsdaten bleiben vollständig auf Ihrem Gerät.
            
            ## Datensicherheit
            
            - Alle Daten werden mit iOS-Standard-Verschlüsselung verschlüsselt
            - Daten werden nur lokal auf Ihrem Gerät gespeichert
            - Wir haben keinen Zugang zu Ihren persönlichen Daten
            
            ## Ihre Rechte
            
            - Suchverlauf jederzeit löschen
            - Nutzungsstatistiken zurücksetzen
            - App vollständig deinstallieren, um alle Daten zu entfernen
            
            ## Kontakt
            
            Für datenschutzbezogene Fragen kontaktieren Sie: support@skipfeed.app
            """
        case "it":
            return """
            # Politica sulla Privacy di SkipFeed
            
            **Data di entrata in vigore: 24 luglio 2025**
            
            ## Informazioni che Raccogliamo
            
            SkipFeed si impegna a proteggere la tua privacy. Abbiamo progettato la nostra app tenendo a mente la minimizzazione dei dati.
            
            ### Dati Memorizzati Localmente
            - **Cronologia Ricerche**: Le tue query di ricerca sono memorizzate solo sul tuo dispositivo
            - **Analisi di Utilizzo**: Statistiche come conteggi delle ricerche e tempo risparmiato
            - **Preferenze App**: Impostazioni lingua, ordine piattaforme e altre preferenze personali
            
            ### Informazioni che NON Raccogliamo
            - Informazioni di identificazione personale
            - Dati di posizione
            - Informazioni di contatto
            - Identificatori del dispositivo
            
            ## Come Utilizziamo i Dati
            
            Tutti i dati sono utilizzati esclusivamente per:
            - Migliorare la tua esperienza nell'app
            - Fornire suggerimenti di ricerca personalizzati
            - Mostrare statistiche di utilizzo
            
            ## Condivisione Dati
            
            Non condividiamo nessuno dei tuoi dati con terze parti. La tua cronologia ricerche e i dati di utilizzo rimangono completamente sul tuo dispositivo.
            
            ## Sicurezza dei Dati
            
            - Tutti i dati sono crittografati usando la crittografia standard iOS
            - I dati sono memorizzati localmente solo sul tuo dispositivo
            - Non abbiamo accesso a nessuno dei tuoi dati personali
            
            ## I Tuoi Diritti
            
            - Eliminare la cronologia ricerche in qualsiasi momento
            - Ripristinare le statistiche di utilizzo
            - Disinstallare completamente l'app per rimuovere tutti i dati
            
            ## Contattaci
            
            Per domande relative alla privacy, contatta: support@skipfeed.app
            """
        case "pt":
            return """
            # Política de Privacidade do SkipFeed
            
            **Data de vigência: 24 de julho de 2025**
            
            ## Informações que Coletamos
            
            O SkipFeed está comprometido em proteger sua privacidade. Projetamos nosso app com a minimização de dados em mente.
            
            ### Dados Armazenados Localmente
            - **Histórico de Pesquisas**: Suas consultas de pesquisa são armazenadas apenas no seu dispositivo
            - **Análises de Uso**: Estatísticas como contagens de pesquisas e tempo economizado
            - **Preferências do App**: Configurações de idioma, ordem das plataformas e outras preferências pessoais
            
            ### Informações que NÃO Coletamos
            - Informações de identificação pessoal
            - Dados de localização
            - Informações de contato
            - Identificadores do dispositivo
            
            ## Como Usamos os Dados
            
            Todos os dados são usados exclusivamente para:
            - Melhorar sua experiência no app
            - Fornecer sugestões de pesquisa personalizadas
            - Exibir estatísticas de uso
            
            ## Compartilhamento de Dados
            
            Não compartilhamos nenhum dos seus dados com terceiros. Seu histórico de pesquisas e dados de uso permanecem completamente no seu dispositivo.
            
            ## Segurança dos Dados
            
            - Todos os dados são criptografados usando criptografia padrão do iOS
            - Os dados são armazenados localmente apenas no seu dispositivo
            - Não temos acesso a nenhum dos seus dados pessoais
            
            ## Seus Direitos
            
            - Excluir histórico de pesquisas a qualquer momento
            - Redefinir estatísticas de uso
            - Desinstalar completamente o app para remover todos os dados
            
            ## Entre em Contato
            
            Para questões relacionadas à privacidade, contate: support@skipfeed.app
            """
        case "ru":
            return """
            # Политика Конфиденциальности SkipFeed
            
            **Дата вступления в силу: 24 июля 2025 года**
            
            ## Информация, Которую Мы Собираем
            
            SkipFeed привержен защите вашей конфиденциальности. Мы разработали наше приложение с учетом минимизации данных.
            
            ### Данные, Хранящиеся Локально
            - **История Поиска**: Ваши поисковые запросы хранятся только на вашем устройстве
            - **Аналитика Использования**: Статистика, такая как количество поисков и сэкономленное время
            - **Настройки Приложения**: Языковые настройки, порядок платформ и другие личные предпочтения
            
            ### Информация, Которую Мы НЕ Собираем
            - Персональную идентификационную информацию
            - Данные местоположения
            - Контактную информацию
            - Идентификаторы устройств
            
            ## Как Мы Используем Данные
            
            Все данные используются исключительно для:
            - Улучшения вашего опыта использования приложения
            - Предоставления персонализированных поисковых предложений
            - Отображения статистики использования
            
            ## Передача Данных
            
            Мы не передаем ваши данные третьим лицам. Ваша история поиска и данные использования остаются полностью на вашем устройстве.
            
            ## Безопасность Данных
            
            - Все данные зашифрованы с использованием стандартного шифрования iOS
            - Данные хранятся локально только на вашем устройстве
            - У нас нет доступа к вашим личным данным
            
            ## Ваши Права
            
            - Удалять историю поиска в любое время
            - Сбрасывать статистику использования
            - Полностью удалить приложение для удаления всех данных
            
            ## Связаться с Нами
            
            По вопросам конфиденциальности обращайтесь: support@skipfeed.app
            """
        case "ja":
            return """
            # SkipFeed プライバシーポリシー
            
            **発効日：2025年7月24日**
            
            ## 収集する情報
            
            SkipFeedはお客様のプライバシー保護をお約束します。データの最小化を念頭に置いてアプリを設計しました。
            
            ### ローカルに保存されるデータ
            - **検索履歴**：お客様の検索クエリはお客様のデバイスにのみ保存されます
            - **使用状況分析**：検索回数や節約時間などの統計
            - **アプリ設定**：言語設定、プラットフォーム順序、その他の個人設定
            
            ### 収集しない情報
            - 個人識別情報
            - 位置データ
            - 連絡先情報
            - デバイス識別子
            
            ## データの使用方法
            
            すべてのデータは以下の目的でのみ使用されます：
            - アプリ体験の向上
            - パーソナライズされた検索提案の提供
            - 使用統計の表示
            
            ## データ共有
            
            お客様のデータを第三者と共有することはありません。検索履歴と使用データは完全にお客様のデバイスに残ります。
            
            ## データセキュリティ
            
            - すべてのデータはiOS標準暗号化を使用して暗号化されています
            - データはお客様のデバイスにのみローカルに保存されます
            - 私たちはお客様の個人データにアクセスできません
            
            ## お客様の権利
            
            - いつでも検索履歴を削除する
            - 使用統計をリセットする
            - アプリを完全にアンインストールしてすべてのデータを削除する
            
            ## お問い合わせ
            
            プライバシーに関するご質問は以下にお問い合わせください：support@skipfeed.app
            """
        case "ko":
            return """
            # SkipFeed 개인정보처리방침
            
            **시행일: 2025년 7월 24일**
            
            ## 수집하는 정보
            
            SkipFeed는 귀하의 개인정보 보호에 최선을 다합니다. 데이터 최소화를 염두에 두고 앱을 설계했습니다.
            
            ### 로컬에 저장되는 데이터
            - **검색 기록**: 귀하의 검색 쿼리는 귀하의 기기에만 저장됩니다
            - **사용 분석**: 검색 횟수 및 절약 시간 같은 통계
            - **앱 설정**: 언어 설정, 플랫폼 순서 및 기타 개인 설정
            
            ### 수집하지 않는 정보
            - 개인 식별 정보
            - 위치 데이터
            - 연락처 정보
            - 기기 식별자
            
            ## 데이터 사용 방법
            
            모든 데이터는 다음 목적으로만 사용됩니다:
            - 앱 경험 개선
            - 개인화된 검색 제안 제공
            - 사용 통계 표시
            
            ## 데이터 공유
            
            귀하의 데이터를 제3자와 공유하지 않습니다. 검색 기록과 사용 데이터는 완전히 귀하의 기기에 남아 있습니다.
            
            ## 데이터 보안
            
            - 모든 데이터는 iOS 표준 암호화를 사용하여 암호화됩니다
            - 데이터는 귀하의 기기에만 로컬로 저장됩니다
            - 저희는 귀하의 개인 데이터에 액세스할 수 없습니다
            
            ## 귀하의 권리
            
            - 언제든지 검색 기록 삭제
            - 사용 통계 재설정
            - 앱을 완전히 제거하여 모든 데이터 삭제
            
            ## 문의하기
            
            개인정보 관련 문의사항은 다음으로 연락해주세요: support@skipfeed.app
            """
        case "ar":
            return """
            # سياسة الخصوصية لـ SkipFeed
            
            **تاريخ السريان: 24 يوليو 2025**
            
            ## المعلومات التي نجمعها
            
            يلتزم SkipFeed بحماية خصوصيتك. لقد صممنا تطبيقنا مع وضع تقليل البيانات في الاعتبار.
            
            ### البيانات المحفوظة محلياً
            - **تاريخ البحث**: استعلامات البحث الخاصة بك محفوظة فقط على جهازك
            - **تحليلات الاستخدام**: إحصائيات مثل عدد البحثات والوقت المُوفر
            - **إعدادات التطبيق**: إعدادات اللغة وترتيب المنصات والتفضيلات الشخصية الأخرى
            
            ### المعلومات التي لا نجمعها
            - معلومات التعريف الشخصية
            - بيانات الموقع
            - معلومات الاتصال
            - معرفات الجهاز
            
            ## كيف نستخدم البيانات
            
            جميع البيانات تُستخدم حصرياً لـ:
            - تحسين تجربة التطبيق
            - تقديم اقتراحات بحث مخصصة
            - عرض إحصائيات الاستخدام
            
            ## مشاركة البيانات
            
            نحن لا نشارك أي من بياناتك مع أطراف ثالثة. تاريخ البحث وبيانات الاستخدام تبقى بالكامل على جهازك.
            
            ## أمان البيانات
            
            - جميع البيانات مشفرة باستخدام التشفير القياسي لـ iOS
            - البيانات محفوظة محلياً على جهازك فقط
            - ليس لدينا وصول إلى أي من بياناتك الشخصية
            
            ## حقوقك
            
            - حذف تاريخ البحث في أي وقت
            - إعادة تعيين إحصائيات الاستخدام
            - إلغاء تثبيت التطبيق بالكامل لحذف جميع البيانات
            
            ## اتصل بنا
            
            للأسئلة المتعلقة بالخصوصية، تواصل معنا: support@skipfeed.app
            """
        default:
            return """
            # SkipFeed Privacy Policy
            
            **Effective Date: July 24, 2025**
            
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
            
            **生效日期：2025年7月24日**
            
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
        case "es":
            return """
            # Términos de Servicio de SkipFeed
            
            **Fecha de vigencia: 24 de julio de 2025**
            
            ## Aceptación de Términos
            
            Al usar SkipFeed, aceptas estos Términos de Servicio.
            
            ## Descripción del Servicio
            
            SkipFeed es una app de agregación de búsquedas que te ayuda a buscar eficientemente en múltiples plataformas:
            - YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook
            - Proporciona capacidades de búsqueda directa y navegación in-app
            - Historial de búsquedas y análisis de uso
            
            ## Licencia de Uso
            
            Te otorgamos una licencia limitada, no exclusiva y no transferible para usar SkipFeed.
            
            ## Responsabilidades del Usuario
            
            Aceptas:
            - Cumplir con todas las leyes y regulaciones aplicables
            - No abusar o interferir con el servicio
            - No intentar hacer ingeniería inversa de la app
            - Respetar los términos de servicio de plataformas de terceros
            
            ## Propiedad Intelectual
            
            SkipFeed y todo su contenido están protegidos por derechos de autor y otras leyes de propiedad intelectual.
            
            ## Exenciones de Responsabilidad
            
            SkipFeed se proporciona "tal como está" sin garantías expresas o implícitas.
            
            ## Limitación de Responsabilidad
            
            En la máxima medida permitida por la ley, no somos responsables de daños indirectos, incidentales o consecuentes.
            
            ## Cambios en los Términos
            
            Podemos actualizar estos términos. Los cambios significativos se comunicarán a través de notificaciones in-app.
            
            ## Información de Contacto
            
            Para preguntas, contacta: support@skipfeed.app
            """
        case "fr":
            return """
            # Conditions de Service SkipFeed
            
            **Date d'entrée en vigueur : 24 juillet 2025**
            
            ## Acceptation des Conditions
            
            En utilisant SkipFeed, vous acceptez ces Conditions de Service.
            
            ## Description du Service
            
            SkipFeed est une application d'agrégation de recherche qui vous aide à rechercher efficacement sur plusieurs plateformes :
            - YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook
            - Fournit des capacités de recherche directe et de navigation in-app
            - Historique de recherche et analyses d'utilisation
            
            ## Licence d'Utilisation
            
            Nous vous accordons une licence limitée, non exclusive et non transférable pour utiliser SkipFeed.
            
            ## Responsabilités de l'Utilisateur
            
            Vous acceptez de :
            - Respecter toutes les lois et réglementations applicables
            - Ne pas abuser ou interférer avec le service
            - Ne pas tenter de faire de l'ingénierie inverse de l'application
            - Respecter les conditions de service des plateformes tierces
            
            ## Propriété Intellectuelle
            
            SkipFeed et tout son contenu sont protégés par le droit d'auteur et d'autres lois sur la propriété intellectuelle.
            
            ## Avertissements
            
            SkipFeed est fourni "tel quel" sans aucune garantie expresse ou implicite.
            
            ## Limitation de Responsabilité
            
            Dans la mesure maximale autorisée par la loi, nous ne sommes pas responsables des dommages indirects, accessoires ou consécutifs.
            
            ## Modifications des Conditions
            
            Nous pouvons mettre à jour ces conditions. Les changements importants seront communiqués via des notifications in-app.
            
            ## Informations de Contact
            
            Pour toute question, contactez : support@skipfeed.app
            """
        case "de":
            return """
            # SkipFeed Nutzungsbedingungen
            
            **Gültigkeitsdatum: 24. Juli 2025**
            
            ## Annahme der Bedingungen
            
            Durch die Nutzung von SkipFeed stimmen Sie diesen Nutzungsbedingungen zu.
            
            ## Service-Beschreibung
            
            SkipFeed ist eine Such-Aggregations-App, die Ihnen hilft, effizient auf mehreren Plattformen zu suchen:
            - YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook
            - Bietet direkte Such- und In-App-Browsing-Funktionen
            - Suchverlauf und Nutzungsanalysen
            
            ## Nutzungslizenz
            
            Wir gewähren Ihnen eine begrenzte, nicht-exklusive, nicht übertragbare Lizenz zur Nutzung von SkipFeed.
            
            ## Nutzerverantwortlichkeiten
            
            Sie stimmen zu:
            - Alle geltenden Gesetze und Vorschriften einzuhalten
            - Den Service nicht zu missbrauchen oder zu stören
            - Nicht zu versuchen, die App zurückzuentwickeln
            - Die Nutzungsbedingungen von Drittanbieter-Plattformen zu respektieren
            
            ## Geistiges Eigentum
            
            SkipFeed und alle seine Inhalte sind durch Urheberrechte und andere Gesetze zum geistigen Eigentum geschützt.
            
            ## Haftungsausschlüsse
            
            SkipFeed wird "wie besehen" ohne ausdrückliche oder stillschweigende Gewährleistungen bereitgestellt.
            
            ## Haftungsbeschränkung
            
            Im gesetzlich zulässigen Umfang haften wir nicht für indirekte, zufällige oder Folgeschäden.
            
            ## Änderungen der Bedingungen
            
            Wir können diese Bedingungen aktualisieren. Wesentliche Änderungen werden über In-App-Benachrichtigungen kommuniziert.
            
            ## Kontaktinformationen
            
            Für Fragen kontaktieren Sie: support@skipfeed.app
            """
        case "it":
            return """
            # Termini di Servizio SkipFeed
            
            **Data di entrata in vigore: 24 luglio 2025**
            
            ## Accettazione dei Termini
            
            Utilizzando SkipFeed, accetti questi Termini di Servizio.
            
            ## Descrizione del Servizio
            
            SkipFeed è un'app di aggregazione ricerche che ti aiuta a cercare efficacemente su più piattaforme:
            - YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook
            - Fornisce capacità di ricerca diretta e navigazione in-app
            - Cronologia ricerche e analisi di utilizzo
            
            ## Licenza d'Uso
            
            Ti concediamo una licenza limitata, non esclusiva e non trasferibile per usare SkipFeed.
            
            ## Responsabilità dell'Utente
            
            Accetti di:
            - Rispettare tutte le leggi e regolamenti applicabili
            - Non abusare o interferire con il servizio
            - Non tentare di fare reverse engineering dell'app
            - Rispettare i termini di servizio delle piattaforme di terze parti
            
            ## Proprietà Intellettuale
            
            SkipFeed e tutti i suoi contenuti sono protetti da copyright e altre leggi sulla proprietà intellettuale.
            
            ## Esclusioni di Responsabilità
            
            SkipFeed è fornito "così com'è" senza garanzie espresse o implicite.
            
            ## Limitazione di Responsabilità
            
            Nella misura massima consentita dalla legge, non siamo responsabili per danni indiretti, incidentali o consequenziali.
            
            ## Modifiche ai Termini
            
            Possiamo aggiornare questi termini. I cambiamenti significativi saranno comunicati tramite notifiche in-app.
            
            ## Informazioni di Contatto
            
            Per domande, contatta: support@skipfeed.app
            """
        case "pt":
            return """
            # Termos de Serviço do SkipFeed
            
            **Data de vigência: 24 de julho de 2025**
            
            ## Aceitação dos Termos
            
            Ao usar o SkipFeed, você concorda com estes Termos de Serviço.
            
            ## Descrição do Serviço
            
            O SkipFeed é um app de agregação de pesquisas que ajuda você a pesquisar eficientemente em múltiplas plataformas:
            - YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook
            - Fornece capacidades de pesquisa direta e navegação in-app
            - Histórico de pesquisas e análises de uso
            
            ## Licença de Uso
            
            Concedemos a você uma licença limitada, não exclusiva e não transferível para usar o SkipFeed.
            
            ## Responsabilidades do Usuário
            
            Você concorda em:
            - Cumprir todas as leis e regulamentações aplicáveis
            - Não abusar ou interferir com o serviço
            - Não tentar fazer engenharia reversa do app
            - Respeitar os termos de serviço de plataformas de terceiros
            
            ## Propriedade Intelectual
            
            O SkipFeed e todo seu conteúdo são protegidos por direitos autorais e outras leis de propriedade intelectual.
            
            ## Isenções de Responsabilidade
            
            O SkipFeed é fornecido "como está" sem garantias expressas ou implícitas.
            
            ## Limitação de Responsabilidade
            
            Na máxima extensão permitida por lei, não somos responsáveis por danos indiretos, incidentais ou consequenciais.
            
            ## Alterações nos Termos
            
            Podemos atualizar estes termos. Mudanças significativas serão comunicadas através de notificações in-app.
            
            ## Informações de Contato
            
            Para perguntas, contate: support@skipfeed.app
            """
        case "ru":
            return """
            # Условия Использования SkipFeed
            
            **Дата вступления в силу: 24 июля 2025 года**
            
            ## Принятие Условий
            
            Используя SkipFeed, вы соглашаетесь с этими Условиями Использования.
            
            ## Описание Сервиса
            
            SkipFeed - это приложение для агрегации поиска, которое помогает эффективно искать на нескольких платформах:
            - YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook
            - Предоставляет возможности прямого поиска и навигации в приложении
            - История поиска и аналитика использования
            
            ## Лицензия на Использование
            
            Мы предоставляем вам ограниченную, неэксклюзивную, непередаваемую лицензию на использование SkipFeed.
            
            ## Обязанности Пользователя
            
            Вы соглашаетесь:
            - Соблюдать все применимые законы и нормативные акты
            - Не злоупотреблять сервисом и не вмешиваться в его работу
            - Не пытаться выполнить обратную инженерию приложения
            - Соблюдать условия использования сторонних платформ
            
            ## Интеллектуальная Собственность
            
            SkipFeed и все его содержимое защищены авторскими правами и другими законами об интеллектуальной собственности.
            
            ## Отказ от Ответственности
            
            SkipFeed предоставляется "как есть" без каких-либо явных или подразумеваемых гарантий.
            
            ## Ограничение Ответственности
            
            В максимальной степени, разрешенной законом, мы не несем ответственности за любые косвенные, случайные или последующие ущербы.
            
            ## Изменения в Условиях
            
            Мы можем обновить эти условия. Существенные изменения будут сообщены через уведомления в приложении.
            
            ## Контактная Информация
            
            По вопросам обращайтесь: support@skipfeed.app
            """
        case "ja":
            return """
            # SkipFeed 利用規約
            
            **発効日：2025年7月24日**
            
            ## 規約の承諾
            
            SkipFeedを使用することにより、お客様はこれらの利用規約に同意したものとみなされます。
            
            ## サービスの説明
            
            SkipFeedは、複数のプラットフォームで効率的に検索できる検索集約アプリです：
            - YouTube、Reddit、X（Twitter）、TikTok、Instagram、Facebook
            - 直接検索とアプリ内ブラウジング機能を提供
            - 検索履歴と使用状況分析
            
            ## 使用許諾
            
            私たちはお客様にSkipFeedを使用するための限定的、非独占的、譲渡不可能なライセンスを付与します。
            
            ## ユーザーの責任
            
            お客様は以下に同意します：
            - 適用されるすべての法律および規制を遵守する
            - サービスを濫用したり妨害したりしない
            - アプリのリバースエンジニアリングを試みない
            - サードパーティプラットフォームの利用規約を尊重する
            
            ## 知的財産
            
            SkipFeedとそのすべてのコンテンツは著作権およびその他の知的財産法によって保護されています。
            
            ## 免責事項
            
            SkipFeedは明示または黙示の保証なしに「現状のまま」提供されます。
            
            ## 責任の制限
            
            法律で許可される最大範囲において、私たちは間接的、付随的、または結果的損害について責任を負いません。
            
            ## 規約の変更
            
            私たちはこれらの規約を更新する場合があります。重要な変更はアプリ内通知を通じて伝達されます。
            
            ## 連絡先情報
            
            ご質問については以下にお問い合わせください：support@skipfeed.app
            """
        case "ko":
            return """
            # SkipFeed 서비스 이용약관
            
            **시행일: 2025년 7월 24일**
            
            ## 약관 동의
            
            SkipFeed를 사용함으로써 귀하는 이 서비스 이용약관에 동의하게 됩니다.
            
            ## 서비스 설명
            
            SkipFeed는 여러 플랫폼에서 효율적으로 검색할 수 있도록 도와주는 검색 통합 앱입니다:
            - YouTube, Reddit, X (Twitter), TikTok, Instagram, Facebook
            - 직접 검색 및 인앱 브라우징 기능 제공
            - 검색 기록 및 사용 분석
            
            ## 사용 라이선스
            
            저희는 귀하에게 SkipFeed를 사용할 수 있는 제한적이고 비독점적이며 양도 불가능한 라이선스를 부여합니다.
            
            ## 사용자 책임
            
            귀하는 다음에 동의합니다:
            - 모든 해당 법률 및 규정 준수
            - 서비스를 남용하거나 방해하지 않음
            - 앱을 리버스 엔지니어링하려고 시도하지 않음
            - 제3자 플랫폼의 서비스 약관 존중
            
            ## 지적 재산권
            
            SkipFeed와 모든 콘텐츠는 저작권 및 기타 지적 재산권법으로 보호됩니다.
            
            ## 면책 조항
            
            SkipFeed는 명시적 또는 묵시적 보증 없이 "있는 그대로" 제공됩니다.
            
            ## 책임 제한
            
            법률이 허용하는 최대 범위 내에서, 저희는 간접적, 부수적 또는 결과적 손해에 대해 책임지지 않습니다.
            
            ## 약관 변경
            
            저희는 이 약관을 업데이트할 수 있습니다. 중요한 변경사항은 인앱 알림을 통해 전달됩니다.
            
            ## 연락처 정보
            
            문의사항은 다음으로 연락해주세요: support@skipfeed.app
            """
        case "ar":
            return """
            # شروط الخدمة لـ SkipFeed
            
            **تاريخ السريان: 24 يوليو 2025**
            
            ## قبول الشروط
            
            باستخدام SkipFeed، فإنك توافق على شروط الخدمة هذه.
            
            ## وصف الخدمة
            
            SkipFeed هو تطبيق تجميع البحث الذي يساعدك على البحث بكفاءة عبر منصات متعددة:
            - YouTube، Reddit، X (Twitter)، TikTok، Instagram، Facebook
            - يوفر قدرات البحث المباشر والتصفح داخل التطبيق
            - تاريخ البحث وتحليلات الاستخدام
            
            ## ترخيص الاستخدام
            
            نمنحك ترخيصاً محدوداً وغير حصري وغير قابل للتحويل لاستخدام SkipFeed.
            
            ## مسؤوليات المستخدم
            
            أنت توافق على:
            - الامتثال لجميع القوانين واللوائح المعمول بها
            - عدم إساءة استخدام الخدمة أو التدخل فيها
            - عدم محاولة الهندسة العكسية للتطبيق
            - احترام شروط خدمة المنصات الخارجية
            
            ## الملكية الفكرية
            
            SkipFeed وجميع محتوياته محمية بحقوق الطبع والنشر وقوانين الملكية الفكرية الأخرى.
            
            ## إخلاء المسؤولية
            
            يتم توفير SkipFeed "كما هو" دون أي ضمانات صريحة أو ضمنية.
            
            ## تحديد المسؤولية
            
            إلى أقصى حد يسمح به القانون، نحن غير مسؤولين عن أي أضرار غير مباشرة أو عرضية أو تبعية.
            
            ## تغييرات على الشروط
            
            قد نقوم بتحديث هذه الشروط. سيتم التواصل بشأن التغييرات المهمة من خلال الإشعارات داخل التطبيق.
            
            ## معلومات الاتصال
            
            للأسئلة، تواصل معنا: support@skipfeed.app
            """
        default:
            return """
            # SkipFeed Terms of Service
            
            **Effective Date: July 24, 2025**
            
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
            通过底部的统计标签页查看：
            - 7天和30天搜索趋势图表
            - 总搜索次数和今日搜索次数
            - 相比无限滚动节省的时间
            - 平台使用情况分析
            - 一天中不同时间的使用分析
            - 通过历史标签页查看搜索历史

            ### 🔄 如何清除搜索历史？
            在设置页面中点击"清除最近搜索"按钮。

            ### 📤 如何导出我的数据？
            1. 打开设置页面
            2. 点击"导出数据"选项
            3. 选择导出格式（CSV、TXT 或 JSON）
            4. 选择时间范围（最近7天、30天或全部时间）
            5. 选择要包含的内容：搜索查询、平台使用情况、统计数据
            6. 点击"导出数据"保存或分享文件

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
        case "es":
            return """
            # SkipFeed Soporte y FAQ

            ## Preguntas Frecuentes

            ### 🔍 ¿Cómo uso SkipFeed?
            1. Selecciona la plataforma que quieres buscar
            2. Ingresa tus palabras clave
            3. Toca el botón de búsqueda
            4. Elige abrir resultados en la app nativa o navegador

            ### 📱 ¿Qué plataformas están soportadas?
            - **YouTube** - Búsqueda de videos
            - **Reddit** - Discusiones de comunidad
            - **X (Twitter)** - Actualizaciones en tiempo real
            - **TikTok** - Videos cortos
            - **Instagram** - Fotos y videos
            - **Facebook** - Contenido social

            ### 🌍 ¿Cómo cambio el idioma?
            1. Abre Configuración
            2. Toca "Idioma"
            3. Selecciona tu idioma preferido o habilita detección automática

            ### 📊 ¿Cómo veo las estadísticas de uso?
            Accede a través de la pestaña Estadísticas en la parte inferior:
            - Gráficos de tendencias de 7 y 30 días
            - Búsquedas totales y de hoy
            - Tiempo ahorrado vs desplazamiento infinito
            - Desglose de uso de plataformas
            - Análisis de tiempo del día e insights
            - Historial de búsqueda a través de la pestaña Historial

            ### 🔄 ¿Cómo borro el historial de búsqueda?
            Toca "Borrar Búsquedas Recientes" en la página de Configuración.

            ### 📤 ¿Cómo exporto mis datos?
            1. Abre Configuración
            2. Toca "Exportar Datos"
            3. Elige formato de exportación (CSV, TXT, o JSON)
            4. Selecciona rango de tiempo (Últimos 7 días, 30 días, o Todo el tiempo)
            5. Elige qué incluir: consultas de búsqueda, uso de plataformas, estadísticas
            6. Toca "Exportar Datos" para guardar o compartir el archivo

            ### 💎 ¿Qué funciones premium están disponibles?
            - **Navegación en la App**: Navega contenido directamente dentro de SkipFeed
            - **No Molestar Automático**: Habilita automáticamente el modo enfoque
            - **Resumen con IA**: Resumen inteligente de contenido
            - **Búsquedas Ilimitadas**: Elimina límites diarios de búsqueda

            ## Solución de Problemas

            ### Los resultados de búsqueda no se abren
            - Asegúrate de que la app objetivo esté instalada
            - Verifica tu conexión a internet
            - Prueba abrir en el navegador

            ### La app funciona lento
            - Reinicia la app
            - Borra el historial de búsqueda
            - Reinicia tu dispositivo

            ### El cambio de idioma no funciona
            - Asegúrate de que el idioma correcto esté seleccionado
            - Reinicia la app
            - Verifica la configuración del idioma del sistema

            ## Solicitudes de Funciones

            ¡Aceptamos tus sugerencias! Si quieres nuevas funciones o soporte de plataformas, contáctanos.

            ## Soporte Técnico

            Para más asistencia, contacta:
            - **Email**: support@skipfeed.app
            - **Tiempo de Respuesta**: 24-48 horas

            ## Información de Versión

            La versión actual incluye:
            - Soporte multilingüe completo
            - Experiencia de búsqueda mejorada
            - Analíticas de uso mejoradas
            - Diseño de interfaz moderno
            """
        case "fr":
            return """
            # SkipFeed Support et FAQ

            ## Questions Fréquentes

            ### 🔍 Comment utiliser SkipFeed?
            1. Sélectionnez la plateforme que vous voulez rechercher
            2. Saisissez vos mots-clés
            3. Appuyez sur le bouton de recherche
            4. Choisissez d'ouvrir les résultats dans l'app native ou le navigateur

            ### 📱 Quelles plateformes sont supportées?
            - **YouTube** - Recherche de vidéos
            - **Reddit** - Discussions communautaires
            - **X (Twitter)** - Mises à jour en temps réel
            - **TikTok** - Vidéos courtes
            - **Instagram** - Photos et vidéos
            - **Facebook** - Contenu social

            ### 🌍 Comment changer la langue?
            1. Ouvrez les Paramètres
            2. Appuyez sur "Langue"
            3. Sélectionnez votre langue préférée ou activez la détection automatique

            ### 📊 Comment voir les statistiques d'utilisation?
            Accédez via l'onglet Stats en bas:
            - Graphiques de tendances sur 7 et 30 jours
            - Recherches totales et d'aujourd'hui
            - Temps économisé vs défilement infini
            - Répartition de l'utilisation des plateformes
            - Analyse de l'heure de la journée et insights
            - Historique de recherche via l'onglet Historique

            ### 🔄 Comment effacer l'historique de recherche?
            Appuyez sur "Effacer les Recherches Récentes" dans la page Paramètres.

            ### 📤 Comment exporter mes données?
            1. Ouvrez les Paramètres
            2. Appuyez sur "Exporter les Données"
            3. Choisissez le format d'exportation (CSV, TXT, ou JSON)
            4. Sélectionnez la plage de temps (7 derniers jours, 30 jours, ou Tout le temps)
            5. Choisissez quoi inclure: requêtes de recherche, utilisation des plateformes, statistiques
            6. Appuyez sur "Exporter les Données" pour sauvegarder ou partager le fichier

            ### 💎 Quelles fonctionnalités premium sont disponibles?
            - **Navigation dans l'App**: Naviguez le contenu directement dans SkipFeed
            - **Ne Pas Déranger Auto**: Active automatiquement le mode focus
            - **Résumé IA**: Résumé intelligent du contenu
            - **Recherches Illimitées**: Supprime les limites quotidiennes de recherche

            ## Dépannage

            ### Les résultats de recherche ne s'ouvrent pas
            - Assurez-vous que l'app cible est installée
            - Vérifiez votre connexion internet
            - Essayez d'ouvrir dans le navigateur

            ### L'app fonctionne lentement
            - Redémarrez l'app
            - Effacez l'historique de recherche
            - Redémarrez votre appareil

            ### Le changement de langue ne fonctionne pas
            - Assurez-vous que la bonne langue est sélectionnée
            - Redémarrez l'app
            - Vérifiez les paramètres de langue du système

            ## Demandes de Fonctionnalités

            Nous accueillons vos suggestions! Si vous voulez de nouvelles fonctionnalités ou support de plateformes, contactez-nous.

            ## Support Technique

            Pour plus d'assistance, contactez:
            - **Email**: support@skipfeed.app
            - **Temps de Réponse**: 24-48 heures

            ## Informations de Version

            La version actuelle inclut:
            - Support multilingue complet
            - Expérience de recherche améliorée
            - Analytiques d'utilisation améliorées
            - Design d'interface moderne
            """
        case "de":
            return """
            # SkipFeed Support & FAQ

            ## Häufig gestellte Fragen

            ### 🔍 Wie verwende ich SkipFeed?
            1. Wählen Sie die Plattform aus, die Sie durchsuchen möchten
            2. Geben Sie Ihre Suchbegriffe ein
            3. Tippen Sie auf die Suchschaltfläche
            4. Wählen Sie, ob Ergebnisse in der nativen App oder im Browser geöffnet werden sollen

            ### 📱 Welche Plattformen werden unterstützt?
            - **YouTube** - Videosuche
            - **Reddit** - Community-Diskussionen
            - **X (Twitter)** - Echtzeit-Updates
            - **TikTok** - Kurze Videos
            - **Instagram** - Fotos und Videos
            - **Facebook** - Social Content

            ### 🌍 Wie ändere ich die Sprache?
            1. Öffnen Sie die Einstellungen
            2. Tippen Sie auf "Sprache"
            3. Wählen Sie Ihre bevorzugte Sprache oder aktivieren Sie die automatische Erkennung

            ### 📊 Wie sehe ich Nutzungsstatistiken?
            Zugriff über den Stats-Tab unten:
            - 7-Tage und 30-Tage Trend-Diagramme
            - Gesamtsuchen und heutige Suchen
            - Gesparte Zeit vs endloses Scrollen
            - Platform-Nutzungsaufschlüsselung
            - Tageszeit-Analyse und Insights
            - Suchverlauf über den Verlauf-Tab

            ### 🔄 Wie lösche ich den Suchverlauf?
            Tippen Sie auf "Letzte Suchen löschen" auf der Einstellungsseite.

            ### 📤 Wie exportiere ich meine Daten?
            1. Öffnen Sie die Einstellungen
            2. Tippen Sie auf "Daten exportieren"
            3. Wählen Sie das Exportformat (CSV, TXT oder JSON)
            4. Wählen Sie den Zeitraum (Letzte 7 Tage, 30 Tage oder Alle Zeit)
            5. Wählen Sie was enthalten sein soll: Suchanfragen, Platform-Nutzung, Statistiken
            6. Tippen Sie auf "Daten exportieren" um die Datei zu speichern oder zu teilen

            ### 💎 Welche Premium-Funktionen sind verfügbar?
            - **In-App-Browsing**: Durchsuchen Sie Inhalte direkt in SkipFeed
            - **Auto Nicht Stören**: Aktiviert automatisch den Focus-Modus
            - **KI-Zusammenfassung**: Intelligente Inhaltszusammenfassung
            - **Unbegrenzte Suchen**: Entfernt tägliche Suchlimits

            ## Fehlerbehebung

            ### Suchergebnisse öffnen sich nicht
            - Stellen Sie sicher, dass die Ziel-App installiert ist
            - Überprüfen Sie Ihre Internetverbindung
            - Versuchen Sie im Browser zu öffnen

            ### App läuft langsam
            - Starten Sie die App neu
            - Löschen Sie den Suchverlauf
            - Starten Sie Ihr Gerät neu

            ### Sprachwechsel funktioniert nicht
            - Stellen Sie sicher, dass die richtige Sprache ausgewählt ist
            - Starten Sie die App neu
            - Überprüfen Sie die Systemspracheinstellungen

            ## Feature-Anfragen

            Wir begrüßen Ihre Vorschläge! Wenn Sie neue Features oder Platform-Support wünschen, kontaktieren Sie uns.

            ## Technischer Support

            Für weitere Hilfe, kontaktieren Sie:
            - **Email**: support@skipfeed.app
            - **Antwortzeit**: 24-48 Stunden

            ## Versionsinformationen

            Die aktuelle Version beinhaltet:
            - Vollständige mehrsprachige Unterstützung
            - Verbesserte Sucherfahrung
            - Erweiterte Nutzungsanalytik
            - Modernes Interface-Design
            """
        case "it":
            return """
            # SkipFeed Supporto e FAQ

            ## Domande Frequenti

            ### 🔍 Come uso SkipFeed?
            1. Seleziona la piattaforma che vuoi cercare
            2. Inserisci le tue parole chiave
            3. Tocca il pulsante di ricerca
            4. Scegli di aprire i risultati nell'app nativa o nel browser

            ### 📱 Quali piattaforme sono supportate?
            - **YouTube** - Ricerca video
            - **Reddit** - Discussioni della community
            - **X (Twitter)** - Aggiornamenti in tempo reale
            - **TikTok** - Video brevi
            - **Instagram** - Foto e video
            - **Facebook** - Contenuto sociale

            ### 🌍 Come cambio la lingua?
            1. Apri le Impostazioni
            2. Tocca "Lingua"
            3. Seleziona la tua lingua preferita o abilita il rilevamento automatico

            ### 📊 Come vedo le statistiche di utilizzo?
            Accedi tramite la scheda Stats in basso:
            - Grafici di tendenza a 7 e 30 giorni
            - Ricerche totali e di oggi
            - Tempo risparmiato vs scorrimento infinito
            - Suddivisione dell'utilizzo delle piattaforme
            - Analisi dell'ora del giorno e insights
            - Cronologia delle ricerche tramite la scheda Cronologia

            ### 🔄 Come cancello la cronologia delle ricerche?
            Tocca "Cancella Ricerche Recenti" nella pagina Impostazioni.

            ### 📤 Come esporto i miei dati?
            1. Apri le Impostazioni
            2. Tocca "Esporta Dati"
            3. Scegli il formato di esportazione (CSV, TXT, o JSON)
            4. Seleziona l'intervallo di tempo (Ultimi 7 giorni, 30 giorni, o Tutto il tempo)
            5. Scegli cosa includere: query di ricerca, utilizzo piattaforme, statistiche
            6. Tocca "Esporta Dati" per salvare o condividere il file

            ### 💎 Quali funzionalità premium sono disponibili?
            - **Navigazione In-App**: Naviga i contenuti direttamente in SkipFeed
            - **Auto Non Disturbare**: Abilita automaticamente la modalità focus
            - **Riassunto IA**: Riassunto intelligente dei contenuti
            - **Ricerche Illimitate**: Rimuove i limiti giornalieri di ricerca

            ## Risoluzione Problemi

            ### I risultati di ricerca non si aprono
            - Assicurati che l'app di destinazione sia installata
            - Controlla la tua connessione internet
            - Prova ad aprire nel browser

            ### L'app funziona lentamente
            - Riavvia l'app
            - Cancella la cronologia delle ricerche
            - Riavvia il tuo dispositivo

            ### Il cambio lingua non funziona
            - Assicurati che la lingua corretta sia selezionata
            - Riavvia l'app
            - Controlla le impostazioni della lingua di sistema

            ## Richieste di Funzionalità

            Accogliamo i tuoi suggerimenti! Se desideri nuove funzionalità o supporto per piattaforme, contattaci.

            ## Supporto Tecnico

            Per ulteriore assistenza, contatta:
            - **Email**: support@skipfeed.app
            - **Tempo di Risposta**: 24-48 ore

            ## Informazioni sulla Versione

            La versione attuale include:
            - Supporto multilingue completo
            - Esperienza di ricerca migliorata
            - Analitiche di utilizzo migliorate
            - Design dell'interfaccia moderno
            """
        case "pt":
            return """
            # SkipFeed Suporte e FAQ

            ## Perguntas Frequentes

            ### 🔍 Como uso o SkipFeed?
            1. Selecione a plataforma que você quer pesquisar
            2. Digite suas palavras-chave
            3. Toque no botão de pesquisa
            4. Escolha abrir os resultados no app nativo ou navegador

            ### 📱 Quais plataformas são suportadas?
            - **YouTube** - Busca de vídeos
            - **Reddit** - Discussões da comunidade
            - **X (Twitter)** - Atualizações em tempo real
            - **TikTok** - Vídeos curtos
            - **Instagram** - Fotos e vídeos
            - **Facebook** - Conteúdo social

            ### 🌍 Como mudo o idioma?
            1. Abra as Configurações
            2. Toque em "Idioma"
            3. Selecione seu idioma preferido ou habilite detecção automática

            ### 📊 Como vejo as estatísticas de uso?
            Acesse através da aba Stats na parte inferior:
            - Gráficos de tendência de 7 e 30 dias
            - Pesquisas totais e de hoje
            - Tempo economizado vs rolagem infinita
            - Divisão de uso das plataformas
            - Análise de horário do dia e insights
            - Histórico de pesquisas via aba Histórico

            ### 🔄 Como limpo o histórico de pesquisas?
            Toque em "Limpar Pesquisas Recentes" na página de Configurações.

            ### 📤 Como exporto meus dados?
            1. Abra as Configurações
            2. Toque em "Exportar Dados"
            3. Escolha o formato de exportação (CSV, TXT, ou JSON)
            4. Selecione o intervalo de tempo (Últimos 7 dias, 30 dias, ou Todo o tempo)
            5. Escolha o que incluir: consultas de pesquisa, uso de plataformas, estatísticas
            6. Toque em "Exportar Dados" para salvar ou compartilhar o arquivo

            ### 💎 Quais recursos premium estão disponíveis?
            - **Navegação no App**: Navegue conteúdo diretamente no SkipFeed
            - **Auto Não Perturbe**: Ativa automaticamente o modo foco
            - **Resumo IA**: Resumo inteligente de conteúdo
            - **Pesquisas Ilimitadas**: Remove limites diários de pesquisa

            ## Solução de Problemas

            ### Resultados de pesquisa não abrem
            - Certifique-se de que o app de destino está instalado
            - Verifique sua conexão com a internet
            - Tente abrir no navegador

            ### App está lento
            - Reinicie o app
            - Limpe o histórico de pesquisas
            - Reinicie seu dispositivo

            ### Mudança de idioma não funciona
            - Certifique-se de que o idioma correto está selecionado
            - Reinicie o app
            - Verifique as configurações de idioma do sistema

            ## Solicitações de Recursos

            Acolhemos suas sugestões! Se você quer novos recursos ou suporte de plataformas, entre em contato.

            ## Suporte Técnico

            Para mais assistência, entre em contato:
            - **Email**: support@skipfeed.app
            - **Tempo de Resposta**: 24-48 horas

            ## Informações da Versão

            A versão atual inclui:
            - Suporte multilíngue completo
            - Experiência de pesquisa melhorada
            - Analíticas de uso aprimoradas
            - Design de interface moderno
            """
        case "ru":
            return """
            # SkipFeed Поддержка и FAQ

            ## Часто задаваемые вопросы

            ### 🔍 Как использовать SkipFeed?
            1. Выберите платформу для поиска
            2. Введите ключевые слова
            3. Нажмите кнопку поиска
            4. Выберите открытие результатов в нативном приложении или браузере

            ### 📱 Какие платформы поддерживаются?
            - **YouTube** - Поиск видео
            - **Reddit** - Обсуждения сообщества
            - **X (Twitter)** - Обновления в реальном времени
            - **TikTok** - Короткие видео
            - **Instagram** - Фото и видео
            - **Facebook** - Социальный контент

            ### 🌍 Как изменить язык?
            1. Откройте Настройки
            2. Нажмите "Язык"
            3. Выберите предпочитаемый язык или включите автоопределение

            ### 📊 Как просмотреть статистику использования?
            Доступ через вкладку Статистика внизу:
            - Графики трендов за 7 и 30 дней
            - Общие поиски и сегодняшние
            - Сэкономленное время против бесконечной прокрутки
            - Разбивка использования платформ
            - Анализ времени дня и инсайты
            - История поиска через вкладку История

            ### 🔄 Как очистить историю поиска?
            Нажмите "Очистить недавние поиски" на странице Настройки.

            ### 📤 Как экспортировать мои данные?
            1. Откройте Настройки
            2. Нажмите "Экспорт данных"
            3. Выберите формат экспорта (CSV, TXT, или JSON)
            4. Выберите временной диапазон (Последние 7 дней, 30 дней, или Все время)
            5. Выберите что включить: поисковые запросы, использование платформ, статистику
            6. Нажмите "Экспорт данных" чтобы сохранить или поделиться файлом

            ### 💎 Какие премиум функции доступны?
            - **Просмотр в приложении**: Просматривайте контент прямо в SkipFeed
            - **Авто Не беспокоить**: Автоматически включает режим фокуса
            - **ИИ Резюме**: Умное резюмирование контента
            - **Неограниченные поиски**: Убирает дневные лимиты поиска

            ## Устранение неполадок

            ### Результаты поиска не открываются
            - Убедитесь, что целевое приложение установлено
            - Проверьте интернет-соединение
            - Попробуйте открыть в браузере

            ### Приложение работает медленно
            - Перезапустите приложение
            - Очистите историю поиска
            - Перезагрузите устройство

            ### Смена языка не работает
            - Убедитесь, что правильный язык выбран
            - Перезапустите приложение
            - Проверьте настройки языка системы

            ## Запросы функций

            Мы приветствуем ваши предложения! Если вы хотите новые функции или поддержку платформ, свяжитесь с нами.

            ## Техническая поддержка

            Для дополнительной помощи, свяжитесь:
            - **Email**: support@skipfeed.app
            - **Время ответа**: 24-48 часов

            ## Информация о версии

            Текущая версия включает:
            - Полная многоязычная поддержка
            - Улучшенный опыт поиска
            - Расширенная аналитика использования
            - Современный дизайн интерфейса
            """
        case "ja":
            return """
            # SkipFeed サポート & FAQ

            ## よくある質問

            ### 🔍 SkipFeedの使い方は？
            1. 検索したいプラットフォームを選択
            2. キーワードを入力
            3. 検索ボタンをタップ
            4. ネイティブアプリまたはブラウザで結果を開くかを選択

            ### 📱 どのプラットフォームがサポートされていますか？
            - **YouTube** - 動画検索
            - **Reddit** - コミュニティディスカッション
            - **X (Twitter)** - リアルタイム更新
            - **TikTok** - ショート動画
            - **Instagram** - 写真と動画
            - **Facebook** - ソーシャルコンテンツ

            ### 🌍 言語を変更するには？
            1. 設定を開く
            2. "言語"をタップ
            3. 好みの言語を選択するか自動検出を有効にする

            ### 📊 使用統計を表示するには？
            下部の統計タブからアクセス：
            - 7日と30日のトレンドチャート
            - 総検索数と今日の検索数
            - 無限スクロールと比較した節約時間
            - プラットフォーム使用量の内訳
            - 時間帯分析とインサイト
            - 履歴タブから検索履歴

            ### 🔄 検索履歴をクリアするには？
            設定ページの「最近の検索をクリア」をタップ。

            ### 📤 データをエクスポートするには？
            1. 設定を開く
            2. "データエクスポート"をタップ
            3. エクスポート形式を選択（CSV、TXT、またはJSON）
            4. 時間範囲を選択（過去7日、30日、または全期間）
            5. 含める内容を選択：検索クエリ、プラットフォーム使用量、統計
            6. "データエクスポート"をタップしてファイルを保存または共有

            ### 💎 どのプレミアム機能が利用できますか？
            - **アプリ内ブラウジング**: SkipFeed内でコンテンツを直接閲覧
            - **自動おやすみモード**: フォーカスモードを自動的に有効化
            - **AI要約**: インテリジェントなコンテンツ要約
            - **無制限検索**: 日次検索制限を削除

            ## トラブルシューティング

            ### 検索結果が開かない
            - ターゲットアプリがインストールされていることを確認
            - インターネット接続を確認
            - ブラウザで開くことを試す

            ### アプリが遅い
            - アプリを再起動
            - 検索履歴をクリア
            - デバイスを再起動

            ### 言語切り替えが機能しない
            - 正しい言語が選択されていることを確認
            - アプリを再起動
            - システム言語設定を確認

            ## 機能リクエスト

            ご提案をお待ちしています！新機能やプラットフォームサポートをご希望の場合は、お気軽にお問い合わせください。

            ## 技術サポート

            さらなるサポートについては、お問い合わせください：
            - **Email**: support@skipfeed.app
            - **応答時間**: 24-48時間

            ## バージョン情報

            現在のバージョンには以下が含まれます：
            - 完全な多言語サポート
            - 改善された検索体験
            - 強化された使用統計
            - モダンなインターフェースデザイン
            """
        case "ko":
            return """
            # SkipFeed 지원 & FAQ

            ## 자주 묻는 질문

            ### 🔍 SkipFeed를 어떻게 사용하나요?
            1. 검색하고 싶은 플랫폼 선택
            2. 키워드 입력
            3. 검색 버튼 탭
            4. 네이티브 앱 또는 브라우저에서 결과 열기 선택

            ### 📱 어떤 플랫폼이 지원되나요?
            - **YouTube** - 동영상 검색
            - **Reddit** - 커뮤니티 토론
            - **X (Twitter)** - 실시간 업데이트
            - **TikTok** - 숏폼 동영상
            - **Instagram** - 사진과 동영상
            - **Facebook** - 소셜 콘텐츠

            ### 🌍 언어를 어떻게 변경하나요?
            1. 설정 열기
            2. "언어" 탭
            3. 선호하는 언어를 선택하거나 자동 감지 활성화

            ### 📊 사용 통계를 어떻게 보나요?
            하단의 통계 탭을 통해 접근:
            - 7일 및 30일 트렌드 차트
            - 총 검색수와 오늘의 검색수
            - 무한 스크롤 대비 절약된 시간
            - 플랫폼 사용량 분석
            - 시간대별 분석 및 인사이트
            - 히스토리 탭을 통한 검색 기록

            ### 🔄 검색 기록을 어떻게 지우나요?
            설정 페이지에서 "최근 검색 지우기"를 탭하세요.

            ### 📤 데이터를 어떻게 내보내나요?
            1. 설정 열기
            2. "데이터 내보내기" 탭
            3. 내보내기 형식 선택 (CSV, TXT, 또는 JSON)
            4. 시간 범위 선택 (최근 7일, 30일, 또는 전체 기간)
            5. 포함할 내용 선택: 검색 쿼리, 플랫폼 사용량, 통계
            6. "데이터 내보내기"를 탭하여 파일을 저장하거나 공유

            ### 💎 어떤 프리미엄 기능이 제공되나요?
            - **앱 내 브라우징**: SkipFeed 내에서 직접 콘텐츠 탐색
            - **자동 방해금지**: 포커스 모드를 자동으로 활성화
            - **AI 요약**: 스마트 콘텐츠 요약
            - **무제한 검색**: 일일 검색 제한 제거

            ## 문제 해결

            ### 검색 결과가 열리지 않음
            - 대상 앱이 설치되었는지 확인
            - 인터넷 연결 확인
            - 브라우저에서 열기 시도

            ### 앱이 느림
            - 앱 재시작
            - 검색 기록 지우기
            - 기기 재시작

            ### 언어 전환이 작동하지 않음
            - 올바른 언어가 선택되었는지 확인
            - 앱 재시작
            - 시스템 언어 설정 확인

            ## 기능 요청

            여러분의 제안을 환영합니다! 새로운 기능이나 플랫폼 지원을 원하시면 연락해 주세요.

            ## 기술 지원

            추가 지원이 필요하시면 연락하세요:
            - **Email**: support@skipfeed.app
            - **응답 시간**: 24-48시간

            ## 버전 정보

            현재 버전 포함 사항:
            - 완전한 다국어 지원
            - 향상된 검색 경험
            - 개선된 사용 분석
            - 모던한 인터페이스 디자인
            """
        case "ar":
            return """
            # SkipFeed الدعم والأسئلة الشائعة

            ## الأسئلة الشائعة

            ### 🔍 كيف أستخدم SkipFeed؟
            1. اختر المنصة التي تريد البحث فيها
            2. أدخل كلماتك المفتاحية
            3. اضغط على زر البحث
            4. اختر فتح النتائج في التطبيق الأصلي أو المتصفح

            ### 📱 ما هي المنصات المدعومة؟
            - **YouTube** - البحث في الفيديوهات
            - **Reddit** - مناقشات المجتمع
            - **X (Twitter)** - التحديثات المباشرة
            - **TikTok** - الفيديوهات القصيرة
            - **Instagram** - الصور والفيديوهات
            - **Facebook** - المحتوى الاجتماعي

            ### 🌍 كيف أغير اللغة؟
            1. افتح الإعدادات
            2. اضغط على "اللغة"
            3. اختر لغتك المفضلة أو فعّل الكشف التلقائي

            ### 📊 كيف أشاهد إحصائيات الاستخدام؟
            الوصول عبر تبويب الإحصائيات في الأسفل:
            - مخططات الاتجاهات لـ 7 و 30 يوم
            - إجمالي البحثات وبحثات اليوم
            - الوقت المُوفر مقارنة بالتمرير اللانهائي
            - تفصيل استخدام المنصات
            - تحليل أوقات اليوم والرؤى
            - تاريخ البحث عبر تبويب التاريخ

            ### 🔄 كيف أمحو تاريخ البحث؟
            اضغط على "محو البحثات الأخيرة" في صفحة الإعدادات.

            ### 📤 كيف أصدر بياناتي؟
            1. افتح الإعدادات
            2. اضغط على "تصدير البيانات"
            3. اختر تنسيق التصدير (CSV، TXT، أو JSON)
            4. اختر النطاق الزمني (آخر 7 أيام، 30 يوم، أو كل الوقت)
            5. اختر ما تريد تضمينه: استعلامات البحث، استخدام المنصات، الإحصائيات
            6. اضغط على "تصدير البيانات" لحفظ أو مشاركة الملف

            ### 💎 ما هي الميزات المميزة المتاحة؟
            - **التصفح داخل التطبيق**: تصفح المحتوى مباشرة داخل SkipFeed
            - **عدم الإزعاج التلقائي**: يفعل وضع التركيز تلقائياً
            - **ملخص الذكاء الاصطناعي**: تلخيص ذكي للمحتوى
            - **بحثات لا محدودة**: إزالة حدود البحث اليومية

            ## استكشاف الأخطاء وإصلاحها

            ### نتائج البحث لا تفتح
            - تأكد من تثبيت التطبيق المطلوب
            - تحقق من اتصال الإنترنت
            - جرب الفتح في المتصفح

            ### التطبيق بطيء
            - أعد تشغيل التطبيق
            - امحو تاريخ البحث
            - أعد تشغيل جهازك

            ### تبديل اللغة لا يعمل
            - تأكد من اختيار اللغة الصحيحة
            - أعد تشغيل التطبيق
            - تحقق من إعدادات لغة النظام

            ## طلبات الميزات

            نرحب بمقترحاتكم! إذا كنتم تريدون ميزات جديدة أو دعم منصات، اتصلوا بنا.

            ## الدعم التقني

            للمساعدة الإضافية، اتصلوا بـ:
            - **البريد الإلكتروني**: support@skipfeed.app
            - **وقت الاستجابة**: 24-48 ساعة

            ## معلومات الإصدار

            الإصدار الحالي يتضمن:
            - دعم متعدد اللغات كامل
            - تجربة بحث محسّنة
            - تحليلات استخدام متقدمة
            - تصميم واجهة عصري
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
            Access through the Stats tab at the bottom:
            - 7-day and 30-day search trend charts
            - Total searches and today's searches
            - Time saved vs infinite scrolling
            - Platform usage breakdown
            - Time of day analysis and insights
            - Search history via History tab

            ### 🔄 How do I clear search history?
            Tap "Clear Recent Searches" in the Settings page.

            ### 📤 How do I export my data?
            1. Open Settings
            2. Tap "Export Data"
            3. Choose export format (CSV, TXT, or JSON)
            4. Select time range (Last 7 days, 30 days, or All time)
            5. Choose what to include: search queries, platform usage, statistics
            6. Tap "Export Data" to save or share the file

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
