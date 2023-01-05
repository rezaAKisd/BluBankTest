//
//  Encodable+Ext.swift
//  BluTest
//
//  Created by reza akbari on 1/5/23.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let josnData = try JSONSerialization.jsonObject(with: data)
            return josnData as? [String: Any] ?? [:]
        } catch {
            return [:]
        }
    }
}
