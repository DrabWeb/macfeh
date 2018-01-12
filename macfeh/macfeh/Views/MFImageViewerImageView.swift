//
//  MFImageViewerImageView.swift
//  macfeh
//
//  Created by Ushio on 12/13/16.
//

import Cocoa
import Quartz

class MFImageViewerImageView: IKImageView {

    override var mouseDownCanMoveWindow: Bool {
        return true;
    }
    
    override func mouseDragged(with event: NSEvent) {
        window?.performDrag(with: event);
    }
    
    // dont let IKImageView do anything special
    override func flagsChanged(with event: NSEvent) { }
    override func keyDown(with event: NSEvent) { }
    override func keyUp(with event: NSEvent) { }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect);

        // ive found that setting this results in the highest display quality for images
        NSGraphicsContext.current?.imageInterpolation = .high;
    }
}
