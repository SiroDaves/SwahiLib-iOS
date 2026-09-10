//
//  SettingsForm.swift
//  SongLib
//
//  Created by @sirodevs on 26/08/2025.
//

import SwiftUI

struct SettingsForm: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showPaywall: Bool
    @Binding var showResetAlert: Bool
    
    @State private var notificationTime = Date()
    @State private var notificationsEnabled = true
    
    var body: some View {
        Form {
            SettingsSection(header: "Mandhari") {
                Picker("Chagua Mandhari", selection: $themeManager.selectedTheme) {
                    ForEach(AppThemeMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
            }
            
            Section(header: Text("Neno la Siku")) {
                Toggle("Wezesha Notifications", isOn: Binding(
                    get: { viewModel.notificationsEnabled },
                    set: { viewModel.toggleNotifications($0) }
                ))
                
                if viewModel.notificationsEnabled {
                    DatePicker("Wakati wa Notification", selection: Binding(
                        get: { viewModel.notificationTime },
                        set: { viewModel.updateNotificationTime($0) }
                    ), displayedComponents: .hourAndMinute)
                }
            }

            #if !DEBUG
            if !viewModel.isProUser {
                SettingsSection(header: "Swahilib Pro") {
                    SettingsRow(
                        systemImage: "crown.fill",
                        title: L10n.joinPro,
                        subtitle: L10n.joinProDesc,
                        foregroundColor: .yellow,
                        action: { showPaywall = true }
                    )
                }
            }
            #endif

            SettingsSection(header: "Maoni") {
                SettingsRow(
                    systemImage: "text.badge.star",
                    title: L10n.leaveReview,
                    subtitle: L10n.leaveReviewDesc,
                    action: viewModel.promptReview
                )
                SettingsRow(
                    systemImage: "envelope",
                    title: L10n.contactUs,
                    subtitle: L10n.contactUsDesc,
                    action: AppUtilities.sendEmail
                )
            }

            SettingsSection(header: "Danger") {
                SettingsRow(
                    systemImage: "exclamationmark.triangle.fill",
                    title: L10n.resetData,
                    subtitle: L10n.resetDataDesc,
                    foregroundColor: .red,
                    action: { showResetAlert = true }
                )
            }
        }
    }
}
