//
//  MFGeneralPreferencesViewController.swift
//  macfeh
//
//  Created by Ushio on 12/13/16.
//

import Cocoa

/// The view controller for the general tab of the preferences
class MFGeneralPreferencesViewController: NSViewController {

    // MARK: - Properties
    
    /// The check box for setting the default of the background showing in a viewer
    @IBOutlet weak var viewerDefaultsShowBackgroundCheckbox: NSButton!
    
    /// The action for `viewerDefaultsShowBackgroundCheckbox`
    @IBAction func viewerDefaultsShowBackgroundCheckboxAction(_ sender: NSButton) {
        // Update the preferences to match
        (NSApp.delegate as! AppDelegate).preferences.viewerDefaultsShowBackground = (sender.state == NSOnState) ? true : false;
    }
    
    /// The check box for setting the default of the shadow of a viewer being enabled
    @IBOutlet weak var viewerDefaultsEnableShadowCheckbox: NSButton!
    
    /// The action for `viewerDefaultsEnableShadowCheckbox`
    @IBAction func viewerDefaultsEnableShadowCheckboxAction(_ sender: NSButton) {
        // Update the preferences to match
        (NSApp.delegate as! AppDelegate).preferences.viewerDefaultsEnableShadow = (sender.state == NSOnState) ? true : false;
    }
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Display the preferences values
        self.displayPreferences();
    }
    
    /// Displays the values from the global preferences object
    func displayPreferences() {
        // Display all the values
        viewerDefaultsShowBackgroundCheckbox.state = ((NSApp.delegate as! AppDelegate).preferences.viewerDefaultsShowBackground) ? 1 : 0;
        viewerDefaultsEnableShadowCheckbox.state = ((NSApp.delegate as! AppDelegate).preferences.viewerDefaultsEnableShadow) ? 1 : 0;
    }
}
