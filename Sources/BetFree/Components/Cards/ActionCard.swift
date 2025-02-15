import SwiftUI

public struct ActionCard: View {
    let title: String
    let icon: String
    let action: () -> Void
    let color: Color
    
    public init(
        title: String,
        icon: String,
        color: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 10,
                        x: 0,
                        y: 4
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack(spacing: 16) {
        ActionCard(
            title: "Add Transaction",
            icon: "plus.circle.fill",
            color: .blue
        ) {
            print("Add transaction tapped")
        }
        
        ActionCard(
            title: "Get Help",
            icon: "questionmark.circle.fill",
            color: .purple
        ) {
            print("Help tapped")
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
