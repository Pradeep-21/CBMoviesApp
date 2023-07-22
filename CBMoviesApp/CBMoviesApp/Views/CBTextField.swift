//
//  CBTextField.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import UIKit

class CBTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        customise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customise()
    }

    // Customise the placeholder text color
    func customise() {
        let placeholderText = "Search"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.CCSearchTextTint, // Change this color to the desired color
            .font: UIFont.systemFont(ofSize: 16) // Change the font size if needed
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        // Assign the attributed placeholder to the searchTextField
        self.attributedPlaceholder = attributedPlaceholder
    }
}
