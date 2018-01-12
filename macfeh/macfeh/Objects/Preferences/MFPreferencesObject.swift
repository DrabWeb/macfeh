//
//  MFPreferencesObject.swift
//  macfeh
//
//  Created by Ushio on 12/13/16.
//

import Cocoa

class MFPreferencesObject: NSObject, NSCoding {

    var viewerDefaultsShowBackground: Bool = true;
    var viewerDefaultsEnableShadow: Bool = true;

    func encode(with coder: NSCoder) {
        coder.encode(viewerDefaultsShowBackground, forKey: "viewerDefaultsShowBackground");
        coder.encode(viewerDefaultsEnableShadow, forKey: "viewerDefaultsEnableShadow");
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init();

        viewerDefaultsShowBackground = decoder.decodeBool(forKey: "viewerDefaultsShowBackground");
        viewerDefaultsEnableShadow = decoder.decodeBool(forKey: "viewerDefaultsEnableShadow");
    }
}
