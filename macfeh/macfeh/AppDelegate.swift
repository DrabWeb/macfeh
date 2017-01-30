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
    
    /// The global preferences object for macfeh
    var preferences : MFPreferencesObject = MFPreferencesObject();
    
    /// Have the preferences already been loaded?
    private var preferencesLoaded : Bool = false;
    
    
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
    
    /// View/Actual Size ⌘1
    @IBOutlet weak var menuItemActualSize: NSMenuItem!
    
    /// View/Zoom to Fit ⌘0
    @IBOutlet weak var menuItemZoomToFit: NSMenuItem!
    
    /// View/Zoom In ⌘=
    @IBOutlet weak var menuItemZoomIn: NSMenuItem!
    
    /// View/Zoom Out ⌘-
    @IBOutlet weak var menuItemZoomOut: NSMenuItem!
    
    /// View/Scale to Image ⌘2
    @IBOutlet weak var menuItemScaleToImage: NSMenuItem!
    
    
    // MARK: - Functions
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Setup the menu items
        setupMenuItems();
        
        // Load the preferences
        loadPreferences();
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        // Make sure the preferences are loaded
        loadPreferences();
        
        // Open a viewer for each file
        for(_, currentFile) in filenames.enumerated() {
            self.openNewViewer(for: currentFile);
        }
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        // Make sure the preferences are loaded
        loadPreferences();
        
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
        if(openPanel.runModal() == NSModalResponseOK) {
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
        weak var imageViewerWindowController : NSWindowController! = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "imageViewerWindowController") as! NSWindowController;
        
        /// The `MFImageViewerViewController` for `imageViewerWindowController`
        weak var imageViewerViewController : MFImageViewerViewController! = (imageViewerWindowController.contentViewController as! MFImageViewerViewController);
        
        // Load and show the window
        imageViewerWindowController.loadWindow();
        imageViewerWindowController.showWindow(self);
        
        // Display the file in the new viewer
        imageViewerViewController.display(image: file);
        
        // Free the memory from `imageViewerWindowController` and `imageViewerViewController`
        imageViewerWindowController = nil;
        imageViewerViewController = nil;
    }
    
    /// Sets up the actions of all the menu items
    func setupMenuItems() {
        // Setup the menu items
        menuItemToggleBackground.action = #selector(MFImageViewerViewController.toggleBackground);
        menuItemToggleShadow.action = #selector(MFImageViewerViewController.toggleShadow);
        menuItemActualSize.action = #selector(MFImageViewerViewController.zoomToActualSize);
        menuItemZoomToFit.action = #selector(MFImageViewerViewController.zoomToFit);
        menuItemZoomIn.action = #selector(MFImageViewerViewController.zoomIn);
        menuItemZoomOut.action = #selector(MFImageViewerViewController.zoomOut);
        menuItemScaleToImage.action = #selector(MFImageViewerViewController.scaleToImage);
    }
    
    /// Saves the preferences
    func savePreferences() {
        /// The data for the preferences object
        let data = NSKeyedArchiver.archivedData(withRootObject: preferences);
        
        // Set the standard user defaults preferences key to that data
        UserDefaults.standard.set(data, forKey: "preferences");
        
        // Synchronize the data
        UserDefaults.standard.synchronize();
    }
    
    /// Loads the preferences
    func loadPreferences() {
        // If the preferences have already been loaded don't load them
        if(preferencesLoaded) {
            return;
        }
        
        // If we have any data to load...
        if let data = UserDefaults.standard.object(forKey: "preferences") as? Data {
            // Set the preferences object to the loaded object
            preferences = (NSKeyedUnarchiver.unarchiveObject(with: data) as! MFPreferencesObject);
            
            // Say the preferences have been loaded
            self.preferencesLoaded = true;
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Save the preferences
        savePreferences();
    }
}
