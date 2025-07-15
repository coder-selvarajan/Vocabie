//
//  ExtensionHelper.swift
//  Vocabie
//
//  Created by Selvarajan on 13/03/22.
//

import Foundation

extension Date {
    func displayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
        return dateFormatter.string(from: self)
    }
    
    func displayTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("h:mm a")
        return dateFormatter.string(from: self)
    }
    
    func displayDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d - h:mm a")
        return dateFormatter.string(from: self)
    }
}
