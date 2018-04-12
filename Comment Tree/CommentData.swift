//
//  CommentData.swift
//  Comment Tree
//
//  Created by Jayson Coppo on 4/10/18.
//  Copyright © 2018 Jayson Coppo. All rights reserved.
//

import Foundation

struct CommentData {
    
    var username = String()
    var text = String()
    var x = Int()
    var y = Int()
    var xRespond = Int()
    var yRespond = Int()
    
    init(username: String, text: String, x: Int, y: Int, xRespond: Int, yRespond: Int) {
        self.username = username
        self.text = text
        self.x = x
        self.y = y
        self.xRespond = xRespond
        self.yRespond = yRespond
    }
}

struct Tree {
    
    var commentArray = [CommentData]()
    var name = String()
    
    init(name: String) {
        self.name = name
    }
}


struct TreeList {
    
    var treeArray = [Tree]()
    
    init() {
        
        makeTree1()
        makeTree2()
    }
    
    mutating func makeTree1() {
        //example tree
        let post1 = CommentData(username: "Jerry", text: "Whats the deal with peanuts on the plane?", x: 0, y: 0, xRespond: 0, yRespond: 0)
        
        let post2 = CommentData(username: "George", text: "George is gettin upset!", x: 1, y: 0, xRespond: 0, yRespond: 0)
        
        let post3 = CommentData(username: "Kramer", text: "Oh, you better believe it buddy", x: 0, y: 1, xRespond: 0, yRespond: 0)
        
        let post4 = CommentData(username: "Elaine", text: "Oh he's definitely 'sponge-worthy'", x: -1, y: 0, xRespond: 0, yRespond: 0)
        
        var tree1 = Tree(name: "What's The Deal")
        tree1.commentArray = [post1, post2, post3, post4]
        
        treeArray.append(tree1)
    }
    
    mutating func makeTree2() {
        
        //example tree
        let post1 = CommentData(username: "Jerry", text: "Whats the deal with peanuts on the plane?", x: 0, y: 0, xRespond: 0, yRespond: 0)
        
        let post2 = CommentData(username: "George", text: "George is gettin upset!", x: 1, y: 0, xRespond: 0, yRespond: 0)
        
        let post3 = CommentData(username: "Kramer", text: "Oh, you better believe it buddy", x: 0, y: 1, xRespond: 0, yRespond: 0)
        
        let post4 = CommentData(username: "Elaine", text: "Oh he's definitely 'sponge-worthy'", x: -1, y: 0, xRespond: 0, yRespond: 0)
        
        let post5 = CommentData(username: "Newman", text: "Alright, Alright! I WRITHE with fleas", x: 1, y: 1, xRespond: 0, yRespond: 1)
        
        let post6 = CommentData(username: "Putty", text: "Yeah thats right", x: -1, y: -1, xRespond: -1, yRespond: 0)
        
        let post7 = CommentData(username: "Bania", text: "What? Soup isn't a meal", x: 0, y: -1, xRespond: -1, yRespond: -1)
        
        let post8 = CommentData(username: "Frank", text: "This guy...he's not my kinda guy", x: 1, y: -1, xRespond: 0, yRespond: -1)
        
        var tree2 = Tree(name: "Excruciating Minutiae")
        tree2.commentArray = [post1, post2, post3, post4, post5, post6, post7, post8]
        
        treeArray.append(tree2)

    }
}






