//
//  AppDelegate.swift
//  macfeh
//
//  Created by Ushio on 12/12/16.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Properties
    
    // MARK: - Menu Items
    
    /// File/Open ⌘O
    @IBAction func menuItemOpenAction(_ sender: NSMenuItem) {
        // Prompt for files and open a new viewer
        promptForAndOpenViewer();
    }
    
    /// View/Toggle Background ⌥⌘B
    @IBOutlet weak var menuItemToggleBackground: NSMenuItem!

    /// View/Toggle Shadow ⌥⌘S
    @IBOutlet weak var menuItemToggleShadow: NSMenuItem!
    
    /// View/Scale to Image ⌘1
    @IBOutlet weak var menuItemScaleToImage: NSMenuItem!
    
    
    // MARK: - Functions
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Setup the menu items
        setupMenuItems();
        
        /// The arguments to enumerate for searching for files
        var fileArguments : [String] = ProcessInfo.processInfo.arguments;
        
        // Remove the first argument from `fileArguments`(it's always the path to the binary)
        fileArguments.removeFirst();
        
        // For every argument passed to the application...
        for(_, currentArgument) in fileArguments.enumerated() {
            // If the current argument starts with a /(which will usually mean it's a file)...
            if(currentArgument.hasPrefix("/")) {
                // Open a viewer for the current argument
                openNewViewer(for: currentArgument);
            }
        }
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        // Open a viewer for each file
        for(_, currentFile) in filenames.enumerated() {
            self.openNewViewer(for: currentFile);
        }
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        // Open a viewer for the file
        self.openNewViewer(for: filename);
        
        return true;
    }
    
    /// Prompts for an image from an open panel and displays it in a new viewer
    func promptForAndOpenViewer() {
        /// The open panel for asking for an image
        let openPanel : NSOpenPanel = NSOpenPanel();
        
        // Setup the open panel
        openPanel.allowsMultipleSelection = true;
        openPanel.canChooseDirectories = false;
        openPanel.canChooseFiles = true;
        openPanel.allowedFileTypes = NSImage.imageTypes();
        
        // Run the open panel, and if the user selects "Open"...
        if(Bool(openPanel.runModal() as NSNumber)) {
            // For every opened file...
            for(_, currentFile) in openPanel.urls.enumerated() {
                // Open a new viewer for the current file
                self.openNewViewer(for: currentFile.absoluteString.replacingOccurrences(of: "file://", with: "").removingPercentEncoding!);
            }
        }
    }
    
    /// Opens a new viewer for the image file at the given path
    ///
    /// - Parameter file: The file to display in the viewer
    func openNewViewer(for file : String) {
        /// The `NSWindowController` for the new image viewer
        let imageViewerWindowController : NSWindowController = NSStoryboard(name: "Main", bundle: nil) .instantiateController(withIdentifier: "imageViewerWindowController") as! NSWindowController;
        
        /// The `MFImageViewerViewController` for `imageViewerWindowController`
        let imageViewerViewController : MFImageViewerViewController = (imageViewerWindowController.contentViewController as! MFImageViewerViewController);
        
        // Load and show the window
        imageViewerWindowController.loadWindow();
        imageViewerWindowController.showWindow(self);
        
        // Display the file in the new viewer
        imageViewerViewController.display(image: file);
    }
    
    /// Sets up the actions of all the menu items
    func setupMenuItems() {
        // Setup the menu items
        menuItemToggleBackground.action = #selector(MFImageViewerViewController.toggleBackground);
        menuItemToggleShadow.action = #selector(MFImageViewerViewController.toggleShadow);
        menuItemScaleToImage.action = #selector(MFImageViewerViewController.scaleToImage);
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
