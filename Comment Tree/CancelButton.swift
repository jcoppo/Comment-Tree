//
//  CancelButton.swift
//  Comment Tree
//
//  Created by Jayson Coppo on 4/10/18.
//  Copyright © 2018 Jayson Coppo. All rights reserved.
//

//NOT USED//

import Foundation
import UIKit

class CancelButton: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = UIColor.gray
        
        let length: CGFloat = 10
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: center.x-length, y: center.y-length))
        linePath.addLine(to: CGPoint(x: center.x+length, y: center.y+length))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.zPosition = -1
        layer.addSublayer(shapeLayer)
        
        let linePath2 = UIBezierPath()
        linePath2.move(to: CGPoint(x: center.x+length, y: center.y-length))
        linePath2.addLine(to: CGPoint(x: center.x-length, y: center.y+length))
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = linePath2.cgPath
        shapeLayer2.strokeColor = UIColor(white: 0.2, alpha: 1.0).cgColor
        shapeLayer2.lineWidth = 5
        shapeLayer2.zPosition = -1
        layer.addSublayer(shapeLayer2)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
