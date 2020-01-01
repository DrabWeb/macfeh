//
//  ImageViewerZoomGestureRecognizer.swift
//  macfeh
//
//  Created by Finn Rayment on 01/01/2020.
//  Copyright © 2020 DrabWeb. All rights reserved.
//

import Quartz

class ImageViewerZoomGestureRecognizer : NSMagnificationGestureRecognizer {
    
    @IBOutlet private var controller: ImageViewerController!
    @IBOutlet private var imageView: IKImageView!
    
    override func magnify(with event: NSEvent) {
        super.magnify(with: event)
        imageView.magnify(with: event)
        controller.zoomClamp()
    }
    
}
