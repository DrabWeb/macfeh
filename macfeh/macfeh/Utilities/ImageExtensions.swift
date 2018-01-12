//
//  ImageExtensions.swift
//  macfeh
//
//  Created by Ushio on 12/12/16.
//

import Foundation
import AppKit

extension NSImage {
    var pixelSize: NSSize {
        if let imageRep = NSBitmapImageRep(data: self.tiffRepresentation!) {
            return NSSize(width: imageRep.pixelsWide, height: imageRep.pixelsHigh);
        }

        return NSSize.zero;
    }
}
