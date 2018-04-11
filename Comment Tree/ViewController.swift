//
//  ViewController.swift
//  Comment Tree
//
//  Created by Jayson Coppo on 4/8/18.
//  Copyright © 2018 Jayson Coppo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    
//    var worldView = UIView() //parent view
    let worldSize: CGFloat = 20 //number of comments allowed across world
    var worldPosition = CGPoint() //for panning
    var worldScale: CGFloat = 1 // for zooming
    var minZoomScale: CGFloat = 0.15
    var maxZoomScale: CGFloat = 1.1
    let commentSpacing: CGFloat = 180 //from the center pf each comment
    var tapViewArray = [TapView]()
    var commentArray = [CommentData]()
    var commentViewArray = [CommentView]()
    var currentCommentEdited: CommentView?
    var editMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.frame.origin.x += 100
        //the parent view the holds everything, it can pan and zoom
//        worldView = UIView(frame: CGRect(x: 0, y: 0, width: worldSize*commentSpacing, height: worldSize*commentSpacing))
//        worldView.backgroundColor = UIColor.clear
//        worldView.layer.borderColor = UIColor(white: 0.4, alpha: 1).cgColor
//        worldView.layer.borderWidth = 4
//        view.addSubview(worldView)
        
//        worldView.center = view.center
//        worldPosition = worldView.frame.origin
        
        //root of tree
