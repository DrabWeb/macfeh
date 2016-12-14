//
//  MFImageViewerImageView.swift
//  macfeh
//
//  Created by Ushio on 12/13/16.
//

import Cocoa
import Quartz

/// The `IKImageView` subclass for the image view in `MFImageViewerViewController`
class MFImageViewerImageView: IKImageView {
    
    // MARK: - Properties
    
    override var mouseDownCanMoveWindow: Bool {
        return true;
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.window?.performDrag(with: event);
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect);
        
        // Always use maximum image interpolation for highest quality
        NSGraphicsContext.current()?.imageInterpolation = .high;
    }
}
