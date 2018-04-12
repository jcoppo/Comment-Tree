//
//  ViewController.swift
//  Comment Tree
//
//  Created by Jayson Coppo on 4/8/18.
//  Copyright © 2018 Jayson Coppo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    var scrollView = UIScrollView() //parent view
    let worldSize: CGFloat = 5 //number of comments allowed across world
    var worldPosition = CGPoint() //for panning
    var worldScale: CGFloat = 1 // for zooming
    var minZoomScale: CGFloat = 0.15
    var maxZoomScale: CGFloat = 1.1
    let commentSpacing: CGFloat = 180 //from the center pf each comment
    var tapViewArray = [TapView]()
    var commentArray = [CommentData]()
    var commentViewArray = [CommentView]()
    var currentCommentEdited: CommentView?
    var currentConnectingRod = CAShapeLayer()
    var editMode = false
    var cancelButton = CancelButton()
    var emptyCommentMessage = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the parent view the holds everything, it can pan and zoom
//        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: worldSize*commentSpacing, height: worldSize*commentSpacing))
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollView.contentSize = CGSize(width: 1000, height: 1000)
//        scrollView.backgroundColor = UIColor.clear
//        scrollView.layer.borderColor = UIColor(white: 0.4, alpha: 1).cgColor
//        scrollView.layer.borderWidth = 4
        scrollView.delegate = self
        scrollView.contentOffset.x = scrollView.contentSize.width/2 - view.frame.width/2
        scrollView.contentOffset.y = scrollView.contentSize.height/2 - view.frame.height/2
        view.addSubview(scrollView)
        
        //root of tree
