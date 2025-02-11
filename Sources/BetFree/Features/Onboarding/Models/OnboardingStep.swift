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
        // Welcome & Introduction
        case welcome
        case personalInfo([PersonalField])
        case assessment([AssessmentQuestion])
        
        // Goal Setting
        case goalSelection([String])
        case milestones([Milestone])
        case rewardSystem([Reward])
        
        // Current Situation
        case situationInput([InputField])
        case gamblingHistory([HistoryQuestion])
        case riskAssessment([RiskFactor])
        
        // Support System
        case supportSelection([String])
        case supportNetwork([Contact])
        case therapistIntegration
        
        // Commitment & Planning
        case commitmentLevel([SliderOption])
        case triggerIdentification([Trigger])
        case copingStrategies([Strategy])
        
        // Community & Resources
        case communityPreview
        case resourcesIntroduction([Resource])
        
        // Final Steps
        case safetyPlan
        case emergencyContacts
        case recap
    }
    
    // Personal Information
    public struct PersonalField {
        public let title: String
        public let placeholder: String
        public let type: FieldType
        public let validation: ValidationRule?
        
        public enum FieldType {
            case name
            case age
            case email
            case phone
            case custom(keyboardType: BFKeyboardType)
        }
        
        public enum ValidationRule {
            case email
            case phone
            case age(min: Int, max: Int)
            case custom((String) -> Bool)
        }
    }
    
    // Assessment
    public struct AssessmentQuestion {
        public let question: String
        public let options: [String]
        public let type: QuestionType
        public let weight: Int
        
        public enum QuestionType {
            case singleChoice
            case multipleChoice
            case scale(min: Int, max: Int)
        }
    }
    
    // Gambling History
    public struct HistoryQuestion {
        public let question: String
        public let type: QuestionType
        public let required: Bool
        public let helpText: String?
        
        public enum QuestionType {
            case duration(unit: TimeUnit)
            case frequency(options: [String])
            case amount(currency: String)
            case text
            case yesNo
            case multiSelect(options: [String])
        }
        
        public enum TimeUnit {
            case days
            case months
            case years
        }
        
        public init(
            question: String,
            type: QuestionType,
            required: Bool = true,
            helpText: String? = nil
        ) {
            self.question = question
            self.type = type
            self.required = required
            self.helpText = helpText
        }
    }
    
    // Risk Assessment
    public struct RiskFactor {
        public let name: String
        public let description: String
        public let severity: Severity
        public let recommendations: [String]
        
        public enum Severity {
            case low
            case medium
            case high
            case critical
        }
    }
    
    // Goal Setting
    public struct Milestone {
        public let title: String
        public let duration: TimeInterval
        public let type: MilestoneType
        public let rewards: [Reward]
        
        public enum MilestoneType {
            case shortTerm
            case mediumTerm
            case longTerm
        }
    }
    
    public struct Reward {
        public let title: String
        public let description: String
        public let icon: String
        public let type: RewardType
        
        public enum RewardType {
            case achievement
            case streak
            case savings
            case custom
        }
    }
    
    // Support Network
    public struct Contact {
        public let name: String
        public let relationship: String
        public let phone: String?
        public let email: String?
        public let type: ContactType
        public let availability: [Availability]
        
        public enum ContactType {
            case emergency
            case support
            case professional
            case sponsor
        }
        
        public struct Availability {
            public let dayOfWeek: Int
            public let startTime: Date
            public let endTime: Date
        }
    }
    
    // Triggers and Coping
    public struct Trigger {
        public let name: String
        public let category: TriggerCategory
        public let intensity: Int
        public let strategies: [Strategy]
        
        public enum TriggerCategory {
            case emotional
            case social
            case financial
            case environmental
            case custom(String)
        }
    }
    
    public struct Strategy {
        public let title: String
        public let description: String
        public let steps: [String]
        public let effectiveness: Int
        public let timeRequired: TimeInterval
    }
    
    // Resources
    public struct Resource {
        public let title: String
        public let description: String
        public let type: ResourceType
        public let url: URL?
        public let contactInfo: Contact?
        
        public enum ResourceType {
            case article
            case video
            case podcast
            case helpline
            case professionalService
            case support
        }
    }
    
    // Original Fields
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