//        createComment(x: 0, y: 0, direction: "none")
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.addGestureRecognizer(panGesture)
        
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
//        view.addGestureRecognizer(pinchGesture)
        //we'll fix the pinch-zoom later
        
        //example
        let exampleTree = ExampleTree()
        renderCommentTreefromData(comments: exampleTree.commentArray)
        
    }
    
    func renderCommentTreefromData(comments: [CommentData]) {
        
        commentArray = comments
        
        //position comment using their x and y relative to vew.center
//        let worldCenter = CGPoint(x: worldView.frame.width/2, y: worldView.frame.height/2)
//        let spacing = commentSpacing*worldScale
        
        for comment in comments {
            
            //put comment it its place using its x and y
            let commentView = CommentView(username: comment.username, text: comment.text, x: comment.x, y: comment.y, editMode: false)
            commentViewArray.append(commentView)
            commentView.center.x = view.center.x + commentSpacing*CGFloat(comment.x)
            commentView.center.y = view.center.y - commentSpacing*CGFloat(comment.y)
            view.addSubview(commentView)
            
            //draw line from center of comment to center to its respond comment
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: commentView.center.x, y: commentView.center.y))
            linePath.addLine(to: CGPoint(
                x: commentView.center.x+commentSpacing*CGFloat(comment.xRespond-comment.x),
                y: commentView.center.y-commentSpacing*CGFloat(comment.yRespond-comment.y)))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = linePath.cgPath
            shapeLayer.strokeColor = UIColor(white: 0.7, alpha: 1.0).cgColor
            shapeLayer.lineWidth = 10.0
            shapeLayer.zPosition = -1
            view.layer.addSublayer(shapeLayer)
            
            //make tapViews (bubbles)
        }
        
        updateTapViews()
        
    }
    
    func updateTapViews() {
        
        //remove tapViews and empty array
        for tapView in tapViewArray {
            tapView.removeFromSuperview()
        }
        tapViewArray.removeAll()
        
        //with each comment check Up, Down, Right, Left for another comment, if it exists, dont make a tapView, otherwise do make one
        
        for commentView in commentViewArray {
            
            let tapDistancefromView: CGFloat = 100
            
            //top
            var canMakeViewTop = true
            for commentChecked in commentViewArray {
                if commentChecked.x == commentView.x && commentChecked.y == commentView.y+1 {
                    canMakeViewTop = false
                }
            }
            if canMakeViewTop {
                let tapViewTop = TapView(createX: commentView.x, createY: commentView.y+1, direction: "U")
                view.addSubview(tapViewTop)
                tapViewTop.center.x = commentView.center.x
                tapViewTop.center.y = commentView.center.y - tapDistancefromView
                tapViewArray.append(tapViewTop)
                
                let tapGestureTop = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tapViewTop.addGestureRecognizer(tapGestureTop)
            }
            
            //bottom
            var canMakeViewBottom = true
            for commentChecked in commentViewArray {
                if commentChecked.x == commentView.x && commentChecked.y == commentView.y-1 {
                    canMakeViewBottom = false
                }
            }
            if canMakeViewBottom {
                let tapViewBottom = TapView(createX: commentView.x, createY: commentView.y-1, direction: "D")
                view.addSubview(tapViewBottom)
                tapViewBottom.center.x = commentView.center.x
                tapViewBottom.center.y = commentView.center.y + tapDistancefromView
                tapViewArray.append(tapViewBottom)
                
                let tapGestureBottom = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tapViewBottom.addGestureRecognizer(tapGestureBottom)
            }
            
            //right
            var canMakeViewRight = true
            for commentChecked in commentViewArray {
                if commentChecked.x == commentView.x+1 && commentChecked.y == commentView.y {
                    canMakeViewRight = false
                }
            }
            if canMakeViewRight {
                let tapViewRight = TapView(createX: commentView.x+1, createY: commentView.y, direction: "R")
                view.addSubview(tapViewRight)
                tapViewRight.center.x = commentView.center.x + tapDistancefromView
                tapViewRight.center.y = commentView.center.y
                tapViewArray.append(tapViewRight)
                
                let tapGestureRight = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tapViewRight.addGestureRecognizer(tapGestureRight)
            }
            
            //left
            var canMakeViewLeft = true
            for commentChecked in commentViewArray {
                if commentChecked.x == commentView.x-1 && commentChecked.y == commentView.y {
                    canMakeViewLeft = false
                }
            }
            if canMakeViewLeft {
                let tapViewLeft = TapView(createX: commentView.x-1, createY: commentView.y, direction: "L")
                view.addSubview(tapViewLeft)
                tapViewLeft.center.x = commentView.center.x - tapDistancefromView
                tapViewLeft.center.y = commentView.center.y
                tapViewArray.append(tapViewLeft)
                
                let tapGestureLeft = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tapViewLeft.addGestureRecognizer(tapGestureLeft)
            }

        }
    }
    
    func createComment(x: Int, y: Int, direction: String) {
        
        let commentView = CommentView(username: "comment.username", text: "comment.text", x: x, y: y, editMode: true)
        view.addSubview(commentView)
        commentViewArray.append(commentView)
        
        //position comment using their x and y relative to worldView center
        let worldCenter = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
//        let spacing = commentSpacing*worldScale
        commentView.center.x = worldCenter.x + commentSpacing*CGFloat(commentView.x)
        commentView.center.y = worldCenter.y - commentSpacing*CGFloat(commentView.y)
        
        updateTapViews()
        
        commentView.textField.delegate = self 
        commentView.textField.becomeFirstResponder()
        
        currentCommentEdited = commentView
        
        //move world so that new comment is in center
        let goalPoint = CGPoint(x: view.center.x, y: view.center.y-100)
        print(goalPoint)
        print(commentView.center.x)
//        view.frame.origin.x += goalPoint.x - commentView.center.x
//        view.frame.origin.y += goalPoint.y - commentView.center.y
//        worldPosition = view.frame.origin

        UIView.animate(
            withDuration: 5,
            delay: 0,
            options: .curveLinear,
            animations: {
             
                
        },
            completion: {
                _ in
        })

        

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        //pressing Return
        if(text == "\n") {
            textView.resignFirstResponder()
            currentCommentEdited?.submitPost()
            editMode = false
            return false
        }
        else
        {
            return true
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        if editMode == false {
            
            editMode = true 
            
            let tapView = sender.view as! TapView
            tapView.removeFromSuperview()
            
            print("haha \(tapView.createX, tapView.createY)")
            print("lol \(tapView.direction)")
            
            createComment(x: tapView.createX, y: tapView.createY, direction: tapView.direction)
            
            //make connecting rod as a line drawing through the center of the where tapView was
            let linePath = UIBezierPath()
            
            switch tapView.direction {
            case "U":
                linePath.move(to: CGPoint(x: tapView.center.x, y: tapView.center.y+commentSpacing/2))
                linePath.addLine(to: CGPoint(x: tapView.center.x, y: tapView.center.y-commentSpacing/2))
            case "D":
                linePath.move(to: CGPoint(x: tapView.center.x, y: tapView.center.y-commentSpacing/2))
                linePath.addLine(to: CGPoint(x: tapView.center.x, y: tapView.center.y+commentSpacing/2))
            case "R":
                linePath.move(to: CGPoint(x: tapView.center.x-commentSpacing/2, y: tapView.center.y))
                linePath.addLine(to: CGPoint(x: tapView.center.x+commentSpacing/2, y: tapView.center.y))
            case "L":
                linePath.move(to: CGPoint(x: tapView.center.x+commentSpacing/2, y: tapView.center.y))
                linePath.addLine(to: CGPoint(x: tapView.center.x-commentSpacing/2, y: tapView.center.y))
            default:
                break
            }
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = linePath.cgPath
            shapeLayer.strokeColor = UIColor(white: 0.7, alpha: 1.0).cgColor
            shapeLayer.lineWidth = 10.0
            shapeLayer.zPosition = -1
            view.layer.addSublayer(shapeLayer)
            
        }
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        view.frame.origin.x = worldPosition.x + translation.x
        view.frame.origin.y = worldPosition.y + translation.y
        
        if sender.state == .ended {
            worldPosition = view.frame.origin
        }
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        
        let pinchScale = sender.scale
        
        if worldScale*pinchScale > minZoomScale && worldScale*pinchScale < maxZoomScale {
            view.transform = view.transform.scaledBy(x: worldScale*pinchScale, y: worldScale*pinchScale)
            
            if sender.state == .ended {
                worldScale = worldScale*pinchScale
                print("wordScale \(worldScale)")
            }
        }
        
        print("pinch \(pinchScale)")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

