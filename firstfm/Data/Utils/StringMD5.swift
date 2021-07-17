//
//  StringMD5.swift
//  firstfm
//
//  Created by Stanislas Lange on 17/07/2021.
//

import Foundation
import CommonCrypto

// Needed to compute LastFM api Signature
// https://www.last.fm/api/mobileauth

extension String {
    var md5Value: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let d = self.data(using: .utf8) {
            _ = d.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)

                return ""
            }
        }

        return (0 ..< length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
