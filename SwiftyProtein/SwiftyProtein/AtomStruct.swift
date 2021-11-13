//
//  AtomStruct.swift
//  SwiftyProtein
//
//  Created by Flash Jessi on 11/11/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import Foundation
import UIKit

struct AtomPesponse {
    let atoms: [Atom]
    let coordinates: [[(x: Float, y: Float, z: Float)]]
}

struct Atom {
    let number: Int
    let x: Float
    let y: Float
    let z: Float
    let name: String
    var color: UIColor {
        return getColor()
    }
    
    func getColor() -> UIColor {
        switch name {
        case "H":
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case "C":
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case "O":
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case "N":
            return #colorLiteral(red: 0.1975915432, green: 0.0456796512, blue: 1, alpha: 1)
        case "S":
            return #colorLiteral(red: 0.9504409432, green: 0.8962527514, blue: 0, alpha: 1)
        case "P":
            return #colorLiteral(red: 0.9810149074, green: 0.724645555, blue: 0.2781099081, alpha: 1)
        case "F":
            return #colorLiteral(red: 0.5415076613, green: 0.8902394176, blue: 0.4652535915, alpha: 1)
        case "Cl":
            return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case "Br":
            return #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        case "I":
            return #colorLiteral(red: 0.2862102687, green: 0.04713460058, blue: 0.6685710549, alpha: 1)
        case "Co":
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case "Fe":
            return #colorLiteral(red: 0.88305372, green: 0.553016305, blue: 0.1700735986, alpha: 1)
        case "Ni":
            return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case "Cu":
            return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case "B":
            return #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        default:
            return #colorLiteral(red: 0.9798377156, green: 0.4781311154, blue: 0.9721526504, alpha: 1)
        }
    }
}
