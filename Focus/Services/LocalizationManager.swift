import Foundation
import SwiftUI

// MARK: - Localization Manager
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "app_language")
            NotificationCenter.default.post(name: .localizationChanged, object: currentLanguage)
            objectWillChange.send()
        }
    }
    
    private let supportedLanguages = [
        "en": "English",
        "es": "Español",
        "fr": "Français",
        "de": "Deutsch",
        "it": "Italiano",
        "pt": "Português",
        "ru": "Русский",
        "ja": "日本語",
        "ko": "한국어",
        "zh": "中文",
        "ar": "العربية"
    ]
    
    private init() {
        // Load saved language or use system language
        if let savedLanguage = UserDefaults.standard.string(forKey: "app_language") {
            self.currentLanguage = savedLanguage
        } else {
            self.currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        }
    }
    
    // MARK: - Public Methods
    
    func getSupportedLanguages() -> [(code: String, name: String)] {
        return supportedLanguages.map { (code: $0.key, name: $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    func getLanguageName(for code: String) -> String {
        return supportedLanguages[code] ?? "Unknown"
    }
    
    func setLanguage(_ languageCode: String) {
        guard supportedLanguages.keys.contains(languageCode) else { return }
        currentLanguage = languageCode
    }
    
    func getSystemLanguage() -> String {
        return Locale.current.language.languageCode?.identifier ?? "en"
    }

    func isRightToLeft() -> Bool {
        return currentLanguage == "ar" // Arabic is RTL
    }
    
    // MARK: - Localized Strings
    
    func localizedString(_ key: LocalizedStringKey) -> String {
        switch key {
        // Main UI
        case .search:
            return getSearchText()
        case .searchPlaceholder:
            return getSearchPlaceholder()
        case .settings:
            return getSettingsText()
        case .premium:
            return getPremiumText()
        case .data:
            return getDataText()
        case .choosePlatform:
            return getChoosePlatformText()
        case .recentSearches:
            return getRecentSearchesText()
        case .clear:
            return getClearText()
        case .searchOn:
            return getSearchOnText()
        case .openIn:
            return getOpenInText()
        case .openTikTokSearch:
            return getOpenTikTokSearchText()
        case .direct:
            return getDirectText()
        case .inApp:
            return getInAppText()

        // Stats
        case .totalSearches:
            return getTotalSearchesText()
        case .today:
            return getTodayText()
        case .timeSaved:
            return getTimeSavedText()
        case .platformUsage:
            return getPlatformUsageText()
        case .searchHistory:
            return getSearchHistoryText()
        case .stats:
            return getStatsText()
        case .history:
            return getHistoryText()
        case .dailyLimit:
            return getDailyLimitText()
        case .insights:
            return getInsightsText()
        case .focusScore:
            return getFocusScoreText()
        case .stayingFocused:
            return getStayingFocusedText()
        case .todaysImpact:
            return getTodaysImpactText()
        case .timeSavedFromDistractions:
            return getTimeSavedFromDistractionsText()
        case .efficiency:
            return getEfficiencyText()
        case .directSearchesSaveTime:
            return getDirectSearchesSaveTimeText()
        case .searches:
            return getSearchesText()
        case .left:
            return getLeftText()
        case .of:
            return getOfText()
        case .trial:
            return getTrialText()

        // Settings
        case .language:
            return getLanguageText()
        case .autoDetect:
            return getAutoDetectText()
        case .autoDetectSubtitle:
            return getAutoDetectSubtitleText()
        case .searchMode:
            return getSearchModeText()
        case .directSearch:
            return getDirectSearchText()
        // Do Not Disturb functionality removed
        case .done:
            return getDoneText()
        case .selectLanguage:
            return getSelectLanguageText()
        case .searchPreferences:
            return getSearchPreferencesText()
        case .preferences:
            return getPreferencesText()
        case .premiumFeatures:
            return getPremiumFeaturesText()
        case .usageAndData:
            return getUsageAndDataText()
        case .freeTrialActive:
            return getFreeTrialActiveText()
        case .daysRemaining:
            return getDaysRemainingText()
        case .clearRecentSearches:
            return getClearRecentSearchesText()
        case .searchModeDescription:
            return getSearchModeDescriptionText()
        // Auto Do Not Disturb functionality removed
        case .dailySearchLimitDescription:
            return getDailySearchLimitDescriptionText()
        // Auto Do Not Disturb functionality removed
        case .creditsLeft:
            return getCreditsLeftText()
        case .searchesPerDay:
            return getSearchesPerDayText()
        case .aboutAndSupport:
            return getAboutAndSupportText()
        case .version:
            return getVersionText()
        case .privacyPolicy:
            return getPrivacyPolicyText()
        case .termsOfService:
            return getTermsOfServiceText()
        case .supportAndFAQ:
            return getSupportAndFAQText()
        case .contactUs:
            return getContactUsText()

        // Premium
        case .upgradeToUnlock:
            return getUpgradeToUnlockText()
        case .freeTrial:
            return getFreeTrialText()
        case .startFreeTrial:
            return getStartFreeTrialText()
        case .restorePurchases:
            return getRestorePurchasesText()
            
        // Search History
        case .noHistory:
            return getNoHistoryText()
        case .noHistoryMessage:
            return getNoHistoryMessageText()
        case .searchInHistory:
            return getSearchInHistoryText()
        case .allPlatforms:
            return getAllPlatformsText()
        case .clearHistory:
            return getClearHistoryText()
        case .clearAll:
            return getClearAllText()
        case .searchHistory_placeholder:
            return getSearchHistoryPlaceholderText()
            
        // Data Management & Export
        case .dataManagement:
            return getDataManagementText()
        case .dataRetentionPeriod:
            return getDataRetentionPeriodText()
        case .retentionDescription:
            return getRetentionDescriptionText()
        case .platformOrder:
            return getPlatformOrderText()
        case .autoSortedByUsage:
            return getAutoSortedByUsageText()
        case .exportData:
            return getExportDataText()
        case .exportDataDescription:
            return getExportDataDescriptionText()
        case .clearAllData:
            return getClearAllDataText()
        case .clearAllDataDescription:
            return getClearAllDataDescriptionText()
        case .sevenDays:
            return getSevenDaysText()
        case .thirtyDays:
            return getThirtyDaysText()
        case .forever:
            return getForeverText()
            
        // Statistics & Analytics
        case .statistics:
            return getStatisticsText()
        case .searchTrend:
            return getSearchTrendText()
        case .timeOfDayAnalysis:
            return getTimeOfDayAnalysisText()
        case .platformUsageStats:
            return getPlatformUsageStatsText()
        case .morningTime:
            return getMorningTimeText()
        case .afternoonTime:
            return getAfternoonTimeText()
        case .eveningTime:
            return getEveningTimeText()
        case .youSearchMostOften:
            return getYouSearchMostOftenText()
        case .searchesCount:
            return getSearchesCountText()
        case .exportYourData:
            return getExportYourDataText()
        case .exportSearchHistory:
            return getExportSearchHistoryText()
        case .timePeriod:
            return getTimePeriodText()
        case .sinceFirstUse:
            return getSinceFirstUseText()
        case .allTime:
            return getAllTimeText()
        case .lastSevenDays:
            return getLastSevenDaysText()
        case .lastThirtyDays:
            return getLastThirtyDaysText()
        case .exportFormat:
            return getExportFormatText()
        case .timeRange:
            return getTimeRangeText()
        case .exportContent:
            return getExportContentText()
        case .searchQueries:
            return getSearchQueriesText()
        case .searchQueriesDescription:
            return getSearchQueriesDescriptionText()
        case .platformUsageDescription:
            return getPlatformUsageDescriptionText()
        case .usageStatistics:
            return getUsageStatisticsText()
        case .usageStatisticsDescription:
            return getUsageStatisticsDescriptionText()
        case .exportingData:
            return getExportingDataText()
        case .exportDataButton:
            return getExportDataButtonText()
        case .noDataAvailable:
            return getNoDataAvailableText()
            
        // Time saved and insights
        case .vsEndlessScrolling:
            return getVsEndlessScrollingText()
        case .stayingFocusedExclamation:
            return getStayingFocusedExclamationText()
        case .timeSavedFromDistractions_detailed:
            return getTimeSavedFromDistractionsDetailedText()
        case .highEfficiency:
            return getHighEfficiencyText()
        case .focusScorePercent:
            return getFocusScorePercentText()
        case .todaysImpactTime:
            return getTodaysImpactTimeText()
        }
    }
    
    // MARK: - Private Localization Methods
    
    private func getSearchText() -> String {
        switch currentLanguage {
        case "es": return "Buscar"
        case "fr": return "Rechercher"
        case "de": return "Suchen"
        case "it": return "Cerca"
        case "pt": return "Pesquisar"
        case "ru": return "Поиск"
        case "ja": return "検索"
        case "ko": return "검색"
        case "zh": return "搜索"
        case "ar": return "بحث"
        default: return "Search"
        }
    }
    
    private func getSearchPlaceholder() -> String {
        switch currentLanguage {
        case "es": return "Buscar contenido..."
        case "fr": return "Rechercher du contenu..."
        case "de": return "Inhalte suchen..."
        case "it": return "Cerca contenuti..."
        case "pt": return "Pesquisar conteúdo..."
        case "ru": return "Поиск контента..."
        case "ja": return "コンテンツを検索..."
        case "ko": return "콘텐츠 검색..."
        case "zh": return "搜索内容..."
        case "ar": return "البحث عن المحتوى..."
        default: return "Search content..."
        }
    }
    
    private func getSettingsText() -> String {
        switch currentLanguage {
        case "es": return "Configuración"
        case "fr": return "Paramètres"
        case "de": return "Einstellungen"
        case "it": return "Impostazioni"
        case "pt": return "Configurações"
        case "ru": return "Настройки"
        case "ja": return "設定"
        case "ko": return "설정"
        case "zh": return "设置"
        case "ar": return "الإعدادات"
        default: return "Settings"
        }
    }
    
    private func getPremiumText() -> String {
        switch currentLanguage {
        case "es": return "Premium"
        case "fr": return "Premium"
        case "de": return "Premium"
        case "it": return "Premium"
        case "pt": return "Premium"
        case "ru": return "Премиум"
        case "ja": return "プレミアム"
        case "ko": return "프리미엄"
        case "zh": return "高级版"
        case "ar": return "المميز"
        default: return "Premium"
        }
    }
    
    private func getDataText() -> String {
        switch currentLanguage {
        case "es": return "Datos"
        case "fr": return "Données"
        case "de": return "Daten"
        case "it": return "Dati"
        case "pt": return "Dados"
        case "ru": return "Данные"
        case "ja": return "データ"
        case "ko": return "데이터"
        case "zh": return "数据"
        case "ar": return "البيانات"
        default: return "Data"
        }
    }

    private func getChoosePlatformText() -> String {
        switch currentLanguage {
        case "es": return "Elegir Plataforma"
        case "fr": return "Choisir la Plateforme"
        case "de": return "Plattform Wählen"
        case "it": return "Scegli Piattaforma"
        case "pt": return "Escolher Plataforma"
        case "ru": return "Выбрать Платформу"
        case "ja": return "プラットフォームを選択"
        case "ko": return "플랫폼 선택"
        case "zh": return "选择平台"
        case "ar": return "اختر المنصة"
        default: return "Choose Platform"
        }
    }

    private func getRecentSearchesText() -> String {
        switch currentLanguage {
        case "es": return "Búsquedas Recientes"
        case "fr": return "Recherches Récentes"
        case "de": return "Letzte Suchen"
        case "it": return "Ricerche Recenti"
        case "pt": return "Pesquisas Recentes"
        case "ru": return "Недавние Поиски"
        case "ja": return "最近の検索"
        case "ko": return "최근 검색"
        case "zh": return "最近搜索"
        case "ar": return "عمليات البحث الأخيرة"
        default: return "Recent Searches"
        }
    }

    private func getClearText() -> String {
        switch currentLanguage {
        case "es": return "Limpiar"
        case "fr": return "Effacer"
        case "de": return "Löschen"
        case "it": return "Cancella"
        case "pt": return "Limpar"
        case "ru": return "Очистить"
        case "ja": return "クリア"
        case "ko": return "지우기"
        case "zh": return "清除"
        case "ar": return "مسح"
        default: return "Clear"
        }
    }

    private func getSearchOnText() -> String {
        switch currentLanguage {
        case "es": return "Buscar en"
        case "fr": return "Rechercher sur"
        case "de": return "Suchen auf"
        case "it": return "Cerca su"
        case "pt": return "Pesquisar no"
        case "ru": return "Искать в"
        case "ja": return "で検索"
        case "ko": return "에서 검색"
        case "zh": return "在...搜索"
        default: return "Search on"
        }
    }

    private func getOpenInText() -> String {
        switch currentLanguage {
        case "es": return "Abrir en"
        case "fr": return "Ouvrir dans"
        case "de": return "Öffnen in"
        case "it": return "Apri in"
        case "pt": return "Abrir no"
        case "ru": return "Открыть в"
        case "ja": return "で開く"
        case "ko": return "에서 열기"
        case "zh": return "在...打开"
        default: return "Open in"
        }
    }

    private func getOpenTikTokSearchText() -> String {
        switch currentLanguage {
        case "es": return "Abrir Búsqueda de TikTok"
        case "fr": return "Ouvrir la Recherche TikTok"
        case "de": return "TikTok-Suche Öffnen"
        case "it": return "Apri Ricerca TikTok"
        case "pt": return "Abrir Pesquisa do TikTok"
        case "ru": return "Открыть Поиск TikTok"
        case "ja": return "TikTok検索を開く"
        case "ko": return "TikTok 검색 열기"
        case "zh": return "打开TikTok搜索"
        default: return "Open TikTok Search"
        }
    }
    
    private func getTotalSearchesText() -> String {
        switch currentLanguage {
        case "es": return "Total"
        case "fr": return "Total"
        case "de": return "Gesamt"
        case "it": return "Totale"
        case "pt": return "Total"
        case "ru": return "Всего"
        case "ja": return "合計"
        case "ko": return "총계"
        case "zh": return "总计"
        default: return "Total"
        }
    }
    
    private func getTodayText() -> String {
        switch currentLanguage {
        case "es": return "Hoy"
        case "fr": return "Aujourd'hui"
        case "de": return "Heute"
        case "it": return "Oggi"
        case "pt": return "Hoje"
        case "ru": return "Сегодня"
        case "ja": return "今日"
        case "ko": return "오늘"
        case "zh": return "今天"
        case "ar": return "اليوم"
        default: return "Today"
        }
    }
    
    private func getTimeSavedText() -> String {
        switch currentLanguage {
        case "es": return "Tiempo Ahorrado"
        case "fr": return "Temps Économisé"
        case "de": return "Zeit Gespart"
        case "it": return "Tempo Risparmiato"
        case "pt": return "Tempo Economizado"
        case "ru": return "Сэкономленное Время"
        case "ja": return "節約した時間"
        case "ko": return "절약된 시간"
        case "zh": return "节省时间"
        case "ar": return "الوقت المُوفر"
        default: return "Time Saved"
        }
    }
    
    private func getPlatformUsageText() -> String {
        switch currentLanguage {
        case "es": return "Uso de Plataformas"
        case "fr": return "Utilisation des Plateformes"
        case "de": return "Plattform-Nutzung"
        case "it": return "Utilizzo Piattaforme"
        case "pt": return "Uso de Plataformas"
        case "ru": return "Использование Платформ"
        case "ja": return "プラットフォーム使用状況"
        case "ko": return "플랫폼 사용량"
        case "zh": return "平台使用情况"
        case "ar": return "استخدام المنصات"
        default: return "Platform Usage"
        }
    }
    
    private func getSearchHistoryText() -> String {
        switch currentLanguage {
        case "es": return "Historial de Búsqueda"
        case "fr": return "Historique de Recherche"
        case "de": return "Suchverlauf"
        case "it": return "Cronologia Ricerche"
        case "pt": return "Histórico de Pesquisa"
        case "ru": return "История Поиска"
        case "ja": return "検索履歴"
        case "ko": return "검색 기록"
        case "zh": return "搜索历史"
        case "ar": return "تاريخ البحث"
        default: return "Search History"
        }
    }
    
    private func getStatsText() -> String {
        switch currentLanguage {
        case "es": return "Estadísticas"
        case "fr": return "Statistiques"
        case "de": return "Statistiken"
        case "it": return "Statistiche"
        case "pt": return "Estatísticas"
        case "ru": return "Статистика"
        case "ja": return "統計"
        case "ko": return "통계"
        case "zh": return "统计"
        case "ar": return "الإحصائيات"
        default: return "Stats"
        }
    }
    
    private func getHistoryText() -> String {
        switch currentLanguage {
        case "es": return "Historial"
        case "fr": return "Historique"
        case "de": return "Verlauf"
        case "it": return "Cronologia"
        case "pt": return "Histórico"
        case "ru": return "История"
        case "ja": return "履歴"
        case "ko": return "기록"
        case "zh": return "历史"
        case "ar": return "التاريخ"
        default: return "History"
        }
    }

    private func getDailyLimitText() -> String {
        switch currentLanguage {
        case "es": return "Límite Diario"
        case "fr": return "Limite Quotidienne"
        case "de": return "Tägliches Limit"
        case "it": return "Limite Giornaliero"
        case "pt": return "Limite Diário"
        case "ru": return "Дневной Лимит"
        case "ja": return "日次制限"
        case "ko": return "일일 제한"
        case "zh": return "每日限制"
        default: return "Daily Limit"
        }
    }

    private func getInsightsText() -> String {
        switch currentLanguage {
        case "es": return "Perspectivas"
        case "fr": return "Aperçus"
        case "de": return "Einblicke"
        case "it": return "Approfondimenti"
        case "pt": return "Insights"
        case "ru": return "Аналитика"
        case "ja": return "インサイト"
        case "ko": return "인사이트"
        case "zh": return "洞察"
        case "ar": return "الرؤى"
        default: return "Insights"
        }
    }

    private func getFocusScoreText() -> String {
        switch currentLanguage {
        case "es": return "Puntuación de Enfoque"
        case "fr": return "Score de Concentration"
        case "de": return "Fokus-Bewertung"
        case "it": return "Punteggio di Concentrazione"
        case "pt": return "Pontuação de Foco"
        case "ru": return "Оценка Фокуса"
        case "ja": return "フォーカススコア"
        case "ko": return "집중 점수"
        case "zh": return "专注评分"
        case "ar": return "نقاط التركيز"
        default: return "Focus Score"
        }
    }

    private func getStayingFocusedText() -> String {
        switch currentLanguage {
        case "es": return "¡Te mantienes enfocado!"
        case "fr": return "Vous restez concentré !"
        case "de": return "Du bleibst fokussiert!"
        case "it": return "Rimani concentrato!"
        case "pt": return "Você está mantendo o foco!"
        case "ru": return "Вы остаетесь сосредоточенными!"
        case "ja": return "集中を保っています！"
        case "ko": return "집중을 유지하고 있습니다!"
        case "zh": return "你保持专注！"
        case "ar": return "أنت تحافظ على التركيز!"
        default: return "You're staying focused!"
        }
    }

    private func getTodaysImpactText() -> String {
        switch currentLanguage {
        case "es": return "Impacto de Hoy"
        case "fr": return "Impact d'Aujourd'hui"
        case "de": return "Heutiger Einfluss"
        case "it": return "Impatto di Oggi"
        case "pt": return "Impacto de Hoje"
        case "ru": return "Сегодняшнее Влияние"
        case "ja": return "今日の影響"
        case "ko": return "오늘의 영향"
        case "zh": return "今日影响"
        case "ar": return "تأثير اليوم"
        default: return "Today's Impact"
        }
    }

    private func getTimeSavedFromDistractionsText() -> String {
        switch currentLanguage {
        case "es": return "Tiempo ahorrado de distracciones"
        case "fr": return "Temps économisé des distractions"
        case "de": return "Zeit vor Ablenkungen gespart"
        case "it": return "Tempo risparmiato dalle distrazioni"
        case "pt": return "Tempo poupado de distrações"
        case "ru": return "Время, сэкономленное от отвлечений"
        case "ja": return "気を散らすことから節約された時間"
        case "ko": return "방해 요소로부터 절약된 시간"
        case "zh": return "从干扰中节省的时间"
        case "ar": return "الوقت المُوفر من المشتتات"
        default: return "Time saved from distractions"
        }
    }

    private func getEfficiencyText() -> String {
        switch currentLanguage {
        case "es": return "Eficiencia"
        case "fr": return "Efficacité"
        case "de": return "Effizienz"
        case "it": return "Efficienza"
        case "pt": return "Eficiência"
        case "ru": return "Эффективность"
        case "ja": return "効率性"
        case "ko": return "효율성"
        case "zh": return "效率"
        case "ar": return "الكفاءة"
        default: return "Efficiency"
        }
    }

    private func getDirectSearchesSaveTimeText() -> String {
        switch currentLanguage {
        case "es": return "Las búsquedas directas ahorran tiempo"
        case "fr": return "Les recherches directes font gagner du temps"
        case "de": return "Direkte Suchen sparen Zeit"
        case "it": return "Le ricerche dirette fanno risparmiare tempo"
        case "pt": return "Pesquisas diretas economizam tempo"
        case "ru": return "Прямые поиски экономят время"
        case "ja": return "直接検索は時間を節約します"
        case "ko": return "직접 검색으로 시간을 절약합니다"
        case "zh": return "直接搜索节省时间"
        case "ar": return "البحث المباشر يوفر الوقت"
        default: return "Direct searches save time"
        }
    }

    private func getSearchesText() -> String {
        switch currentLanguage {
        case "es": return "búsquedas"
        case "fr": return "recherches"
        case "de": return "Suchen"
        case "it": return "ricerche"
        case "pt": return "pesquisas"
        case "ru": return "поисков"
        case "ja": return "検索"
        case "ko": return "검색"
        case "zh": return "搜索"
        case "ar": return "عمليات بحث"
        default: return "searches"
        }
    }

    private func getLeftText() -> String {
        switch currentLanguage {
        case "es": return "restantes"
        case "fr": return "restantes"
        case "de": return "übrig"
        case "it": return "rimanenti"
        case "pt": return "restantes"
        case "ru": return "осталось"
        case "ja": return "残り"
        case "ko": return "남음"
        case "zh": return "剩余"
        case "ar": return "متبقية"
        default: return "left"
        }
    }

    private func getOfText() -> String {
        switch currentLanguage {
        case "es": return "de"
        case "fr": return "de"
        case "de": return "von"
        case "it": return "di"
        case "pt": return "de"
        case "ru": return "из"
        case "ja": return "の"
        case "ko": return "중"
        case "zh": return "的"
        case "ar": return "من"
        default: return "of"
        }
    }

    private func getTrialText() -> String {
        switch currentLanguage {
        case "es": return "Prueba"
        case "fr": return "Essai"
        case "de": return "Testversion"
        case "it": return "Prova"
        case "pt": return "Teste"
        case "ru": return "Пробная версия"
        case "ja": return "トライアル"
        case "ko": return "체험"
        case "zh": return "试用"
        default: return "Trial"
        }
    }
    
    private func getLanguageText() -> String {
        switch currentLanguage {
        case "es": return "Idioma"
        case "fr": return "Langue"
        case "de": return "Sprache"
        case "it": return "Lingua"
        case "pt": return "Idioma"
        case "ru": return "Язык"
        case "ja": return "言語"
        case "ko": return "언어"
        case "zh": return "语言"
        case "ar": return "اللغة"
        default: return "Language"
        }
    }
    
    private func getAutoDetectText() -> String {
        switch currentLanguage {
        case "es": return "Detección Automática"
        case "fr": return "Détection Automatique"
        case "de": return "Automatische Erkennung"
        case "it": return "Rilevamento Automatico"
        case "pt": return "Detecção Automática"
        case "ru": return "Автоопределение"
        case "ja": return "自動検出"
        case "ko": return "자동 감지"
        case "zh": return "自动检测"
        case "ar": return "الكشف التلقائي"
        default: return "Auto-detect"
        }
    }
    
    private func getAutoDetectSubtitleText() -> String {
        switch currentLanguage {
        case "es": return "Usar configuración del dispositivo"
        case "fr": return "Utiliser les paramètres de l'appareil"
        case "de": return "Geräteeinstellungen verwenden"
        case "it": return "Usa impostazioni dispositivo"
        case "pt": return "Usar configurações do dispositivo"
        case "ru": return "Использовать настройки устройства"
        case "ja": return "デバイス設定を使用"
        case "ko": return "기기 설정 사용"
        case "zh": return "使用设备设置"
        default: return "Use device language settings"
        }
    }
    
    private func getSearchModeText() -> String {
        switch currentLanguage {
        case "es": return "Modo de Búsqueda"
        case "fr": return "Mode de Recherche"
        case "de": return "Suchmodus"
        case "it": return "Modalità Ricerca"
        case "pt": return "Modo de Pesquisa"
        case "ru": return "Режим Поиска"
        case "ja": return "検索モード"
        case "ko": return "검색 모드"
        case "zh": return "搜索模式"
        default: return "Search Mode"
        }
    }
    
    private func getDirectSearchText() -> String {
        switch currentLanguage {
        case "es": return "Búsqueda Directa"
        case "fr": return "Recherche Directe"
        case "de": return "Direkte Suche"
        case "it": return "Ricerca Diretta"
        case "pt": return "Pesquisa Direta"
        case "ru": return "Прямой Поиск"
        case "ja": return "ダイレクト検索"
        case "ko": return "직접 검색"
        case "zh": return "直接搜索"
        default: return "Direct Search"
        }
    }
    
    // Do Not Disturb functionality removed
    
    private func getDoneText() -> String {
        switch currentLanguage {
        case "es": return "Listo"
        case "fr": return "Terminé"
        case "de": return "Fertig"
        case "it": return "Fatto"
        case "pt": return "Concluído"
        case "ru": return "Готово"
        case "ja": return "完了"
        case "ko": return "완료"
        case "zh": return "完成"
        case "ar": return "تم"
        default: return "Done"
        }
    }
    
    private func getSelectLanguageText() -> String {
        switch currentLanguage {
        case "es": return "Seleccionar Idioma"
        case "fr": return "Sélectionner la Langue"
        case "de": return "Sprache Auswählen"
        case "it": return "Seleziona Lingua"
        case "pt": return "Selecionar Idioma"
        case "ru": return "Выбрать Язык"
        case "ja": return "言語を選択"
        case "ko": return "언어 선택"
        case "zh": return "选择语言"
        case "ar": return "اختر اللغة"
        default: return "Select Language"
        }
    }

    private func getSearchPreferencesText() -> String {
        switch currentLanguage {
        case "es": return "Preferencias de Búsqueda"
        case "fr": return "Préférences de Recherche"
        case "de": return "Sucheinstellungen"
        case "it": return "Preferenze di Ricerca"
        case "pt": return "Preferências de Pesquisa"
        case "ru": return "Настройки Поиска"
        case "ja": return "検索設定"
        case "ko": return "검색 설정"
        case "zh": return "搜索偏好"
        default: return "Search Preferences"
        }
    }

    private func getPreferencesText() -> String {
        switch currentLanguage {
        case "es": return "Preferencias"
        case "fr": return "Préférences"
        case "de": return "Einstellungen"
        case "it": return "Preferenze"
        case "pt": return "Preferências"
        case "ru": return "Настройки"
        case "ja": return "設定"
        case "ko": return "설정"
        case "zh": return "偏好设置"
        case "ar": return "التفضيلات"
        default: return "Preferences"
        }
    }

    private func getPremiumFeaturesText() -> String {
        switch currentLanguage {
        case "es": return "Funciones Premium"
        case "fr": return "Fonctionnalités Premium"
        case "de": return "Premium-Funktionen"
        case "it": return "Funzionalità Premium"
        case "pt": return "Recursos Premium"
        case "ru": return "Премиум Функции"
        case "ja": return "プレミアム機能"
        case "ko": return "프리미엄 기능"
        case "zh": return "高级功能"
        default: return "Premium Features"
        }
    }

    private func getUsageAndDataText() -> String {
        switch currentLanguage {
        case "es": return "Uso y Datos"
        case "fr": return "Utilisation et Données"
        case "de": return "Nutzung und Daten"
        case "it": return "Utilizzo e Dati"
        case "pt": return "Uso e Dados"
        case "ru": return "Использование и Данные"
        case "ja": return "使用状況とデータ"
        case "ko": return "사용량 및 데이터"
        case "zh": return "使用情况和数据"
        default: return "Usage & Data"
        }
    }

    private func getFreeTrialActiveText() -> String {
        switch currentLanguage {
        case "es": return "Prueba Gratuita Activa"
        case "fr": return "Essai Gratuit Actif"
        case "de": return "Kostenlose Testversion Aktiv"
        case "it": return "Prova Gratuita Attiva"
        case "pt": return "Teste Gratuito Ativo"
        case "ru": return "Бесплатная Пробная Версия Активна"
        case "ja": return "無料トライアル有効"
        case "ko": return "무료 체험 활성"
        case "zh": return "免费试用激活"
        default: return "Free Trial Active"
        }
    }

    private func getDaysRemainingText() -> String {
        switch currentLanguage {
        case "es": return "días restantes"
        case "fr": return "jours restants"
        case "de": return "Tage verbleibend"
        case "it": return "giorni rimanenti"
        case "pt": return "dias restantes"
        case "ru": return "дней осталось"
        case "ja": return "日残り"
        case "ko": return "일 남음"
        case "zh": return "天剩余"
        default: return "days remaining"
        }
    }

    private func getClearRecentSearchesText() -> String {
        switch currentLanguage {
        case "es": return "Limpiar Búsquedas Recientes"
        case "fr": return "Effacer les Recherches Récentes"
        case "de": return "Letzte Suchen Löschen"
        case "it": return "Cancella Ricerche Recenti"
        case "pt": return "Limpar Pesquisas Recentes"
        case "ru": return "Очистить Недавние Поиски"
        case "ja": return "最近の検索をクリア"
        case "ko": return "최근 검색 지우기"
        case "zh": return "清除最近搜索"
        default: return "Clear Recent Searches"
        }
    }

    private func getSearchModeDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "Búsqueda Directa"
        case "fr": return "Recherche Directe"
        case "de": return "Direkte Suche"
        case "it": return "Ricerca Diretta"
        case "pt": return "Pesquisa Direta"
        case "ru": return "Прямой Поиск"
        case "ja": return "直接検索"
        case "ko": return "직접 검색"
        case "zh": return "直接搜索"
        default: return "Direct Search"
        }
    }

    // Auto Do Not Disturb functionality removed

    // AI Summarization description function removed

    private func getDailySearchLimitDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "45 búsquedas por día"
        case "fr": return "45 recherches par jour"
        case "de": return "45 Suchen pro Tag"
        case "it": return "45 ricerche al giorno"
        case "pt": return "45 pesquisas por dia"
        case "ru": return "45 поисков в день"
        case "ja": return "1日45回検索"
        case "ko": return "하루 45회 검색"
        case "zh": return "每天45次搜索"
        default: return "45 searches per day"
        }
    }

    // Auto Do Not Disturb functionality removed

    // AI Summarization text function removed

    private func getCreditsLeftText() -> String {
        switch currentLanguage {
        case "es": return "créditos restantes"
        case "fr": return "crédits restants"
        case "de": return "Credits übrig"
        case "it": return "crediti rimanenti"
        case "pt": return "créditos restantes"
        case "ru": return "кредитов осталось"
        case "ja": return "クレジット残り"
        case "ko": return "크레딧 남음"
        case "zh": return "积分剩余"
        default: return "credits left"
        }
    }

    private func getSearchesPerDayText() -> String {
        switch currentLanguage {
        case "es": return "búsquedas por día"
        case "fr": return "recherches par jour"
        case "de": return "Suchen pro Tag"
        case "it": return "ricerche al giorno"
        case "pt": return "pesquisas por dia"
        case "ru": return "поисков в день"
        case "ja": return "検索/日"
        case "ko": return "검색/일"
        case "zh": return "搜索/天"
        default: return "searches per day"
        }
    }

    private func getAboutAndSupportText() -> String {
        switch currentLanguage {
        case "es": return "Acerca de y Soporte"
        case "fr": return "À Propos et Support"
        case "de": return "Über und Support"
        case "it": return "Informazioni e Supporto"
        case "pt": return "Sobre e Suporte"
        case "ru": return "О Приложении и Поддержка"
        case "ja": return "アプリについて・サポート"
        case "ko": return "앱 정보 및 지원"
        case "zh": return "关于与支持"
        case "ar": return "حول التطبيق والدعم"
        default: return "About & Support"
        }
    }

    private func getVersionText() -> String {
        switch currentLanguage {
        case "es": return "Versión"
        case "fr": return "Version"
        case "de": return "Version"
        case "it": return "Versione"
        case "pt": return "Versão"
        case "ru": return "Версия"
        case "ja": return "バージョン"
        case "ko": return "버전"
        case "zh": return "版本"
        case "ar": return "الإصدار"
        default: return "Version"
        }
    }

    private func getPrivacyPolicyText() -> String {
        switch currentLanguage {
        case "es": return "Política de Privacidad"
        case "fr": return "Politique de Confidentialité"
        case "de": return "Datenschutzrichtlinie"
        case "it": return "Informativa sulla Privacy"
        case "pt": return "Política de Privacidade"
        case "ru": return "Политика Конфиденциальности"
        case "ja": return "プライバシーポリシー"
        case "ko": return "개인정보 처리방침"
        case "zh": return "隐私政策"
        case "ar": return "سياسة الخصوصية"
        default: return "Privacy Policy"
        }
    }

    private func getTermsOfServiceText() -> String {
        switch currentLanguage {
        case "es": return "Términos de Servicio"
        case "fr": return "Conditions d'Utilisation"
        case "de": return "Nutzungsbedingungen"
        case "it": return "Termini di Servizio"
        case "pt": return "Termos de Serviço"
        case "ru": return "Условия Использования"
        case "ja": return "利用規約"
        case "ko": return "서비스 약관"
        case "zh": return "服务条款"
        case "ar": return "شروط الخدمة"
        default: return "Terms of Service"
        }
    }

    private func getSupportAndFAQText() -> String {
        switch currentLanguage {
        case "es": return "Soporte y FAQ"
        case "fr": return "Support et FAQ"
        case "de": return "Support und FAQ"
        case "it": return "Supporto e FAQ"
        case "pt": return "Suporte e FAQ"
        case "ru": return "Поддержка и FAQ"
        case "ja": return "サポート・FAQ"
        case "ko": return "지원 및 FAQ"
        case "zh": return "支持与常见问题"
        case "ar": return "الدعم والأسئلة الشائعة"
        default: return "Support & FAQ"
        }
    }

    private func getContactUsText() -> String {
        switch currentLanguage {
        case "es": return "Contáctanos"
        case "fr": return "Nous Contacter"
        case "de": return "Kontakt"
        case "it": return "Contattaci"
        case "pt": return "Entre em Contato"
        case "ru": return "Связаться с Нами"
        case "ja": return "お問い合わせ"
        case "ko": return "문의하기"
        case "zh": return "联系我们"
        case "ar": return "اتصل بنا"
        default: return "Contact Us"
        }
    }
    
    private func getUpgradeToUnlockText() -> String {
        switch currentLanguage {
        case "es": return "Actualizar para Desbloquear"
        case "fr": return "Mettre à Niveau pour Débloquer"
        case "de": return "Upgrade zum Freischalten"
        case "it": return "Aggiorna per Sbloccare"
        case "pt": return "Atualizar para Desbloquear"
        case "ru": return "Обновить для Разблокировки"
        case "ja": return "アップグレードしてロック解除"
        case "ko": return "업그레이드하여 잠금 해제"
        case "zh": return "升级解锁"
        default: return "Upgrade to Unlock"
        }
    }
    
    private func getFreeTrialText() -> String {
        switch currentLanguage {
        case "es": return "Prueba Gratuita"
        case "fr": return "Essai Gratuit"
        case "de": return "Kostenlose Testversion"
        case "it": return "Prova Gratuita"
        case "pt": return "Teste Gratuito"
        case "ru": return "Бесплатная Пробная Версия"
        case "ja": return "無料トライアル"
        case "ko": return "무료 체험"
        case "zh": return "免费试用"
        default: return "Free Trial"
        }
    }
    
    private func getStartFreeTrialText() -> String {
        switch currentLanguage {
        case "es": return "Iniciar Prueba Gratuita"
        case "fr": return "Commencer l'Essai Gratuit"
        case "de": return "Kostenlose Testversion Starten"
        case "it": return "Inizia Prova Gratuita"
        case "pt": return "Iniciar Teste Gratuito"
        case "ru": return "Начать Бесплатную Пробную Версию"
        case "ja": return "無料トライアルを開始"
        case "ko": return "무료 체험 시작"
        case "zh": return "开始免费试用"
        default: return "Start Free Trial"
        }
    }
    
    private func getRestorePurchasesText() -> String {
        switch currentLanguage {
        case "es": return "Restaurar Compras"
        case "fr": return "Restaurer les Achats"
        case "de": return "Käufe Wiederherstellen"
        case "it": return "Ripristina Acquisti"
        case "pt": return "Restaurar Compras"
        case "ru": return "Восстановить Покупки"
        case "ja": return "購入を復元"
        case "ko": return "구매 복원"
        case "zh": return "恢复购买"
        default: return "Restore Purchases"
        }
    }
    
    private func getNoHistoryText() -> String {
        switch currentLanguage {
        case "es": return "Sin Historial"
        case "fr": return "Aucun Historique"
        case "de": return "Kein Verlauf"
        case "it": return "Nessuna Cronologia"
        case "pt": return "Sem Histórico"
        case "ru": return "Нет Истории"
        case "ja": return "履歴なし"
        case "ko": return "기록 없음"
        case "zh": return "无历史记录"
        case "ar": return "لا يوجد تاريخ"
        default: return "No History"
        }
    }
    
    private func getNoHistoryMessageText() -> String {
        switch currentLanguage {
        case "es": return "Tus búsquedas aparecerán aquí"
        case "fr": return "Vos recherches apparaîtront ici"
        case "de": return "Ihre Suchen werden hier angezeigt"
        case "it": return "Le tue ricerche appariranno qui"
        case "pt": return "Suas pesquisas aparecerão aqui"
        case "ru": return "Ваши поиски появятся здесь"
        case "ja": return "検索履歴がここに表示されます"
        case "ko": return "검색 기록이 여기에 표시됩니다"
        case "zh": return "您的搜索记录将显示在这里"
        case "ar": return "ستظهر عمليات البحث الخاصة بك هنا"
        default: return "Your searches will appear here"
        }
    }
    
    private func getSearchInHistoryText() -> String {
        switch currentLanguage {
        case "es": return "Buscar en historial..."
        case "fr": return "Rechercher dans l'historique..."
        case "de": return "Im Verlauf suchen..."
        case "it": return "Cerca nella cronologia..."
        case "pt": return "Pesquisar no histórico..."
        case "ru": return "Поиск в истории..."
        case "ja": return "履歴を検索..."
        case "ko": return "기록에서 검색..."
        case "zh": return "在历史记录中搜索..."
        case "ar": return "البحث في التاريخ..."
        default: return "Search in history..."
        }
    }
    
    private func getAllPlatformsText() -> String {
        switch currentLanguage {
        case "es": return "Todas las Plataformas"
        case "fr": return "Toutes les Plateformes"
        case "de": return "Alle Plattformen"
        case "it": return "Tutte le Piattaforme"
        case "pt": return "Todas as Plataformas"
        case "ru": return "Все Платформы"
        case "ja": return "すべてのプラットフォーム"
        case "ko": return "모든 플랫폼"
        case "zh": return "所有平台"
        case "ar": return "جميع المنصات"
        default: return "All Platforms"
        }
    }
    
    private func getClearHistoryText() -> String {
        switch currentLanguage {
        case "es": return "Borrar Historial"
        case "fr": return "Effacer l'Historique"
        case "de": return "Verlauf Löschen"
        case "it": return "Cancella Cronologia"
        case "pt": return "Limpar Histórico"
        case "ru": return "Очистить Историю"
        case "ja": return "履歴をクリア"
        case "ko": return "기록 지우기"
        case "zh": return "清除历史"
        case "ar": return "مسح التاريخ"
        default: return "Clear History"
        }
    }
}

