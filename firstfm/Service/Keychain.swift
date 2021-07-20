import Foundation
import Valet

func getValet() -> Valet {
    return Valet.valet(with: Identifier(nonEmpty: "firstfm")!, accessibility: .whenUnlocked)
}
