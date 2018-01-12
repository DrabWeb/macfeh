//
//  AppDelegate.swift
//  macfeh
//
//  Created by Ushio on 12/12/16.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var preferencesLoaded: Bool = false;
    var preferences: MFPreferencesObject = MFPreferencesObject();

    @IBOutlet private weak var menuItemToggleBackground: NSMenuItem!
    @IBOutlet private weak var menuItemToggleShadow: NSMenuItem!
    @IBOutlet private weak var menuItemActualSize: NSMenuItem!
    @IBOutlet private weak var menuItemZoomToFit: NSMenuItem!
    @IBOutlet private weak var menuItemZoomIn: NSMenuItem!
    @IBOutlet private weak var menuItemZoomOut: NSMenuItem!
    @IBOutlet private weak var menuItemScaleWindowToImage: NSMenuItem!

    @IBAction func menuItemOpenAction(_ sender: NSMenuItem) {
        promptForAndOpenViewer();
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        setupMenuItems();
        loadPreferences();
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        loadPreferences();

        for (_, currentFile) in filenames.enumerated() {
            self.openNewViewer(for: currentFile);
        }
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        loadPreferences();
        openNewViewer(for: filename);
        
        return true;
    }

    func promptForAndOpenViewer() {
        let openPanel : NSOpenPanel = NSOpenPanel();

        openPanel.allowsMultipleSelection = true;
        openPanel.canChooseDirectories = false;
        openPanel.canChooseFiles = true;
        openPanel.allowedFileTypes = NSImage.imageTypes;

        if openPanel.runModal() == .OK {
            for (_, currentFile) in openPanel.urls.enumerated() {
                openNewViewer(for: currentFile.absoluteString.replacingOccurrences(of: "file://", with: "").removingPercentEncoding!);
            }
        }
    }

    func openNewViewer(for file: String) {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil);

        if let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "imageViewerWindowController")) as? NSWindowController {
            if let imageViewer = windowController.contentViewController as? MFImageViewerViewController {
                windowController.loadWindow();
                windowController.showWindow(self);
                imageViewer.display(image: file);
            }
        }
    }

    func setupMenuItems() {
        //todo: do these properly through interface builder
        menuItemToggleBackground.action = #selector(MFImageViewerViewController.toggleBackground);
        menuItemToggleShadow.action = #selector(MFImageViewerViewController.toggleShadow);
        menuItemActualSize.action = #selector(MFImageViewerViewController.zoomToActualSize);
        menuItemZoomToFit.action = #selector(MFImageViewerViewController.zoomToFit);
        menuItemZoomIn.action = #selector(MFImageViewerViewController.zoomIn);
        menuItemZoomOut.action = #selector(MFImageViewerViewController.zoomOut);
        menuItemScaleWindowToImage.action = #selector(MFImageViewerViewController.scaleWindowToImage);
    }

    func savePreferences() {
        let data = NSKeyedArchiver.archivedData(withRootObject: preferences);
        UserDefaults.standard.set(data, forKey: "preferences");
        UserDefaults.standard.synchronize();
    }

    func loadPreferences() {
        if preferencesLoaded {
            return;
        }

        if let data = UserDefaults.standard.object(forKey: "preferences") as? Data {
            preferences = (NSKeyedUnarchiver.unarchiveObject(with: data) as! MFPreferencesObject);
            preferencesLoaded = true;
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        savePreferences();
    }
}
