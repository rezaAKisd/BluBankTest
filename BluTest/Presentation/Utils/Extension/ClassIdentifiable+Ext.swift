//
//  ClassIdentifiable.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import UIKit

protocol ClassIdentifiable: AnyObject {
    static var reuseId: String { get }
}

extension ClassIdentifiable {
    static var reuseId: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ClassIdentifiable {}
