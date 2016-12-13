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
        let imageRep : NSBitmapImageRep = (NSBitmapImageRep(data: self.tiffRepresentation!))!;
        
        /// The size of the image in pixels
        let imageSize : NSSize = NSSize(width: imageRep.pixelsWide, height: imageRep.pixelsHigh);
        
        // Return `imageSize`
        return imageSize;
    }
    
    /// Scales this image by the given fraction and returns it
    ///
    /// - Parameter factor: The factor to scale this image by
    /// - Returns: The scaled image
    func scaledByFactor(_ factor : CGFloat) -> NSImage {
        /// The size for the scaled image
        var resizedSize : NSSize = self.pixelSize;
        
        // Set the image size
        resizedSize.width = resizedSize.width * factor;
        resizedSize.height = resizedSize.height * factor;
        
        /// The resized image to return
        let resizedImage : NSImage = NSImage(size: resizedSize);
        
        // A reference to this image for using as the source
        let sourceImage : NSImage = self;
        
        // Lock drawing focus
        resizedImage.lockFocus();
        
        // Set the source image's size
        sourceImage.size = resizedSize;
        
        // Set image interpolation to the best quality
        NSGraphicsContext.current()!.imageInterpolation = NSImageInterpolation.high;
        
        // Draw `sourceImage` into `resizedImage`
        sourceImage.draw(at: NSZeroPoint, from: NSRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height), operation: .copy, fraction: 1);
        
        // Unlock drawing focus
        resizedImage.unlockFocus();
        
        // Return `resizedImage`
        return resizedImage;
    }
}
