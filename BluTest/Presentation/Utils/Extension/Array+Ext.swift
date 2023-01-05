//
//  Array.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

extension Array {
    init(repeatingExpression expression: @autoclosure (() -> Element), count: Int) {
        var temp = [Element]()
        for _ in 0..<count {
            temp.append(expression())
        }
        self = temp
    }
}