// MARK: - Localized String Keys
enum LocalizedStringKey {
    // Main UI
    case search, searchPlaceholder, settings, premium, data, choosePlatform, recentSearches, clear
    case searchOn, openIn, openTikTokSearch, direct, inApp

    // Stats
    case totalSearches, today, timeSaved, platformUsage, searchHistory, stats, history
    case dailyLimit, insights, focusScore, stayingFocused, todaysImpact, timeSavedFromDistractions
    case efficiency, directSearchesSaveTime, searches, left, of, trial

    // Settings
    case language, autoDetect, autoDetectSubtitle, searchMode, directSearch, done, selectLanguage
    case searchPreferences, preferences, premiumFeatures, usageAndData, freeTrialActive, daysRemaining, clearRecentSearches
    case searchModeDescription, dailySearchLimitDescription
    case creditsLeft, searchesPerDay

    // About & Support
    case aboutAndSupport, version, privacyPolicy, termsOfService, supportAndFAQ, contactUs

    // Premium
    case upgradeToUnlock, freeTrial, startFreeTrial, restorePurchases

    // Search History
    case noHistory, noHistoryMessage, searchInHistory, allPlatforms, clearHistory, clearAll, searchHistory_placeholder
    
    // Data Management & Export
    case dataManagement, dataRetentionPeriod, retentionDescription, platformOrder, autoSortedByUsage
    case exportData, exportDataDescription, clearAllData, clearAllDataDescription
    case sevenDays, thirtyDays, forever
    
