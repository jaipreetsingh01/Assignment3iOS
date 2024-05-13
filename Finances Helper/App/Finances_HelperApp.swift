//
//  Finances_HelperApp.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import SwiftUI

@main
struct Finances_HelperApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // to manage app lifecycle
    var body: some Scene {
        WindowGroup {
            ContentView() // instance of content view which is inital view for app
                .environmentObject(appDelegate.appEnvironment.rootVM) // to share data across app
        }
    }
}
