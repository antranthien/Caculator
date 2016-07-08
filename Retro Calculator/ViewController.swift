//
//  ViewController.swift
//  Retro Calculator
//
//  Created by admin on 03/07/16.
//  Copyright © 2016 anttran. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // Variables
    var audioPlayer : AVAudioPlayer!
    var currentResult = ""
    var runningNumber = ""
    var leftVal = ""
    var rightVal = ""
    var currentOperation = Operation.None
    
    enum Operation : String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Plus = "+"
        case None = ""
    }
    
    // Outlets
    @IBOutlet weak var resultLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeAudioPlayer()
    }
    
    func initializeAudioPlayer(){
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        
        let soundURL = NSURL(fileURLWithPath: path!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
            audioPlayer.prepareToPlay()
        }
        catch let err as NSError
        {
            print(err.debugDescription)
        }

    }
    
    func handleOperation(operation : Operation){
        playSound()
        
        if currentOperation != Operation.None {
            if runningNumber != "" {
                rightVal = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Plus {
                    currentResult = "\(Double(leftVal)! + Double(rightVal)!)"
                } else if(currentOperation == Operation.Divide){
                    currentResult = "\(Double(leftVal)! / Double(rightVal)!)"
                } else if(currentOperation == Operation.Subtract){
                    currentResult = "\(Double(leftVal)! - Double(rightVal)!)"
                } else if(currentOperation == Operation.Multiply){
                    currentResult = "\(Double(leftVal)! * Double(rightVal)!)"
                }
                
                leftVal = currentResult
                updateResultLbl(currentResult)
            }
            currentOperation = operation
        } else {
            // 1st time pressing an operator
            leftVal = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    func updateResultLbl(value : String){
        resultLbl.text = value
    }
    
    @IBAction func onNumberPressed(btn : UIButton){
        playSound()
        
        runningNumber += "\(btn.tag)"
        resultLbl.text = runningNumber
    }
    
    @IBAction func onPlusButtonPressed(sender: AnyObject) {
        handleOperation(Operation.Plus)
    }
    
    
    @IBAction func onDivideButtonPressed(sender: AnyObject) {
        handleOperation(Operation.Divide)
    }
    
    
    @IBAction func onMultiplyButtonPressed(sender: AnyObject) {
        handleOperation(Operation.Multiply)
    }
    
    
    @IBAction func onSubtractButtonPressed(sender: AnyObject) {
        handleOperation(Operation.Subtract)
    }
    
    
    @IBAction func onEqualButtonPressed(sender: AnyObject) {
        handleOperation(currentOperation)
    }
    
    func playSound() {
        if audioPlayer.playing{
            audioPlayer.stop()
        }
        
        audioPlayer.play()
    }
}

