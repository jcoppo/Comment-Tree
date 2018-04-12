//
//  ViewController.swift
//  Comment Tree
//
//  Created by Jayson Coppo on 4/8/18.
//  Copyright © 2018 Jayson Coppo. All rights reserved.
//

import UIKit

class ViewControllerBrowse: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func makeTreePress(_ sender: Any) {
        print("make tree")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let treeVC = segue.destination as! ViewControllerTree
        treeVC.newTree = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

