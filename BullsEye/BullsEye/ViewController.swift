//
//  ViewController.swift
//  BullsEye
//
//  Created by Olexsii Levchenko on 6/22/22.
//

import UIKit

class ViewController: UIViewController {
    
    var currentValue: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showAlert() {
        let alert = UIAlertController(title: "Hello World",
                                      message: "This my first app",
                                      preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Awesome",
                                        style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        currentValue = lroundf(sender.value)
    }
}

