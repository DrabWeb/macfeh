//
//  MFImageExtensions.swift
//  macfeh
//
//  Created by Ushio on 12/12/16.
//

import Foundation
import AppKit

extension NSImage {
    /// Gets the size of this image
    ///
    /// - Returns: The size in pixels of this image
    var pixelSize : NSSize {
        /// The `NSBitmapImageRep` to the image
        var imageRep : NSBitmapImageRep? = (NSBitmapImageRep(data: self.tiffRepresentation!))!;
        
        /// The size of the image in pixels
        let imageSize : NSSize = NSSize(width: imageRep!.pixelsWide, height: imageRep!.pixelsHigh);
        
        // Take the `imageRep` out of memory
        imageRep = nil;
        
        // Return `imageSize`
        return imageSize;
    }
}
