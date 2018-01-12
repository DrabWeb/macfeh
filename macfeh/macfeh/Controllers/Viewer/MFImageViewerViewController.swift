//
//  MFImageViewerViewController.swift
//  macfeh
//
//  Created by Ushio on 12/12/16.
//

import Cocoa
import Quartz

class MFImageViewerViewController: NSViewController, NSWindowDelegate {

    // MARK: - Variables
    
    /// The window of this view controller
    var window : NSWindow? = nil;
    
    /// The scroll view for `imageView`
    @IBOutlet weak var imageViewScrollView: MFImageViewerScrollView!
    
    /// The image view for this image viewer
    @IBOutlet weak var imageView: IKImageView!
    
    /// The loading spinner to show while the image is loading
    @IBOutlet weak var loadingSpinner: NSProgressIndicator!
    
    /// Is the background visible on this viewer?
    var backgroundVisible : Bool = true;
    
    /// Is there a shadow on this viewer?
    var shadowVisible : Bool = true;
    
    /// The image this viewer is displaying(if any)
    var representedImage : NSImage? = nil;
    
    /// The size of `representedImage`
    var representedImageSize : NSSize? = nil;
    
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Setup this view controller
        self.setup();
    }
    
    /// Displays the image at the given path in this image view
    func display(image path : String) {
        // Add the image to recents
        NSDocumentController.shared.noteNewRecentDocumentURL(URL(fileURLWithPath: path));
        
        // Load the image at `path`
        DispatchQueue.global(qos: .background).async {
            /// The `NSImage` at `path`
            let image : NSImage? = NSImage(contentsOfFile: path);
            
            /// The pixel size of `image`
            let imagePixelSize : NSSize? = image?.pixelSize;
            
            // If `image` isn't nil...
            if(image != nil) {
                DispatchQueue.main.async {
                    // Set the image view's image
                    self.imageView.setImageWith(URL(fileURLWithPath: path));
                    
                    // Stop the loading spinner
                    self.loadingSpinner.stopAnimation(self);
                    self.loadingSpinner.isHidden = true;
                    
                    // Set the max window size to the pixel size of the image
                    self.window!.maxSize = imagePixelSize!;
                    
                    // Set the aspect ratio
                    self.window!.contentAspectRatio = imagePixelSize!;
                    
                    /// The size of the main screen
                    let mainScreenSize : NSSize = NSScreen.main!.frame.size;
                    
                    // If the image is larger than the screen on either width or height...
                    if(mainScreenSize.width < imagePixelSize!.width || mainScreenSize.height < imagePixelSize!.height) {
                        /// The aspect ratio of `image`
                        let aspectRatio = imagePixelSize!.width / imagePixelSize!.height;
                        
                        /// The new width for the window with maintained aspect ratio
                        let width = aspectRatio * (mainScreenSize.height - 200);
                        
                        // Set the windows frame tobe similar to the last one
                        self.window!.setFrame(NSRect(x: self.window!.frame.origin.x, y: self.window!.frame.origin.y, width: width, height: (mainScreenSize.height - 200)), display: false);
                    }
                    // If the image isn't larger than the screen...
                    else {
                        // Set the window size to the size of the image
                        self.window!.setFrame(NSRect(x: self.window!.frame.origin.x, y: self.window!.frame.origin.y, width: imagePixelSize!.width, height: imagePixelSize!.height), display: false);
                    }
                    
                    // Update the window title
                    self.window!.title = NSString(string: path).lastPathComponent;
                    
                    // Update the defaults to match the preferences
                    self.showBackground((NSApp.delegate as! AppDelegate).preferences.viewerDefaultsShowBackground);
                    self.showShadow((NSApp.delegate as! AppDelegate).preferences.viewerDefaultsEnableShadow);
                    
                    // Set `representedImage`
                    self.representedImage = image;
                }
            }
            // If `image` is nil...
            else {
                print("MFImageViewerViewController: No image at \"\(path)\"");
                
                DispatchQueue.main.async {
                    /// Close this window
                    self.window?.close();
                }
            }
        }
    }
    
    /// Zooms out the image view
    @objc func zoomIn() {
        self.imageView.zoomIn(self);
    }
    
    /// Zooms in the image view
    @objc func zoomOut() {
        self.imageView.zoomOut(self);
        
        // Enforce that the image can't be zoomed out smaller than the window
        if(self.imageView.frame.width < self.window!.frame.width || self.imageView.frame.height < self.window!.frame.height) {
            self.zoomToFit();
        }
    }
    
    /// Zooms the image view so it's image fits the image view
    @objc func zoomToFit() {
        self.imageView.zoomImageToFit(self);
        self.imageView.autoresizes = true;
    }
    
    /// Zooms the image view so it's the exact pixel size of the image
    @objc func zoomToActualSize() {
        self.imageView.zoomImageToActualSize(self);
    }
    
    /// Toggles the background of this image viewer
    @objc func toggleBackground() {
        // Show/hide the background based on `backgroundVisible`
        self.showBackground(!self.backgroundVisible);
    }
    
    /// Shows/hides the background of this viewer based on `state`
    ///
    /// - Parameter state: Should the window background be visible?
    func showBackground(_ state : Bool) {
        if(state) {
            self.window!.isOpaque = true;
            self.window!.backgroundColor = NSColor(catalogName: NSColorList.Name(rawValue: "System"), colorName: NSColor.Name(rawValue: "windowBackgroundColor"));
        }
        else {
            self.window!.isOpaque = false;
            self.window!.backgroundColor = NSColor(calibratedWhite: 0, alpha: 0);
        }
        
        self.backgroundVisible = state;
    }
    
    /// Toggles the shadow of this image viewer
    @objc func toggleShadow() {
        // Show/hide the shadow based on `shadowVisible`
        self.showShadow(!self.shadowVisible);
    }
    
    /// Shows/hides the shadow of this viewer based on `state`
    ///
    /// - Parameter state: Should the window shadow be visible?
    func showShadow(_ state : Bool) {
        self.window!.hasShadow = state;
        
        self.shadowVisible = state;
    }
    
    /// Scales this viewer to the pixel size of the image it's displaying
    @objc func scaleToImage() {
        // Set the window frame to the size of the represented image
        self.window?.setContentSize(self.representedImage?.pixelSize ?? self.window!.frame.size);
        
        // Zoom to the actual image size
        self.zoomToActualSize();
    }
    
    /// Does various setup operations for this view controller
    func setup() {
        // Get the window of this view controller
        self.window = NSApp.windows.last!;
        
        // Set the window's delegate
        self.window!.delegate = self;
        
        // Style the window
        self.window!.styleMask.insert(.fullSizeContentView);
        self.window!.standardWindowButton(.closeButton)?.superview?.superview?.isHidden = true;
        self.window!.isMovableByWindowBackground = true;
        
        // Set the image view's scroll view's scroll zoom handler
        self.imageViewScrollView.scrollZoomHandler = { event in
            // Zoom in/out based on the Y scroll delta
            if(event.deltaY < 0) {
                self.zoomOut();
            }
            else {
                self.zoomIn();
            }
        };
        
        // Start the loading spinner
        self.loadingSpinner.startAnimation(self);
        self.loadingSpinner.isHidden = false;
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        // Deinit everything
        self.representedImage = nil;
        self.representedImageSize = nil;
        self.imageView = nil;
        self.window = nil;
        
        return true;
    }
}

