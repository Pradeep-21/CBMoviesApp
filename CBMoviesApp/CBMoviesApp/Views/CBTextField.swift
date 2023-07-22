//
//  CBTextField.swift
//  CBMoviesApp
//
//  Created by Pradeep Selvaraj on 22/07/23.
//

import UIKit

class CBTextField: UITextField {

    // MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customise()
    }

    // MARK: - Custom Methods
    
    func customise() {
        let placeholderText = "Search movies by title/actor/genre/directer.."
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.CCSearchTextTint,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        // Assign the attributed placeholder to the searchTextField
        self.attributedPlaceholder = attributedPlaceholder
    }
}
