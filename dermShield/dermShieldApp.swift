//
//  dermShieldApp.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 08/12/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import TipKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct dermShieldApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    @AppStorage("emailLoggedIn") var emailLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if !isSignIn && !emailLoggedIn {
                ContentView()
                    .transition(.move(edge: .leading)) // Add animation
                    .animation(.easeInOut(duration: 0.5)) // Set animation duration
            } else {
                UserFirstView()
                    .transition(.move(edge: .trailing)) // Add animation
                    .animation(.easeInOut(duration: 0.5)) // Set animation duration
            }
        }
    }
    init() {
           // Configure and load all tips in the app.
           try? Tips.configure()
       }

}