//        createComment(x: 0, y: 0, direction: "none")
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
//        view.addGestureRecognizer(panGesture)
        
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
//        view.addGestureRecognizer(pinchGesture)
        //we'll fix the pinch-zoom later
        
        //example
        let exampleTree = ExampleTree()
        renderCommentTreefromData(comments: exampleTree.commentArray)
        
        cancelButton = CancelButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let tapGestureCancel = UITapGestureRecognizer(target: self, action: #selector(handleTapCancel(sender:)))
        cancelButton.addGestureRecognizer(tapGestureCancel)
        //add button later in createComment()
        
        //taping the view
        let tapGestureView = UITapGestureRecognizer(target: self, action: #selector(handleTapView(sender:)))
        view.addGestureRecognizer(tapGestureView)
        
        emptyCommentMessage = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        emptyCommentMessage.font = UIFont(name: "", size: 10)
        emptyCommentMessage.textAlignment = .center
        emptyCommentMessage.numberOfLines = 0
        emptyCommentMessage.text = "Oh no, your comment is empty!"
        //added to view when pressing the done key in textView(...)
        
    }
    
    func renderCommentTreefromData(comments: [CommentData]) {
        
        commentArray = comments
        
        //position comment using their x and y relative to vew.center
//        let worldCenter = CGPoint(x: scrollView.frame.width/2, y: scrollView.frame.height/2)
        let scrollviewCenter = CGPoint(x: scrollView.contentSize.width/2, y: scrollView.contentSize.height/2)
        
        for comment in comments {
            
            //put comment it its place using its x and y
            let commentView = CommentView(username: comment.username, text: comment.text, x: comment.x, y: comment.y, editMode: false)
            commentViewArray.append(commentView)
            commentView.center.x = scrollviewCenter.x + commentSpacing*CGFloat(comment.x)
            commentView.center.y = scrollviewCenter.y - commentSpacing*CGFloat(comment.y)
            scrollView.addSubview(commentView)
            
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
            scrollView.layer.addSublayer(shapeLayer)
            
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
            var topAvailable = true
            for commentChecked in commentViewArray {
                if commentChecked.x == commentView.x && commentChecked.y == commentView.y+1 {
                    topAvailable = false
                }
            }
            if topAvailable {
                let tapViewTop = TapView(createX: commentView.x, createY: commentView.y+1, direction: "U")
                scrollView.addSubview(tapViewTop)
                tapViewTop.center.x = commentView.center.x
                tapViewTop.center.y = commentView.center.y - tapDistancefromView
                tapViewArray.append(tapViewTop)
                
                let tapGestureTop = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tapViewTop.addGestureRecognizer(tapGestureTop)
            }
            
            //bottom
            var bottomAvailable = true
            for commentChecked in commentViewArray {
                if commentChecked.x == commentView.x && commentChecked.y == commentView.y-1 {
                    bottomAvailable = false
                }
            }
            if bottomAvailable {
                let tapViewBottom = TapView(createX: commentView.x, createY: commentView.y-1, direction: "D")
                scrollView.addSubview(tapViewBottom)
                tapViewBottom.center.x = commentView.center.x
                tapViewBottom.center.y = commentView.center.y + tapDistancefromView
                tapViewArray.append(tapViewBottom)
                
                let tapGestureBottom = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tapViewBottom.addGestureRecognizer(tapGestureBottom)
            }
            
            //right
            var rightAvailable = true
            for commentChecked in commentViewArray {
                if commentChecked.x == commentView.x+1 && commentChecked.y == commentView.y {
                    rightAvailable = false
                }
            }
            if rightAvailable {
                let tapViewRight = TapView(createX: commentView.x+1, createY: commentView.y, direction: "R")
                scrollView.addSubview(tapViewRight)
                tapViewRight.center.x = commentView.center.x + tapDistancefromView
                tapViewRight.center.y = commentView.center.y
                tapViewArray.append(tapViewRight)
                
                let tapGestureRight = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tapViewRight.addGestureRecognizer(tapGestureRight)
            }
            
            //left
            var leftAvailable = true
            for commentChecked in commentViewArray {
                if commentChecked.x == commentView.x-1 && commentChecked.y == commentView.y {
                    leftAvailable = false
                }
            }
            if leftAvailable {
                let tapViewLeft = TapView(createX: commentView.x-1, createY: commentView.y, direction: "L")
                scrollView.addSubview(tapViewLeft)
                tapViewLeft.center.x = commentView.center.x - tapDistancefromView
                tapViewLeft.center.y = commentView.center.y
                tapViewArray.append(tapViewLeft)
                
                let tapGestureLeft = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                tapViewLeft.addGestureRecognizer(tapGestureLeft)
            }

        }
    }
    
    func createComment(x: Int, y: Int) {
        
        let commentView = CommentView(username: "", text: "", x: x, y: y, editMode: true)
        scrollView.addSubview(commentView)
        commentViewArray.append(commentView)
        
        //position comment using their x and y relative to worldView center
        let scrollviewCenter = CGPoint(x: scrollView.contentSize.width/2, y: scrollView.contentSize.height/2)
        commentView.center.x = scrollviewCenter.x + commentSpacing*CGFloat(commentView.x)
        commentView.center.y = scrollviewCenter.y - commentSpacing*CGFloat(commentView.y)
        
        updateTapViews()
        
        commentView.textField.delegate = self 
        commentView.textField.becomeFirstResponder()
        
        currentCommentEdited = commentView
        
        //show cancel button
        view.addSubview(cancelButton)
        
        //move world so that new comment is in center
        let goalPoint = CGPoint(x: view.center.x, y: view.center.y-100)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                
                self.scrollView.contentOffset.x = commentView.center.x - goalPoint.x
                self.scrollView.contentOffset.y = commentView.center.y - goalPoint.y
        },
            completion: {
                _ in
        })
    }
    
    func cancelPost() {
        currentCommentEdited?.textField.resignFirstResponder()
        editMode = false
        cancelButton.removeFromSuperview()
        currentCommentEdited?.removeFromSuperview()
        currentConnectingRod.removeFromSuperlayer()
        commentViewArray.removeLast()
        updateTapViews()
    }
    
    var emptyMessageShown = false
    
    //Keyboard events
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text != "\n") {
            print("letters")
            if emptyMessageShown {
                emptyCommentMessage.removeFromSuperview()
            }
            
        }
        
        //pressing Return
        if(text == "\n") {
            //if text field is empty, dont post and show warning message instead
            if textView.text.count > 0 {
                textView.resignFirstResponder()
                currentCommentEdited?.submitPost()
                editMode = false
                cancelButton.removeFromSuperview()
                updateTapViews()
            } else {
                print("nope")
                view.addSubview(emptyCommentMessage)
                emptyMessageShown = true
            }
        
            return false
        } else {
            return true
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        if editMode == false {
            
            editMode = true 
            
            let tapView = sender.view as! TapView
            tapView.removeFromSuperview()
            
            print("haha \(tapView.createX, tapView.createY)")
            
            createComment(x: tapView.createX, y: tapView.createY)
            
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
            scrollView.layer.addSublayer(shapeLayer)
            currentConnectingRod = shapeLayer
            
        }
    }

    @objc func handleTapCancel(sender: UITapGestureRecognizer) {
        print("cancel")
        cancelPost()
    }
    
    @objc func handleTapView(sender: UITapGestureRecognizer) {
        print("eeeee")
        if editMode {
            cancelPost()
        }
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        scrollView.frame.origin.x = worldPosition.x + translation.x
        scrollView.frame.origin.y = worldPosition.y + translation.y
        
        if sender.state == .ended {
            worldPosition = scrollView.frame.origin
        }
    }

    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        
        let pinchScale = sender.scale
        
        if worldScale*pinchScale > minZoomScale && worldScale*pinchScale < maxZoomScale {
            scrollView.transform = view.transform.scaledBy(x: worldScale*pinchScale, y: worldScale*pinchScale)
            
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