    // Statistics & Analytics
    case statistics, searchTrend, timeOfDayAnalysis, platformUsageStats
    case morningTime, afternoonTime, eveningTime
    case youSearchMostOften, searchesCount
    case exportYourData, exportSearchHistory, timePeriod, sinceFirstUse
    case allTime, lastSevenDays, lastThirtyDays
    case exportFormat, timeRange, exportContent, searchQueries, searchQueriesDescription
    case platformUsageDescription, usageStatistics, usageStatisticsDescription
    case exportingData, exportDataButton, noDataAvailable
    
    // Time saved and insights
    case vsEndlessScrolling, stayingFocusedExclamation, timeSavedFromDistractions_detailed
    case highEfficiency, focusScorePercent, todaysImpactTime
}

// MARK: - LocalizationManager Extensions

extension LocalizationManager {
    // MARK: - Formatting Methods

    func formatSearchCount(_ count: Int) -> String {
        return "\(count) \(getSearchesText())"
    }

    func formatTrialText(_ daysLeft: Int) -> String {
        return "\(getTrialText()): \(daysLeft)d \(getLeftText())"
    }

    func formatLimitText(_ used: Int, _ total: Int) -> String {
        return "\(used) \(getOfText()) \(total)"
    }

    func formatRemainingText(_ remaining: Int) -> String {
        return "\(remaining) \(getLeftText())"
    }

