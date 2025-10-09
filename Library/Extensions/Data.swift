
//
//  Data.swift
//  GlucoseDirect
//

import Foundation

extension Data {
    var hex: String {
        map { String(format: "%02X", $0) }.joined(separator: " ")
    }

    var utf8: String {
        String(decoding: self, as: UTF8.self)
    }

    private static let hexAlphabet = "0123456789abcdef".unicodeScalars.map { $0 }

    public func hexEncodedString() -> String {
        String(self.reduce(into: "".unicodeScalars) { result, value in
            result.append(Data.hexAlphabet[Int(value / 16)])
            result.append(Data.hexAlphabet[Int(value % 16)])
        })
    }

    init?(hexString: String) {
        let length = hexString.count / 2
        var data = Data(capacity: length)

        for i in 0 ..< length {
            let j = hexString.index(hexString.startIndex, offsetBy: i * 2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j ..< k]

            if var byte = UInt8(bytes, radix: 16) {
                data.append(&byte, count: 1)
            } else {
                return nil
            }
        }

        self = data
    }
}
