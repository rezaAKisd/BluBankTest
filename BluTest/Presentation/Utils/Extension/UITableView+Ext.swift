//
//  UITableView+Ext.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import UIKit

extension UITableView {
    func dequeueCellAtIndexPath<T: UITableViewCell>(indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as? T {
            return cell
        } else {
            fatalError("cell with \"\(T.reuseId)\" identifier is not registered!")
        }
    }
}
