enum Strings {
    enum Color {
        static let branding = "clr_branding"
        static let highlight = "clr_highlight"
        static let primaryBackground = "clr_primary_background"
        static let primaryText = "clr_primary_text"
        static let secondaryText = "clr_secondary_text"
        static let tertiaryText = "clr_tertiary_text"
        static let transparentBackground = "clr_transparent_background"
        static let linkText = "clr_link_text"
        static let navigationText = "clr_navigation_text"
    }
    
    enum SystemImage: String {
        case checkmark
    }
    
    enum LocalizableKeys {
        static let locale = "locale"
        static let title = "link.shortener.title"
        static let copy = "link.shortener.copy"
        
        enum Link {
            enum TextField {
                static let placeholder = "link.textfield.placeholder"
                
                enum Error {
                    static let send = "link.textfield.send.error"
                    static let save = "link.textfield.save.error"
                }
            }
            
            enum List {
                static let recent = "link.list.recent.title"
                
                enum Error {
                    static let title = "link.list.error.title"
                    static let message = "link.list.error.message"
                    static let button = "link.list.error.button"
                }
            }
        }
    }
}