    func formatRelativeTime(for date: Date) -> String {
        let timeInterval = Date().timeIntervalSince(date)
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60

        if hours > 0 {
            switch currentLanguage {
            case "es": return "\(hours)h hace"
            case "fr": return "il y a \(hours)h"
            case "de": return "vor \(hours)h"
            case "it": return "\(hours)h fa"
            case "pt": return "\(hours)h atrás"
            case "ru": return "\(hours)ч назад"
            case "ja": return "\(hours)時間前"
            case "ko": return "\(hours)시간 전"
            case "zh": return "\(hours)小时前"
            default: return "\(hours) hr ago"
            }
        } else if minutes > 0 {
            switch currentLanguage {
            case "es": return "\(minutes)m hace"
            case "fr": return "il y a \(minutes)m"
            case "de": return "vor \(minutes)m"
            case "it": return "\(minutes)m fa"
            case "pt": return "\(minutes)m atrás"
            case "ru": return "\(minutes)м назад"
            case "ja": return "\(minutes)分前"
            case "ko": return "\(minutes)분 전"
            case "zh": return "\(minutes)分钟前"
            default: return "\(minutes) min ago"
            }
        } else {
            switch currentLanguage {
            case "es": return "Ahora"
            case "fr": return "Maintenant"
            case "de": return "Jetzt"
            case "it": return "Ora"
            case "pt": return "Agora"
            case "ru": return "Сейчас"
            case "ja": return "今"
            case "ko": return "지금"
            case "zh": return "刚刚"
            default: return "Now"
            }
        }
    }

