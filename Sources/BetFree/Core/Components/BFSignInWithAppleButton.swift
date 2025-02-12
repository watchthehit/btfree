import SwiftUI
import AuthenticationServices

public struct BFSignInWithAppleButton: View {
    let onCompletion: (Result<ASAuthorization, Error>) -> Void
    
    public init(onCompletion: @escaping (Result<ASAuthorization, Error>) -> Void) {
        self.onCompletion = onCompletion
    }
    
    public var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                switch result {
                case .success(let auth):
                    onCompletion(.success(auth))
                case .failure(let error):
                    onCompletion(.failure(error))
                }
            }
        )
        .frame(height: BFDesignSystem.Layout.Size.buttonHeight)
        .cornerRadius(BFDesignSystem.Layout.CornerRadius.button)
    }
} 