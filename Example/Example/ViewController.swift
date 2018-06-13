//
//  ViewController.swift
//  Example
//
//  Created by Nattapong Unaregul on 21/5/18.
//  Copyright © 2018 Nattapong Unaregul. All rights reserved.
//

import UIKit
import BHTextField
class ViewController: UIViewController {
    @IBOutlet weak var txt_firstName: BHTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_firstName.textInputColor = UIColor.blue
        txt_firstName.placeholderColor = UIColor.cyan
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

