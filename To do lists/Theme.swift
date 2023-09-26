//
//  Theme.swift
//  To do lists
//
//  Created by Harshit Agarwal on 26/09/23.
//

import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case light = "Light"
    case dark = "Dark"
    case custom = "Custom"
    
    var id: String { self.rawValue }
    
    var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .custom:
            return .light // You can define your custom color scheme here
        }
    }
}
