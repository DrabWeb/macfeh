//
//  MFImageView.swift
//  macfeh
//
//  Created by Ushio on 12/12/16.
//

import Foundation
import AppKit

/// The custom NSImageView subclass for macfeh to allow window background dragging
class MFImageView: NSImageView {
    
    // MARK: - Properties
    
    // Override mouse down can move window so we can drag the image view and move the window
    override var mouseDownCanMoveWindow : Bool {
        return true;
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect);
        
        // Set the current graphics contexts image interpolation to high for maximum quality
        NSGraphicsContext.current()!.imageInterpolation = NSImageInterpolation.high;
    }
}
