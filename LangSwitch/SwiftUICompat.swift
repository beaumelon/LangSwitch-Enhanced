//
//  SwiftUICompat.swift
//  LangSwitch
//

import SwiftUI

extension View {
    func secondaryForeground() -> some View {
        foregroundColor(.secondary)
    }

    func tertiaryForeground() -> some View {
        foregroundColor(Color.secondary.opacity(0.72))
    }
}

struct SettingsLabeledRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .secondaryForeground()
        }
    }
}

struct SettingsSectionCard<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .labelStyle(.titleAndIcon)

            VStack(alignment: .leading, spacing: 14) {
                content()
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.primary.opacity(0.045))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.07), lineWidth: 1)
            )
        }
    }
}

struct SettingsHelpText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .secondaryForeground()
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct SettingsValueBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.medium).monospacedDigit())
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color.accentColor.opacity(0.12))
            .foregroundStyle(Color.accentColor)
            .clipShape(Capsule())
    }
}

struct SettingsWarningBanner: View {
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                    Text(message)
                        .font(.subheadline)
                        .secondaryForeground()
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Button(actionTitle, action: action)
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.orange.opacity(0.35), lineWidth: 1)
        )
    }
}

struct SettingsStatusBadge: View {
    let granted: Bool
    let grantedText: String
    let deniedText: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: granted ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .font(.caption)
            Text(granted ? grantedText : deniedText)
                .font(.caption.weight(.semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background((granted ? Color.green : Color.orange).opacity(0.14))
        .foregroundStyle(granted ? Color.green : Color.orange)
        .clipShape(Capsule())
    }
}
