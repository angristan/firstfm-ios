//
//  Keychain.swift
//  firstfm
//
//  Created by Stanislas Lange on 19/07/2021.
//

import Foundation
import Valet

func getValet() -> Valet {
    return Valet.valet(with: Identifier(nonEmpty: "firstfm")!, accessibility: .whenUnlocked)
}
