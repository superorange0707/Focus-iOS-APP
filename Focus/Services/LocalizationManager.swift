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
        "zh": "中文"
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
        case .doNotDisturb:
            return getDoNotDisturbText()
        case .done:
            return getDoneText()
        case .selectLanguage:
            return getSelectLanguageText()
        case .searchPreferences:
            return getSearchPreferencesText()
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
        case .autoDoNotDisturbDescription:
            return getAutoDoNotDisturbDescriptionText()
        case .aiSummarizationDescription:
            return getAiSummarizationDescriptionText()
        case .dailySearchLimitDescription:
            return getDailySearchLimitDescriptionText()
        case .autoDoNotDisturb:
            return getAutoDoNotDisturbText()
        case .aiSummarization:
            return getAiSummarizationText()
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
        default: return "Search"
        }
    }
    
    private func getSearchPlaceholder() -> String {
        switch currentLanguage {
        case "es": return "Buscar en todas las plataformas..."
        case "fr": return "Rechercher sur toutes les plateformes..."
        case "de": return "Auf allen Plattformen suchen..."
        case "it": return "Cerca su tutte le piattaforme..."
        case "pt": return "Pesquisar em todas as plataformas..."
        case "ru": return "Поиск на всех платформах..."
        case "ja": return "すべてのプラットフォームで検索..."
        case "ko": return "모든 플랫폼에서 검색..."
        case "zh": return "在所有平台搜索..."
        default: return "Search across all platforms..."
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
        case "es": return "Búsquedas Totales"
        case "fr": return "Recherches Totales"
        case "de": return "Gesamte Suchen"
        case "it": return "Ricerche Totali"
        case "pt": return "Pesquisas Totais"
        case "ru": return "Всего Поисков"
        case "ja": return "総検索数"
        case "ko": return "총 검색"
        case "zh": return "总搜索"
        default: return "Total Searches"
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
    
    private func getDoNotDisturbText() -> String {
        switch currentLanguage {
        case "es": return "No Molestar"
        case "fr": return "Ne Pas Déranger"
        case "de": return "Nicht Stören"
        case "it": return "Non Disturbare"
        case "pt": return "Não Perturbar"
        case "ru": return "Не Беспокоить"
        case "ja": return "おやすみモード"
        case "ko": return "방해 금지"
        case "zh": return "勿扰模式"
        default: return "Do Not Disturb"
        }
    }
    
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

    private func getAutoDoNotDisturbDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "Habilitar al abrir SkipFeed"
        case "fr": return "Activer lors de l'ouverture de SkipFeed"
        case "de": return "Beim Öffnen von SkipFeed aktivieren"
        case "it": return "Abilita all'apertura di SkipFeed"
        case "pt": return "Ativar ao abrir SkipFeed"
        case "ru": return "Включить при открытии SkipFeed"
        case "ja": return "SkipFeed開く時に有効にする"
        case "ko": return "SkipFeed 열 때 활성화"
        case "zh": return "打开SkipFeed时启用"
        default: return "Enable when opening SkipFeed"
        }
    }

    private func getAiSummarizationDescriptionText() -> String {
        switch currentLanguage {
        case "es": return "50 créditos restantes"
        case "fr": return "50 crédits restants"
        case "de": return "50 Credits übrig"
        case "it": return "50 crediti rimanenti"
        case "pt": return "50 créditos restantes"
        case "ru": return "50 кредитов осталось"
        case "ja": return "50クレジット残り"
        case "ko": return "50 크레딧 남음"
        case "zh": return "50积分剩余"
        default: return "50 credits left"
        }
    }

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

    private func getAutoDoNotDisturbText() -> String {
        switch currentLanguage {
        case "es": return "Auto No Molestar"
        case "fr": return "Auto Ne Pas Déranger"
        case "de": return "Auto Nicht Stören"
        case "it": return "Auto Non Disturbare"
        case "pt": return "Auto Não Perturbar"
        case "ru": return "Авто Не Беспокоить"
        case "ja": return "自動おやすみモード"
        case "ko": return "자동 방해 금지"
        case "zh": return "自动勿扰"
        default: return "Auto Do Not Disturb"
        }
    }

    private func getAiSummarizationText() -> String {
        switch currentLanguage {
        case "es": return "Resumen con IA"
        case "fr": return "Résumé IA"
        case "de": return "KI-Zusammenfassung"
        case "it": return "Riassunto IA"
        case "pt": return "Resumo IA"
        case "ru": return "ИИ Резюме"
        case "ja": return "AI要約"
        case "ko": return "AI 요약"
        case "zh": return "AI摘要"
        default: return "AI Summarization"
        }
    }

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
        default: return "Clear History"
        }
    }
}

// MARK: - Localized String Keys
enum LocalizedStringKey {
    // Main UI
    case search, searchPlaceholder, settings, premium, data, choosePlatform, recentSearches, clear
    case searchOn, openIn, openTikTokSearch

    // Stats
    case totalSearches, today, timeSaved, platformUsage, searchHistory, stats, history
    case dailyLimit, insights, focusScore, stayingFocused, todaysImpact, timeSavedFromDistractions
    case efficiency, directSearchesSaveTime, searches, left, of, trial

    // Settings
    case language, autoDetect, autoDetectSubtitle, searchMode, directSearch, doNotDisturb, done, selectLanguage
    case searchPreferences, premiumFeatures, usageAndData, freeTrialActive, daysRemaining, clearRecentSearches
    case searchModeDescription, autoDoNotDisturbDescription, aiSummarizationDescription, dailySearchLimitDescription
    case autoDoNotDisturb, aiSummarization, creditsLeft, searchesPerDay

    // About & Support
    case aboutAndSupport, version, privacyPolicy, termsOfService, supportAndFAQ, contactUs

    // Premium
    case upgradeToUnlock, freeTrial, startFreeTrial, restorePurchases

    // Search History
    case noHistory, noHistoryMessage, searchInHistory, allPlatforms, clearHistory
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
}
