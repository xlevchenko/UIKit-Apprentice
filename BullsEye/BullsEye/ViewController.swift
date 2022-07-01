//
//  ViewController.swift
//  BullsEye
//
//  Created by Olexsii Levchenko on 6/22/22.
//

import UIKit

class ViewController: UIViewController {
    
    var currentValue = 0
    var targetValue = 0
    var score = 0
    var round = 0
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()
    }

    @IBAction func showAlert() {
        
        let difference = abs(currentValue - targetValue)
        let points = 100 - difference
        
        score += points
        
        let message = "You scored \(points) points"
        + "\nThe value of the slider is: \(currentValue)" + "\nThe target value is: \(targetValue)" + "\nThe difference is: \(difference)"

        let alert = UIAlertController(title: "Hello World",
                                      message: message,
                                      preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok",
                                        style: .default)
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        
        startNewRound()
    }
    
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        currentValue = lroundf(sender.value)
        minValueLabel.text = "\(lroundf(sender.value))"
    }
    
    
    func startNewRound() {
        round += 1
        targetValue = Int.random(in: 1...100)
        currentValue = 50
        slider.value = Float(currentValue)
        
        
        
        updateLabels()
    }
    
    
    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }
}

