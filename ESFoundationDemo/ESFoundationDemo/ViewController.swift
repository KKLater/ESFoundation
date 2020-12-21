//
//  ViewController.swift
//  ESFoundationDemo
//
//  Created by 罗树新 on 2020/12/21.
//

import UIKit
import ESArray
import ESString

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let array = [1, 2, 2, 3, 5]
        let newArray = array.enumerated { $0 > 3 }
        print(array, newArray)
        
        let string = "originString"
        print(string.md5)
    }
    
    


}

