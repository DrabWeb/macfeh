//
//  Preferences.swift
//  macfeh
//
//  Created by Ushio on 12/13/16.
//

import Cocoa

class Preferences {

    var viewerDefaultsShowBackground: Bool = true;
    var viewerDefaultsEnableShadow: Bool = true;

    func save() {
        UserDefaults.standard.setValue(viewerDefaultsShowBackground, forKey: PreferencesKey.showBackground.rawValue);
        UserDefaults.standard.setValue(viewerDefaultsEnableShadow, forKey: PreferencesKey.enableShadow.rawValue);
        UserDefaults.standard.synchronize();
    }

    func load() {
        if let showBackground = UserDefaults.standard.value(forKey: PreferencesKey.showBackground.rawValue) as? Bool {
            viewerDefaultsShowBackground = showBackground;
        }

        if let enableShadow = UserDefaults.standard.value(forKey: PreferencesKey.enableShadow.rawValue) as? Bool {
            viewerDefaultsEnableShadow = enableShadow;
        }
    }

    private enum PreferencesKey: String {
        case showBackground = "showBackground"
        case enableShadow = "enableShadow"
    }
}
