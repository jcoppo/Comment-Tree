//
//  TapView.swift
//  Comment Tree
//
//  Created by Jayson Coppo on 4/8/18.
//  Copyright © 2018 Jayson Coppo. All rights reserved.
//

import UIKit

class TapView: UIView {
    
    var createX = Int()
    var createY = Int()
    var direction = String()

    init(createX: Int, createY: Int, direction: String) {
        let frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        super.init(frame: frame)
        
        self.createX = createX
        self.createY = createY
        self.direction = direction
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2,y: frame.height/2), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2.0

        layer.addSublayer(shapeLayer)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