    // MARK: - New Methods for Missing Localizations

    private func getDirectText() -> String {
        switch currentLanguage {
        case "es": return "Directo"
        case "fr": return "Direct"
        case "de": return "Direkt"
        case "it": return "Diretto"
        case "pt": return "Direto"
        case "ru": return "Прямой"
        case "ja": return "ダイレクト"
        case "ko": return "직접"
        case "zh": return "直接"
        case "ar": return "مباشر"
        default: return "Direct"
        }
    }

    private func getInAppText() -> String {
        switch currentLanguage {
        case "es": return "En la App"
        case "fr": return "Dans l'App"
        case "de": return "In der App"
        case "it": return "Nell'App"
        case "pt": return "No App"
        case "ru": return "В приложении"
        case "ja": return "アプリ内"
        case "ko": return "앱 내"
        case "zh": return "应用内"
        case "ar": return "داخل التطبيق"
        default: return "In-App"
        }
    }

    private func getClearAllText() -> String {
        switch currentLanguage {
        case "es": return "Borrar Todo"
        case "fr": return "Tout Effacer"
        case "de": return "Alles Löschen"
        case "it": return "Cancella Tutto"
        case "pt": return "Limpar Tudo"
        case "ru": return "Очистить Всё"
        case "ja": return "すべてクリア"
        case "ko": return "모두 지우기"
        case "zh": return "全部清除"
        case "ar": return "مسح الكل"
        default: return "Clear All"
        }
    }

