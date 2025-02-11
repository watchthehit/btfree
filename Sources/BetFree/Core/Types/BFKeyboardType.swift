import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public enum BFKeyboardType {
    case `default`
    case decimalPad
    case numberPad
    case emailAddress
    case phonePad
    case asciiCapable
    case url
    case twitter
    case webSearch
    
    #if canImport(UIKit)
    var uiKeyboardType: UIKeyboardType {
        switch self {
        case .default:
            return .default
        case .decimalPad:
            return .decimalPad
        case .numberPad:
            return .numberPad
        case .emailAddress:
            return .emailAddress
        case .phonePad:
            return .phonePad
        case .asciiCapable:
            return .asciiCapable
        case .url:
            return .URL
        case .twitter:
            return .twitter
        case .webSearch:
            return .webSearch
        }
    }
    #endif
} 