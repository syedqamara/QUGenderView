//
//  ViewController.swift
//  DemoBuild
//
//  Created by Syed Qamar Abbas on 18/04/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        actionOnSegmentSelection(segmentControl)
        // Do any additional setup after loading the view.
    }

    @IBAction func actionOnSegmentSelection(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            self.view.backgroundColor = .red
        }
        else if segmentControl.selectedSegmentIndex == 1 {
            self.view.backgroundColor = .blue
        }
        else if segmentControl.selectedSegmentIndex == 2 {
            self.view.backgroundColor = .green
        }
    }
    
}

