//
//  AuthViewModel.swift
//  Journal
//
//  Created by 조영민 on 7/8/25.
//

import Foundation
import LocalAuthentication

class AuthViewModel: ObservableObject {
    @Published var isUnlocked = false
    @Published var authError: String?
    
    func authenicate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "앱 잠금 해제를 위해 Face ID를 사용합니다.") { success , error in
                DispatchQueue.main.async {
                    self.isUnlocked = success
                    self.authError = success ? nil : error?.localizedDescription
                }
            }
        } else {
            DispatchQueue.main.async {
                self.authError = "Face ID를 사용할 수 없습니다."
            }
        }
    }
}
