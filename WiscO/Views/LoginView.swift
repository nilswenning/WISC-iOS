//
//  LoginView.swift
//  WiscO
//
//  Created by Nils Wenning on 01.05.24.
//

import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isVisible in
                withAnimation(.easeInOut(duration: 0.3)) {
                    self?.isKeyboardVisible = isVisible
                }
            }
            .store(in: &cancellables)
    }
}


struct LoginView: View {
    @StateObject var globalViewModel: GlobalViewModel
    @StateObject private var viewModel = LoginViewModel()
    @ObservedObject private var keyboardObserver = KeyboardObserver()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Conditional Header based on keyboard state
                    if !keyboardObserver.isKeyboardVisible {
                        HeadderView(title: "WiscO", subtitle: "Speed up ur Life", angle: 10, background: .pink)
                            .transition(.move(edge: .top))
                    }

                    // LoginForm
                    Form {
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                        }
                        TextField("Server URL", text: $viewModel.serverUrl)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TLButton(title: "Log In", background: .blue) {
                            viewModel.login { isSuccess in
                                if isSuccess {
                                    globalViewModel.isLoggedIn = true
                                } else {
                                    print("Login failed")
                                }
                            }
                        }
                    }
                    .offset(y: -100)
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                }
            }
        }
        .animation(.easeInOut, value: keyboardObserver.isKeyboardVisible) // Apply animation to the whole NavigationView
    }
}

