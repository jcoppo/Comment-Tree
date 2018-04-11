//
//  Public Functions.swift
//  Comment Tree
//
//  Created by Jayson Coppo on 4/8/18.
//  Copyright © 2018 Jayson Coppo. All rights reserved.
//

import Foundation
import UIKit

func random(_ lowerLimit: CGFloat, _ upperLimit: CGFloat) -> CGFloat {
    return lowerLimit + CGFloat(arc4random()) / CGFloat(UInt32.max) * (upperLimit - lowerLimit)
}

func randomColor() -> UIColor {
    let r = random(0, 1)
    let g = random(0, 1)
    let b = random(0, 1)
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}
