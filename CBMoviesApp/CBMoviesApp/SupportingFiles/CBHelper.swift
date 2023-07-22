//
//  CBHelper.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import UIKit

class CBHelper {
    
    class func isStringContainingValue(_ targetString: String, _ desiredValue: String) -> Bool {
        let components = targetString.components(separatedBy: ",")
        return components.contains { $0.range(of: desiredValue, options: .caseInsensitive) != nil }
    }
    
    class func defaultImage() -> UIImage? {
        return UIImage(named: "defaultImage")
    }
    
}
