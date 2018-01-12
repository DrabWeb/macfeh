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
    var preferences: Preferences = Preferences();

    @IBAction func menuItemOpenAction(_ sender: NSMenuItem) {
        promptForAndOpenViewer();
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
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
        let openPanel: NSOpenPanel = NSOpenPanel();

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
            if let imageViewer = windowController.contentViewController as? ImageViewerController {
                windowController.loadWindow();
                windowController.showWindow(self);
                imageViewer.display(image: file);
            }
        }
    }

    func loadPreferences() {
        if preferencesLoaded {
            return;
        }

        preferences.load();
        preferencesLoaded = true;
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        preferences.save();
    }
}
