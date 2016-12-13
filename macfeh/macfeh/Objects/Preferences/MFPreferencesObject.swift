//
//  MFPreferencesObject.swift
//  macfeh
//
//  Created by Ushio on 12/13/16.
//

import Cocoa

/// The object for storing preferences in macfeh
class MFPreferencesObject: NSObject, NSCoding {
    
    // MARK: - Properties
    
    /// The preference for setting the default behaviour of the viewer's show background option
    var viewerDefaultsShowBackground : Bool = true;
    
    /// The preference for setting the default behaviour of the viewer's enable shadow option
    var viewerDefaultsEnableShadow : Bool = true;
    
    
    // MARK: - Functions
    
    func encode(with coder: NSCoder) {
        // Encode the preferences
        coder.encode(viewerDefaultsShowBackground, forKey: "viewerDefaultsShowBackground");
        coder.encode(viewerDefaultsEnableShadow, forKey: "viewerDefaultsEnableShadow");
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init();
        
        // Decode and load the preferences
        self.viewerDefaultsShowBackground = decoder.decodeBool(forKey: "viewerDefaultsShowBackground");
        self.viewerDefaultsEnableShadow = decoder.decodeBool(forKey: "viewerDefaultsEnableShadow");
    }
}
