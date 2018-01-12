//
//  MFGeneralPreferencesViewController.swift
//  macfeh
//
//  Created by Ushio on 12/13/16.
//

import Cocoa

class MFGeneralPreferencesViewController: NSViewController {

    @IBOutlet private weak var viewerDefaultsShowBackgroundCheckbox: NSButton!
    @IBAction func viewerDefaultsShowBackgroundAction(_ sender: NSButton) {
        (NSApp.delegate as! AppDelegate).preferences.viewerDefaultsShowBackground = (sender.state == .on) ? true : false;
    }

    @IBOutlet weak var viewerDefaultsEnableShadowCheckbox: NSButton!
    @IBAction func viewerDefaultsEnableShadowAction(_ sender: NSButton) {
        (NSApp.delegate as! AppDelegate).preferences.viewerDefaultsEnableShadow = (sender.state == .on) ? true : false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        displayPreferences((NSApp.delegate as! AppDelegate).preferences);
    }

    private func displayPreferences(_ preferences: MFPreferencesObject) {
        viewerDefaultsShowBackgroundCheckbox.state = NSControl.StateValue(rawValue: preferences.viewerDefaultsShowBackground ? 1 : 0);
        viewerDefaultsEnableShadowCheckbox.state = NSControl.StateValue(rawValue: preferences.viewerDefaultsEnableShadow ? 1 : 0);
    }
}
