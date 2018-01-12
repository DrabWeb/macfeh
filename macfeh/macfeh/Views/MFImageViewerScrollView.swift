//
//  MFImageViewerScrollView.swift
//  macfeh
//
//  Created by Ushio on 12/13/16.
//

import Cocoa

class MFImageViewerScrollView: NSScrollView {

    var onZoom: ((NSEvent) -> Void)?

    override func scrollWheel(with event: NSEvent) {
        if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.command.rawValue) != 0 {
            onZoom?(event);
        }
        else {
            super.scrollWheel(with: event);
        }
    }
}
