//
//  Comment.swift
//  Comment Tree
//
//  Created by Jayson Coppo on 4/8/18.
//  Copyright © 2018 Jayson Coppo. All rights reserved.
//

import Foundation
import UIKit

class CommentView: UIView {
    
    var label = UILabel()
    var textField = UITextView()
    
    var username = String()
    var text = String()
    var x = Int()
    var y = Int()
    var isRoot = Bool()
    var editMode = true

    init(username: String, text: String, x: Int, y: Int, editMode: Bool) {
        
        var frame = CGRect()
        
        if (x, y) == (0, 0) {
            isRoot = true
            frame = CGRect(x: 0, y: 0, width: 165, height: 165)
        } else {
            isRoot = false
            frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        }
        
        super.init(frame: frame)
        
        self.username = username
        self.text = text
        self.x = x
        self.y = y
        self.editMode = editMode
        
        if isRoot {
            backgroundColor = .white
            let hue = random(0, 1)
            layer.borderColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1).cgColor
            layer.borderWidth = 8
            layer.cornerRadius = 15
        } else {
            let hue = random(0, 1)
            backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
            layer.cornerRadius = 10
        }
    
        layer.masksToBounds = true
        
        label = UILabel(frame: CGRect(x: 10, y: 10, width: frame.width-20, height: frame.height-20))
        label.font = UIFont(name: "", size: 4)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        
        textField = UITextView(frame: CGRect(x: 10, y: 10, width: frame.width-20, height: frame.height-20))
        textField.font = UIFont(name: "", size: 10)
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.returnKeyType = UIReturnKeyType.done
        
        if editMode == false {
            addSubview(label)
        } else {
            addSubview(textField)            
        }
    }
    
    func submitPost() {
        
        editMode = false
        
        textField.removeFromSuperview()
        
        label.text = textField.text
        addSubview(label)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
