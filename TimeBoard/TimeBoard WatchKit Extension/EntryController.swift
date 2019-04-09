//
//  EntryController.swift
//  TimeBoard
//
//  Created by Guillermo Suárez Asencio on 16/10/2018.
//  Copyright © 2018 Guillermo Suárez Asencio. All rights reserved.
//

import WatchKit
import Foundation

class EntryController: WKInterfaceController {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        showWatchFace()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
//        presentController(withName: "InterfaceController", context: nil)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func tappedButton() {
        showWatchFace()
    }
    
    func showWatchFace() {
        presentController(withName: "InterfaceController", context: nil)
    }
}
