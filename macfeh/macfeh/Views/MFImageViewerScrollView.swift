//
//  MFImageViewerScrollView.swift
//  macfeh
//
//  Created by Ushio on 12/13/16.
//

import Cocoa

/// The `NSScrollView` subclass for `MFImageViewerViewController`'s image view scroll view
class MFImageViewerScrollView: NSScrollView {
    
    // MARK: - Properties
    
    /// The handler for when the user scrolls while holding command, passed the event of the scroll
    var scrollZoomHandler : ((NSEvent) -> ())? = nil;
    
    
    // MARK: - Functions
    
    override func scrollWheel(with event: NSEvent) {
        // If the user is holding the command key...
        if((event.modifierFlags.rawValue & NSEvent.ModifierFlags.command.rawValue) != 0) {
            // Call `scrollZoomHandler`
            scrollZoomHandler?(event);
        }
        else {
            super.scrollWheel(with: event);
        }
    }
}
