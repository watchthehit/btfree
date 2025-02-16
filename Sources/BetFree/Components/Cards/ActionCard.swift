import SwiftUI
import BetFreeUI

@available(macOS 10.15, iOS 13.0, *)
public struct ActionCard: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    public init(
        title: String,
        icon: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(Color.blue)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 4,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 16) {
        ActionCard(
            title: "Add Transaction",
            icon: "plus.circle.fill"
        ) {
            print("Add transaction tapped")
        }
        
        ActionCard(
            title: "Get Help",
            icon: "questionmark.circle.fill"
        ) {
            print("Help tapped")
        }
    }
    .padding(.all)
    .background(Color.white)
    .cornerRadius(12)
    .shadow(
        color: Color.black.opacity(0.1),
        radius: 4,
        x: 0,
        y: 2
    )
}
