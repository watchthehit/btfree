import SwiftUI

public struct OnboardingStep: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let image: String
    public let imageColor: Color
    public let background: Color
    public let type: StepType
    
    public enum StepType {
        case welcome
        case goalSelection([String])
        case situationInput([InputField])
        case supportSelection([String])
        case commitmentLevel([SliderOption])
    }
    
    public struct InputField {
        public let title: String
        public let placeholder: String
        public let keyboardType: BFKeyboardType
        public let prefix: String?
        
        public init(title: String, placeholder: String, keyboardType: BFKeyboardType = .default, prefix: String? = nil) {
            self.title = title
            self.placeholder = placeholder
            self.keyboardType = keyboardType
            self.prefix = prefix
        }
    }
    
    public struct SliderOption {
        public let title: String
        public let range: ClosedRange<Double>
        public let step: Double
        public let format: String
        
        public init(title: String, range: ClosedRange<Double>, step: Double = 1, format: String = "%.0f") {
            self.title = title
            self.range = range
            self.step = step
            self.format = format
        }
    }
    
    public init(title: String, subtitle: String, image: String, imageColor: Color, background: Color, type: StepType) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.imageColor = imageColor
        self.background = background
        self.type = type
    }
} 