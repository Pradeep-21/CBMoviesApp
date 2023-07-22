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
    
    // Generic function to extract unique strings from comma-separated strings
    class func extractUniqueValues<T>(from items: [CBMovies], keyPath: KeyPath<CBMovies, String?>) -> [T] where T: Hashable, T: LosslessStringConvertible {
        var uniqueValues = Set<String>()
        for movie in items {
            if let value = movie[keyPath: keyPath] {
                let components = value.split(separator: ",")
                uniqueValues.formUnion(components.lazy.map { $0.trimmingCharacters(in: .whitespaces) })
            }
        }
        return uniqueValues.compactMap { T($0) }
    }
    
    class func configureSearchIcon() -> UIView? {
        let imageView = UIImageView(frame: CGRect(x: 5, y: 10, width: 30, height: 20))
        imageView.image = UIImage(systemName: "magnifyingglass")
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0,width: 40, height: 40))
        imageView.tintColor = .gray
        imageContainerView.addSubview(imageView)
        return imageContainerView
    }
    
    class func getExactLabelHeight(for name: String, with font: UIFont, andLabelWidth width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]

        let rect = NSString(string: name).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return rect.height
    }
}
