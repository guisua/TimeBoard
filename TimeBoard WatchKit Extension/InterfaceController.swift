//
//  InterfaceController.swift
//  TimeBoard WatchKit Extension
//
//  Created by Guillermo Suárez Asencio on 16/10/2018.
//  Copyright © 2018 Guillermo Suárez Asencio. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var almostLabel: WKInterfaceLabel!
    @IBOutlet weak var aboutLabel: WKInterfaceLabel!
    @IBOutlet weak var fiveLabel: WKInterfaceLabel!
    @IBOutlet weak var tenLabel: WKInterfaceLabel!
    @IBOutlet weak var quarterLabel: WKInterfaceLabel!
    @IBOutlet weak var twentyLabel: WKInterfaceLabel!
    @IBOutlet weak var halfLabel: WKInterfaceLabel!
    @IBOutlet weak var pastLabel: WKInterfaceLabel!
    @IBOutlet weak var toLabel: WKInterfaceLabel!
    @IBOutlet weak var hourLabel: WKInterfaceLabel!
    @IBOutlet weak var batteryLabel: WKInterfaceLabel!
    
    var timer: Timer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        setTitle(" ")
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
    }
    
    override func didAppear() {
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        refreshUI()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { (timer) in
            self.refreshUI()
        })
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        timer?.invalidate()
    }
    
    func refreshUI() {
        print("refreshing UI")
        var level : Float = 0.12
        if WKInterfaceDevice.current().batteryState != .unknown {
            level = WKInterfaceDevice.current().batteryLevel
        }
        batteryLabel.setText(String(format: "%d%%", Int(level*100)))
        if level >= 0.5 {
            batteryLabel.setTextColor(UIColor(red: 156/255, green: 208/255, blue: 10/255, alpha: 1))
        }
        else if level >= 0.2 {
            batteryLabel.setTextColor(UIColor(red: 255/255, green: 195/255, blue: 93/255, alpha: 1))
        }
        else {
            batteryLabel.setTextColor(UIColor(red: 255/255, green: 55/255, blue: 95/255, alpha: 1))
        }
        
        let now = Date()
        let components = Calendar.current.dateComponents(in: TimeZone.current, from: now)
        guard let hour = components.hour else { return }
        guard let min = components.minute else { return }
        
        let roundMin = Int(round(Float(min)/5)*5)%60
        let roundHour = hour + (min > 32 ? 1 : 0)
        
        let hourString = stringFor(hour: roundHour)
        let activeAlpha : CGFloat = 1
        let inactiveAlpha : CGFloat = 0.1
        
        // Exactly
        aboutLabel.setAlpha(min > roundMin  && min <= 57 ? activeAlpha : inactiveAlpha)
        // Almost
        almostLabel.setAlpha(min < roundMin || min > 57 ? activeAlpha : inactiveAlpha)
        // fiveLabel
        fiveLabel.setAlpha(roundMin == 5 || roundMin == 25 || roundMin == 35 || roundMin == 55 ? activeAlpha : inactiveAlpha)
        // tenLabel
        tenLabel.setAlpha(roundMin == 10 || roundMin == 50 ? activeAlpha : inactiveAlpha)
        // quarterLabel
        quarterLabel.setAlpha(roundMin == 15 || roundMin == 45 ? activeAlpha : inactiveAlpha)
        // twentyLabel
        twentyLabel.setAlpha(roundMin == 20 || roundMin == 25 || roundMin == 35 || roundMin == 40 ? activeAlpha : inactiveAlpha)
        // halfLabel
        halfLabel.setAlpha(roundMin == 30 ? activeAlpha : inactiveAlpha)
        // past to labels
        pastLabel.setAlpha(roundMin <= 30 && roundMin != 0 ? activeAlpha : inactiveAlpha)
        toLabel.setAlpha(roundMin > 30 && roundMin != 0 ? activeAlpha : inactiveAlpha)
        
        hourLabel.setText(hourString)
        
        print(hour, min)
        print(roundHour, roundMin)
    }
    
    func stringFor(hour: Int) -> String {
        switch hour {
        case 0,24:
            return "Midnight"
        case 1,13:
            return "One"
        case 2,14:
            return "Two"
        case 3,15:
            return "Three"
        case 4,16:
            return "Four"
        case 5,17:
            return "Five"
        case 6,18:
            return "Six"
        case 7,19:
            return "Seven"
        case 8,20:
            return "Eight"
        case 9,21:
            return "Nine"
        case 10,22:
            return "Ten"
        case 11,23:
            return "Eleven"
        case 12:
            return "Twelve"
        default:
            return "[unknown]"
        }
    }

}

public extension UIColor {
    /// The RGBA components associated with a `UIColor` instance.
    var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let components = self.cgColor.components!
        
        switch components.count == 2 {
        case true : return (r: components[0], g: components[0], b: components[0], a: components[1])
        case false: return (r: components[0], g: components[1], b: components[2], a: components[3])
        }
    }
    
    /**
     Returns a `UIColor` by interpolating between two other `UIColor`s.
     - Parameter fromColor: The `UIColor` to interpolate from
     - Parameter toColor:   The `UIColor` to interpolate to (e.g. when fully interpolated)
     - Parameter progress:  The interpolation progess; must be a `CGFloat` from 0 to 1
     - Returns: The interpolated `UIColor` for the given progress point
     */
    static func interpolate(from fromColor: UIColor, to toColor: UIColor, with progress: CGFloat) -> UIColor {
        let fromComponents = fromColor.components
        let toComponents = toColor.components
        
        let r = (1 - progress) * fromComponents.r + progress * toComponents.r
        let g = (1 - progress) * fromComponents.g + progress * toComponents.g
        let b = (1 - progress) * fromComponents.b + progress * toComponents.b
        let a = (1 - progress) * fromComponents.a + progress * toComponents.a
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