    private func getSearchHistoryPlaceholderText() -> String {
        switch currentLanguage {
        case "es": return "Buscar en historial..."
        case "fr": return "Rechercher dans l'historique..."
        case "de": return "Im Verlauf suchen..."
        case "it": return "Cerca nella cronologia..."
        case "pt": return "Pesquisar no histórico..."
        case "ru": return "Поиск в истории..."
        case "ja": return "履歴で検索..."
        case "ko": return "기록에서 검색..."
        case "zh": return "在历史记录中搜索..."
        case "ar": return "البحث في التاريخ..."
        default: return "Search history..."
        }
    }
    
    // MARK: - Data Management & Export Localizations
    
    private func getDataManagementText() -> String {
        switch currentLanguage {
        case "es": return "Gestión de Datos"
        case "fr": return "Gestion des Données"
        case "de": return "Datenverwaltung"
        case "it": return "Gestione Dati"
        case "pt": return "Gerenciamento de Dados"
        case "ru": return "Управление Данными"
        case "ja": return "データ管理"
        case "ko": return "데이터 관리"
        case "zh": return "数据管理"
        case "ar": return "إدارة البيانات"
        default: return "Data Management"
        }
    }
    
    private func getDataRetentionPeriodText() -> String {
        switch currentLanguage {
        case "es": return "Período de Retención de Datos"
        case "fr": return "Période de Rétention des Données"
        case "de": return "Datenaufbewahrungszeitraum"
        case "it": return "Periodo di Conservazione Dati"
        case "pt": return "Período de Retenção de Dados"
        case "ru": return "Период Хранения Данных"
        case "ja": return "データ保持期間"
        case "ko": return "데이터 보관 기간"
        case "zh": return "数据保留期限"
        case "ar": return "فترة الاحتفاظ بالبيانات"
        default: return "Data Retention Period"
        }
    }
    
