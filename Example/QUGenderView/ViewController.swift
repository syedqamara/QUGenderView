//
//  ViewController.swift
//  QUGenderView
//
//  Created by etDev24 on 04/26/2018.
//  Copyright (c) 2018 etDev24. All rights reserved.
//

import UIKit
import QUGenderView
class ViewController: UIViewController {
    var gender: QUGenderView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let color = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        gender = QUGenderView(frame: self.view.bounds, andColor: color)
        self.view.addSubview(gender!)
        self.gender?.topLabel?.text = "I'm a male"
        gender?.genderButtonColor = UIColor.white
        gender?.selectedButtonColor = UIColor.lightGray
        gender?.clotheColor = UIColor.orange
        gender?.genderIsSelected(completion: { (genderType) in
            
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