    private func getRetentionDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "Cuánto tiempo mantener el historial de búsqueda"
        case "fr": return "Combien de temps conserver l'historique de recherche"
        case "de": return "Wie lange der Suchverlauf gespeichert werden soll"
        case "it": return "Quanto tempo mantenere la cronologia di ricerca"
        case "pt": return "Por quanto tempo manter o histórico de pesquisa"
        case "ru": return "Как долго хранить историю поиска"
        case "ja": return "検索履歴を保持する期間"
        case "ko": return "검색 기록을 보관할 기간"
        case "zh": return "保留搜索历史记录的时间"
        case "ar": return "مدة الاحتفاظ بتاريخ البحث"
        default: return "How long to keep search history"
        }
    }
    
    private func getPlatformOrderText() -> String {
        switch currentLanguage {
        case "es": return "Orden de Plataformas"
        case "fr": return "Ordre des Plateformes"
        case "de": return "Plattform-Reihenfolge"
        case "it": return "Ordine delle Piattaforme"
        case "pt": return "Ordem das Plataformas"
        case "ru": return "Порядок Платформ"
        case "ja": return "プラットフォーム順序"
        case "ko": return "플랫폼 순서"
        case "zh": return "平台顺序"
        case "ar": return "ترتيب المنصات"
        default: return "Platform Order"
        }
    }
    
    private func getAutoSortedByUsageText() -> String {
        switch currentLanguage {
        case "es": return "Ordenado automáticamente por frecuencia de uso"
        case "fr": return "Trié automatiquement par fréquence d'utilisation"
        case "de": return "Automatisch nach Nutzungshäufigkeit sortiert"
        case "it": return "Ordinato automaticamente per frequenza di utilizzo"
        case "pt": return "Ordenado automaticamente por frequência de uso"
        case "ru": return "Автоматически отсортировано по частоте использования"
        case "ja": return "使用頻度で自動ソート"
        case "ko": return "사용 빈도별 자동 정렬"
        case "zh": return "按使用频率自动排序"
        case "ar": return "مرتب تلقائياً حسب تكرار الاستخدام"
        default: return "Auto-sorted by usage frequency"
        }
    }
    
    private func getExportDataText() -> String {
        switch currentLanguage {
        case "es": return "Exportar Datos"
        case "fr": return "Exporter les Données"
        case "de": return "Daten Exportieren"
        case "it": return "Esporta Dati"
        case "pt": return "Exportar Dados"
        case "ru": return "Экспорт Данных"
        case "ja": return "データエクスポート"
        case "ko": return "데이터 내보내기"
        case "zh": return "导出数据"
        case "ar": return "تصدير البيانات"
        default: return "Export Data"
        }
    }
    
    private func getExportDataDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "Exportar historial de búsqueda y estadísticas"
        case "fr": return "Exporter l'historique de recherche et les statistiques"
        case "de": return "Suchverlauf und Statistiken exportieren"
        case "it": return "Esporta cronologia di ricerca e statistiche"
        case "pt": return "Exportar histórico de pesquisa e estatísticas"
        case "ru": return "Экспорт истории поиска и статистики"
        case "ja": return "検索履歴と統計をエクスポート"
        case "ko": return "검색 기록 및 통계 내보내기"
        case "zh": return "导出搜索历史和统计数据"
        case "ar": return "تصدير تاريخ البحث والإحصائيات"
        default: return "Export search history and statistics"
        }
    }
    
    private func getClearAllDataText() -> String {
        switch currentLanguage {
        case "es": return "Borrar Todos los Datos"
        case "fr": return "Effacer Toutes les Données"
        case "de": return "Alle Daten Löschen"
        case "it": return "Cancella Tutti i Dati"
        case "pt": return "Apagar Todos os Dados"
        case "ru": return "Очистить Все Данные"
        case "ja": return "全データを削除"
        case "ko": return "모든 데이터 지우기"
        case "zh": return "清除所有数据"
        case "ar": return "محو جميع البيانات"
        default: return "Clear All Data"
        }
    }
    
    private func getClearAllDataDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "Eliminar todo el historial de búsqueda y estadísticas"
        case "fr": return "Supprimer tout l'historique de recherche et les statistiques"
        case "de": return "Gesamten Suchverlauf und Statistiken löschen"
        case "it": return "Rimuovi tutta la cronologia di ricerca e le statistiche"
        case "pt": return "Remover todo o histórico de pesquisa e estatísticas"
        case "ru": return "Удалить всю историю поиска и статистику"
        case "ja": return "すべての検索履歴と統計を削除"
        case "ko": return "모든 검색 기록 및 통계 제거"
        case "zh": return "删除所有搜索历史和统计数据"
        case "ar": return "إزالة جميع تاريخ البحث والإحصائيات"
        default: return "Remove all search history and statistics"
        }
    }
    
    private func getSevenDaysText() -> String {
        switch currentLanguage {
        case "es": return "7 Días"
        case "fr": return "7 Jours"
        case "de": return "7 Tage"
        case "it": return "7 Giorni"
        case "pt": return "7 Dias"
        case "ru": return "7 Дней"
        case "ja": return "7日間"
        case "ko": return "7일"
        case "zh": return "7天"
        case "ar": return "7 أيام"
        default: return "7 Days"
        }
    }
    
    private func getThirtyDaysText() -> String {
        switch currentLanguage {
        case "es": return "30 Días"
        case "fr": return "30 Jours"
        case "de": return "30 Tage"
        case "it": return "30 Giorni"
        case "pt": return "30 Dias"
        case "ru": return "30 Дней"
        case "ja": return "30日間"
        case "ko": return "30일"
        case "zh": return "30天"
        case "ar": return "30 يوماً"
        default: return "30 Days"
        }
    }
    
    private func getForeverText() -> String {
        switch currentLanguage {
        case "es": return "Siempre"
        case "fr": return "Toujours"
        case "de": return "Für Immer"
        case "it": return "Per Sempre"
        case "pt": return "Para Sempre"
        case "ru": return "Навсегда"
        case "ja": return "永続"
        case "ko": return "영구"
        case "zh": return "永久"
        case "ar": return "إلى الأبد"
        default: return "Forever"
        }
    }
    
    // MARK: - Statistics & Analytics Localizations
    
    private func getStatisticsText() -> String {
        switch currentLanguage {
        case "es": return "Estadísticas"
        case "fr": return "Statistiques"
        case "de": return "Statistiken"
        case "it": return "Statistiche"
        case "pt": return "Estatísticas"
        case "ru": return "Статистика"
        case "ja": return "統計"
        case "ko": return "통계"
        case "zh": return "统计"
        case "ar": return "الإحصائيات"
        default: return "Statistics"
        }
    }
    
    private func getSearchTrendText() -> String {
        switch currentLanguage {
        case "es": return "Tendencia de Búsqueda"
        case "fr": return "Tendance de Recherche"
        case "de": return "Suchtrend"
        case "it": return "Tendenza di Ricerca"
        case "pt": return "Tendência de Pesquisa"
        case "ru": return "Тренд Поиска"
        case "ja": return "検索トレンド"
        case "ko": return "검색 트렌드"
        case "zh": return "搜索趋势"
        case "ar": return "اتجاه البحث"
        default: return "Search Trend"
        }
    }
    
    private func getTimeOfDayAnalysisText() -> String {
        switch currentLanguage {
        case "es": return "Análisis por Hora del Día"
        case "fr": return "Analyse par Heure de la Journée"
        case "de": return "Tageszeit-Analyse"
        case "it": return "Analisi per Ora del Giorno"
        case "pt": return "Análise por Hora do Dia"
        case "ru": return "Анализ Времени Дня"
        case "ja": return "時間帯分析"
        case "ko": return "시간대별 분석"
        case "zh": return "时段分析"
        case "ar": return "تحليل أوقات اليوم"
        default: return "Time of Day Analysis"
        }
    }
    
    private func getPlatformUsageStatsText() -> String {
        switch currentLanguage {
        case "es": return "Uso de Plataformas"
        case "fr": return "Utilisation des Plateformes"
        case "de": return "Plattform-Nutzung"
        case "it": return "Utilizzo delle Piattaforme"
        case "pt": return "Uso das Plataformas"
        case "ru": return "Использование Платформ"
        case "ja": return "プラットフォーム使用状況"
        case "ko": return "플랫폼 사용량"
        case "zh": return "平台使用情况"
        case "ar": return "استخدام المنصات"
        default: return "Platform Usage"
        }
    }
    
    private func getMorningTimeText() -> String {
        switch currentLanguage {
        case "es": return "Mañana"
        case "fr": return "Matin"
        case "de": return "Morgen"
        case "it": return "Mattina"
        case "pt": return "Manhã"
        case "ru": return "Утро"
        case "ja": return "朝"
        case "ko": return "아침"
        case "zh": return "上午"
        case "ar": return "الصباح"
        default: return "Morning"
        }
    }
    
    private func getAfternoonTimeText() -> String {
        switch currentLanguage {
        case "es": return "Tarde"
        case "fr": return "Après-midi"
        case "de": return "Nachmittag"
        case "it": return "Pomeriggio"
        case "pt": return "Tarde"
        case "ru": return "День"
        case "ja": return "午後"
        case "ko": return "오후"
        case "zh": return "下午"
        case "ar": return "بعد الظهر"
        default: return "Afternoon"
        }
    }
    
    private func getEveningTimeText() -> String {
        switch currentLanguage {
        case "es": return "Noche"
        case "fr": return "Soir"
        case "de": return "Abend"
        case "it": return "Sera"
        case "pt": return "Noite"
        case "ru": return "Вечер"
        case "ja": return "夜"
        case "ko": return "저녁"
        case "zh": return "晚上"
        case "ar": return "المساء"
        default: return "Evening"
        }
    }
    
    private func getYouSearchMostOftenText() -> String {
        switch currentLanguage {
        case "es": return "Buscas más a menudo en"
        case "fr": return "Vous recherchez le plus souvent"
        case "de": return "Sie suchen am häufigsten"
        case "it": return "Cerchi più spesso"
        case "pt": return "Você pesquisa mais frequentemente"
        case "ru": return "Вы чаще всего ищете"
        case "ja": return "最もよく検索する時間帯"
        case "ko": return "가장 자주 검색하는 시간"
        case "zh": return "你最常搜索的时段是"
        case "ar": return "تبحث أكثر ما يكون في"
        default: return "You search most often in the"
        }
    }
    
    private func getSearchesCountText() -> String {
        switch currentLanguage {
        case "es": return "búsquedas"
        case "fr": return "recherches"
        case "de": return "Suchen"
        case "it": return "ricerche"
        case "pt": return "pesquisas"
        case "ru": return "поисков"
        case "ja": return "回の検索"
        case "ko": return "번 검색"
        case "zh": return "次搜索"
        case "ar": return "عمليات بحث"
        default: return "searches"
        }
    }
    
    private func getExportYourDataText() -> String {
        switch currentLanguage {
        case "es": return "Exporta Tus Datos"
        case "fr": return "Exportez Vos Données"
        case "de": return "Exportieren Sie Ihre Daten"
        case "it": return "Esporta i Tuoi Dati"
        case "pt": return "Exporte Seus Dados"
        case "ru": return "Экспортируйте Ваши Данные"
        case "ja": return "データをエクスポート"
        case "ko": return "데이터 내보내기"
        case "zh": return "导出你的数据"
        case "ar": return "صدّر بياناتك"
        default: return "Export Your Data"
        }
    }
    
    private func getExportSearchHistoryText() -> String {
        switch currentLanguage {
        case "es": return "Historial de Búsqueda"
        case "fr": return "Historique de Recherche"
        case "de": return "Suchverlauf"
        case "it": return "Cronologia di Ricerca"
        case "pt": return "Histórico de Pesquisa"
        case "ru": return "История Поиска"
        case "ja": return "検索履歴"
        case "ko": return "검색 기록"
        case "zh": return "搜索历史"
        case "ar": return "تاريخ البحث"
        default: return "Search History"
        }
    }
    
    private func getTimePeriodText() -> String {
        switch currentLanguage {
        case "es": return "Período de Tiempo"
        case "fr": return "Période de Temps"
        case "de": return "Zeitraum"
        case "it": return "Periodo di Tempo"
        case "pt": return "Período de Tempo"
        case "ru": return "Временной Период"
        case "ja": return "期間"
        case "ko": return "기간"
        case "zh": return "时间段"
        case "ar": return "الفترة الزمنية"
        default: return "Time Period"
        }
    }
    
    private func getSinceFirstUseText() -> String {
        switch currentLanguage {
        case "es": return "desde el primer uso"
        case "fr": return "depuis la première utilisation"
        case "de": return "seit der ersten Nutzung"
        case "it": return "dal primo utilizzo"
        case "pt": return "desde o primeiro uso"
        case "ru": return "с первого использования"
        case "ja": return "初回使用から"
        case "ko": return "첫 사용부터"
        case "zh": return "自首次使用"
        case "ar": return "منذ أول استخدام"
        default: return "since first use"
        }
    }
    
    private func getAllTimeText() -> String {
        switch currentLanguage {
        case "es": return "Todo el Tiempo"
        case "fr": return "Tout le Temps"
        case "de": return "Alle Zeit"
        case "it": return "Tutto il Tempo"
        case "pt": return "Todo o Tempo"
        case "ru": return "Все Время"
        case "ja": return "全期間"
        case "ko": return "전체 기간"
        case "zh": return "全部时间"
        case "ar": return "كل الوقت"
        default: return "All Time"
        }
    }
    
    private func getLastSevenDaysText() -> String {
        switch currentLanguage {
        case "es": return "Últimos 7 Días"
        case "fr": return "7 Derniers Jours"
        case "de": return "Letzte 7 Tage"
        case "it": return "Ultimi 7 Giorni"
        case "pt": return "Últimos 7 Dias"
        case "ru": return "Последние 7 Дней"
        case "ja": return "過去7日間"
        case "ko": return "최근 7일"
        case "zh": return "最近7天"
        case "ar": return "آخر 7 أيام"
        default: return "Last 7 Days"
        }
    }
    
    private func getLastThirtyDaysText() -> String {
        switch currentLanguage {
        case "es": return "Últimos 30 Días"
        case "fr": return "30 Derniers Jours"
        case "de": return "Letzte 30 Tage"
        case "it": return "Ultimi 30 Giorni"
        case "pt": return "Últimos 30 Dias"
        case "ru": return "Последние 30 Дней"
        case "ja": return "過去30日間"
        case "ko": return "최근 30일"
        case "zh": return "最近30天"
        case "ar": return "آخر 30 يوماً"
        default: return "Last 30 Days"
        }
    }
    
    private func getExportFormatText() -> String {
        switch currentLanguage {
        case "es": return "Formato"
        case "fr": return "Format"
        case "de": return "Format"
        case "it": return "Formato"
        case "pt": return "Formato"
        case "ru": return "Формат"
        case "ja": return "フォーマット"
        case "ko": return "형식"
        case "zh": return "格式"
        case "ar": return "التنسيق"
        default: return "Format"
        }
    }
    
    private func getTimeRangeText() -> String {
        switch currentLanguage {
        case "es": return "Rango de Tiempo"
        case "fr": return "Plage de Temps"
        case "de": return "Zeitbereich"
        case "it": return "Intervallo di Tempo"
        case "pt": return "Intervalo de Tempo"
        case "ru": return "Временной Диапазон"
        case "ja": return "時間範囲"
        case "ko": return "시간 범위"
        case "zh": return "时间范围"
        case "ar": return "النطاق الزمني"
        default: return "Time Range"
        }
    }
    
    private func getExportContentText() -> String {
        switch currentLanguage {
        case "es": return "Contenido de Exportación"
        case "fr": return "Contenu d'Exportation"
        case "de": return "Export-Inhalt"
        case "it": return "Contenuto di Esportazione"
        case "pt": return "Conteúdo de Exportação"
        case "ru": return "Содержимое Экспорта"
        case "ja": return "エクスポート内容"
        case "ko": return "내보내기 내용"
        case "zh": return "导出内容"
        case "ar": return "محتوى التصدير"
        default: return "Export Content"
        }
    }
    
    private func getSearchQueriesText() -> String {
        switch currentLanguage {
        case "es": return "Consultas de Búsqueda"
        case "fr": return "Requêtes de Recherche"
        case "de": return "Suchanfragen"
        case "it": return "Query di Ricerca"
        case "pt": return "Consultas de Pesquisa"
        case "ru": return "Поисковые Запросы"
        case "ja": return "検索クエリ"
        case "ko": return "검색 쿼리"
        case "zh": return "搜索查询"
        case "ar": return "استعلامات البحث"
        default: return "Search Queries"
        }
    }
    
    private func getSearchQueriesDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "Todos tus términos de búsqueda y marcas de tiempo"
        case "fr": return "Tous vos termes de recherche et horodatages"
        case "de": return "Alle Ihre Suchbegriffe und Zeitstempel"
        case "it": return "Tutti i tuoi termini di ricerca e timestamp"
        case "pt": return "Todos os seus termos de pesquisa e timestamps"
        case "ru": return "Все ваши поисковые термины и временные метки"
        case "ja": return "すべての検索語句とタイムスタンプ"
        case "ko": return "모든 검색어 및 타임스탬프"
        case "zh": return "所有搜索词条和时间戳"
        case "ar": return "جميع مصطلحات البحث والطوابع الزمنية"
        default: return "All your search terms and timestamps"
        }
    }
    
    private func getPlatformUsageDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "Qué plataformas buscaste más"
        case "fr": return "Quelles plateformes vous avez le plus recherchées"
        case "de": return "Welche Plattformen Sie am meisten durchsucht haben"
        case "it": return "Quali piattaforme hai cercato di più"
        case "pt": return "Quais plataformas você pesquisou mais"
        case "ru": return "Какие платформы вы искали больше всего"
        case "ja": return "最も検索したプラットフォーム"
        case "ko": return "가장 많이 검색한 플랫폼"
        case "zh": return "你搜索最多的平台"
        case "ar": return "المنصات التي بحثت فيها أكثر"
        default: return "Which platforms you searched most"
        }
    }
    
    private func getUsageStatisticsText() -> String {
        switch currentLanguage {
        case "es": return "Estadísticas de Uso"
        case "fr": return "Statistiques d'Utilisation"
        case "de": return "Nutzungsstatistiken"
        case "it": return "Statistiche di Utilizzo"
        case "pt": return "Estatísticas de Uso"
        case "ru": return "Статистика Использования"
        case "ja": return "使用統計"
        case "ko": return "사용 통계"
        case "zh": return "使用统计"
        case "ar": return "إحصائيات الاستخدام"
        default: return "Usage Statistics"
        }
    }
    
    private func getUsageStatisticsDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "Recuentos de búsqueda y datos de tiempo ahorrado"
        case "fr": return "Comptes de recherches et données de temps économisé"
        case "de": return "Suchzahlen und Daten zur eingesparten Zeit"
        case "it": return "Conteggi di ricerca e dati sul tempo risparmiato"
        case "pt": return "Contagens de pesquisa e dados de tempo economizado"
        case "ru": return "Количество поисков и данные сэкономленного времени"
        case "ja": return "検索回数と節約時間のデータ"
        case "ko": return "검색 횟수 및 절약된 시간 데이터"
        case "zh": return "搜索次数和节省时间数据"
        case "ar": return "عدد عمليات البحث وبيانات الوقت المُوفر"
        default: return "Search counts and time saved data"
        }
    }
    
    private func getExportingDataText() -> String {
        switch currentLanguage {
        case "es": return "Exportando..."
        case "fr": return "Exportation..."
        case "de": return "Exportieren..."
        case "it": return "Esportazione..."
        case "pt": return "Exportando..."
        case "ru": return "Экспорт..."
        case "ja": return "エクスポート中..."
        case "ko": return "내보내는 중..."
        case "zh": return "导出中..."
        case "ar": return "جاري التصدير..."
        default: return "Exporting..."
        }
    }
    
    private func getExportDataButtonText() -> String {
        switch currentLanguage {
        case "es": return "Exportar Datos"
        case "fr": return "Exporter les Données"
        case "de": return "Daten Exportieren"
        case "it": return "Esporta Dati"
        case "pt": return "Exportar Dados"
        case "ru": return "Экспорт Данных"
        case "ja": return "データエクスポート"
        case "ko": return "데이터 내보내기"
        case "zh": return "导出数据"
        case "ar": return "تصدير البيانات"
        default: return "Export Data"
        }
    }
    
    private func getNoDataAvailableText() -> String {
        switch currentLanguage {
        case "es": return "No hay datos disponibles para el rango de tiempo seleccionado"
        case "fr": return "Aucune donnée disponible pour la plage de temps sélectionnée"
        case "de": return "Keine Daten für den ausgewählten Zeitraum verfügbar"
        case "it": return "Nessun dato disponibile per l'intervallo di tempo selezionato"
        case "pt": return "Nenhum dado disponível para o intervalo de tempo selecionado"
        case "ru": return "Нет данных для выбранного временного диапазона"
        case "ja": return "選択した時間範囲のデータがありません"
        case "ko": return "선택한 시간 범위에 대한 데이터가 없습니다"
        case "zh": return "所选时间范围内没有可用数据"
        case "ar": return "لا توجد بيانات متاحة للنطاق الزمني المحدد"
        default: return "No data available for the selected time range"
        }
    }
    
    // MARK: - Time Saved and Insights Localizations
    
    private func getVsEndlessScrollingText() -> String {
        switch currentLanguage {
        case "es": return "vs desplazamiento infinito"
        case "fr": return "vs défilement infini"
        case "de": return "vs endloses Scrollen"
        case "it": return "vs scorrimento infinito"
        case "pt": return "vs rolagem infinita"
        case "ru": return "vs бесконечная прокрутка"
        case "ja": return "vs 無限スクロール"
        case "ko": return "vs 무한 스크롤"
        case "zh": return "vs 无限滚动"
        case "ar": return "مقابل التمرير اللانهائي"
        default: return "vs endless scrolling"
        }
    }
    
    private func getStayingFocusedExclamationText() -> String {
        switch currentLanguage {
        case "es": return "¡Te mantienes enfocado!"
        case "fr": return "Vous restez concentré !"
        case "de": return "Sie bleiben fokussiert!"
        case "it": return "Rimani concentrato!"
        case "pt": return "Você se mantém focado!"
        case "ru": return "Вы остаетесь сосредоточенными!"
        case "ja": return "集中を保っています！"
        case "ko": return "집중력을 유지하고 있습니다!"
        case "zh": return "你保持专注！"
        case "ar": return "أنت تحافظ على تركيزك!"
        default: return "You're staying focused!"
        }
    }
    
    private func getTimeSavedFromDistractionsDetailedText() -> String {
        switch currentLanguage {
        case "es": return "Tiempo ahorrado evitando distracciones"
        case "fr": return "Temps économisé en évitant les distractions"
        case "de": return "Zeit gespart durch Vermeidung von Ablenkungen"
        case "it": return "Tempo risparmiato evitando distrazioni"
        case "pt": return "Tempo economizado evitando distrações"
        case "ru": return "Время, сэкономленное избеганием отвлечений"
        case "ja": return "気が散ることを避けて節約した時間"
        case "ko": return "방해 요소를 피해 절약한 시간"
        case "zh": return "避免分心节省的时间"
        case "ar": return "الوقت المُوفر من تجنب الإلهاءات"
        default: return "Time saved from distractions"
        }
    }
    
    private func getHighEfficiencyText() -> String {
        switch currentLanguage {
        case "es": return "Alta"
        case "fr": return "Élevée"
        case "de": return "Hoch"
        case "it": return "Alta"
        case "pt": return "Alta"
        case "ru": return "Высокая"
        case "ja": return "高"
        case "ko": return "높음"
        case "zh": return "高"
        case "ar": return "عالية"
        default: return "High"
        }
    }
    
    private func getFocusScorePercentText() -> String {
        switch currentLanguage {
        case "es": return "Puntuación de Enfoque"
        case "fr": return "Score de Concentration"
        case "de": return "Fokus-Bewertung"
        case "it": return "Punteggio di Concentrazione"
        case "pt": return "Pontuação de Foco"
        case "ru": return "Оценка Фокуса"
        case "ja": return "集中スコア"
        case "ko": return "집중 점수"
        case "zh": return "专注评分"
        case "ar": return "نقاط التركيز"
        default: return "Focus Score"
        }
    }
    
    private func getTodaysImpactTimeText() -> String {
        switch currentLanguage {
        case "es": return "Impacto de Hoy"
        case "fr": return "Impact d'Aujourd'hui"
        case "de": return "Heutiger Einfluss"
        case "it": return "Impatto di Oggi"
        case "pt": return "Impacto de Hoje"
        case "ru": return "Сегодняшний Эффект"
        case "ja": return "今日の影響"
        case "ko": return "오늘의 영향"
        case "zh": return "今日影响"
        case "ar": return "تأثير اليوم"
        default: return "Today's Impact"
        }
    }
}
