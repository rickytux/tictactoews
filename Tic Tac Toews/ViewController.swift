//
//  ViewController.swift
//  Tic Tac Toews
//
//  Created by Rick Dsida on 7/22/14.
//  Copyright (c) 2014 Rick Dsida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBOutlet var ticTacImg1: UIImageView!
    @IBOutlet var ticTacImg2: UIImageView!
    @IBOutlet var ticTacImg3: UIImageView!
    @IBOutlet var ticTacImg4: UIImageView!
    @IBOutlet var ticTacImg5: UIImageView!
    @IBOutlet var ticTacImg6: UIImageView!
    @IBOutlet var ticTacImg7: UIImageView!
    @IBOutlet var ticTacImg8: UIImageView!
    @IBOutlet var ticTacImg9: UIImageView!
    
    @IBOutlet var ticTacBtn1: UIButton!
    @IBOutlet var ticTacBtn2: UIButton!
    @IBOutlet var ticTacBtn3: UIButton!
    @IBOutlet var ticTacBtn4: UIButton!
    @IBOutlet var ticTacBtn5: UIButton!
    @IBOutlet var ticTacBtn6: UIButton!
    @IBOutlet var ticTacBtn7: UIButton!
    @IBOutlet var ticTacBtn8: UIButton!
    @IBOutlet var ticTacBtn9: UIButton!
    
    @IBOutlet var resetBtn: UIButton!
    @IBOutlet var userMessage: UILabel!
    
    var plays = Dictionary<Int,Int>()
    var done = false
    var aiDeciding = false
    
   
    
    @IBAction func UIButtonClicked(sender:UIButton) {
        userMessage.hidden = true

        if !plays[sender.tag] && !aiDeciding && !done {
            setImageForSpot(sender.tag, player:1)
        checkForWin()
        checkForTie()
        aiTurn()
        }
    }
    func setImageForSpot(spot:Int,player:Int) {
        var playerMark = player == 1 ? "X" : "o"
        plays[spot] = player
        switch spot {
        case 1:
            ticTacImg1.image = UIImage(named: playerMark)
        case 2:
            ticTacImg2.image = UIImage(named: playerMark)
        case 3:
            ticTacImg3.image = UIImage(named: playerMark)
        case 4:
            ticTacImg4.image = UIImage(named: playerMark)
        case 5:
            ticTacImg5.image = UIImage(named: playerMark)
        case 6:
            ticTacImg6.image = UIImage(named: playerMark)
        case 7:
            ticTacImg7.image = UIImage(named: playerMark)
        case 8:
            ticTacImg8.image = UIImage(named: playerMark)
        case 9:
            ticTacImg9.image = UIImage(named: playerMark)
        default:
            ticTacImg1.image = UIImage(named: playerMark)
        }
    }
    @IBAction func resetBtnClicked(sender:UIButton) {
        done = false
        resetBtn.hidden = true
        userMessage.hidden = true
        reset()
    }
    func reset() {
        plays = [:]
        ticTacImg1.image = nil
        ticTacImg2.image = nil
        ticTacImg3.image = nil
        ticTacImg4.image = nil
        ticTacImg5.image = nil
        ticTacImg6.image = nil
        ticTacImg7.image = nil
        ticTacImg8.image = nil
        ticTacImg9.image = nil
        
    }
    
    func checkForWin() {
        var whoWon = ["I":0, "you":1]
        for(key,value) in whoWon {
            if((plays[1] == value && plays[2] == value && plays[3] == value) ||
            (plays[4] == value && plays[5] == value && plays[6] == value) ||
            (plays[7] == value && plays[8] == value && plays[9] == value) ||
            (plays[1] == value && plays[4] == value && plays[7] == value) ||
            (plays[2] == value && plays[5] == value && plays[8] == value) ||
            (plays[3] == value && plays[6] == value && plays[9] == value) ||
            (plays[1] == value && plays[5] == value && plays[9] == value) ||
                (plays[3] == value && plays[5] == value && plays[7] == value)){
                    userMessage.hidden = false
                    userMessage.text = "Looks like \(key) won!"
                    resetBtn.hidden = false
                    done = true
            }
        }
    }
    func checkForTie() {
        if (isOccupied(1) && isOccupied(2) && isOccupied(3) && isOccupied(4) && isOccupied(5) && isOccupied(6) && isOccupied(7) && isOccupied(8) && isOccupied(9)) {
            done = true
            userMessage.hidden = false
            userMessage.text = "It's a tie and thats the best you are gonna do"
            resetBtn.hidden = false
            
        }
    }
    func checkBottom(#value:Int) -> (location:String,pattern:String) {
        return ("bottom",checkFor(value, inList: [7,8,9]))
    }
    func checkMiddle(#value:Int) -> (location:String,pattern:String) {
        return ("middle",checkFor(value, inList: [4,5,6]))
    }
    func checkTop(#value:Int) -> (location:String,pattern:String) {
        return ("top",checkFor(value, inList: [1,2,3]))
    }
    func checkLeft(#value:Int) -> (location:String,pattern:String) {
        return ("left",checkFor(value, inList: [1,4,7]))
    }
    func checkCenter(#value:Int) -> (location:String,pattern:String) {
        return ("center",checkFor(value, inList: [2,5,8]))
    }
    func checkRight(#value:Int) -> (location:String,pattern:String) {
        return ("right",checkFor(value, inList: [3,6,9]))
    }
    func checkDiagLR(#value:Int) -> (location:String,pattern:String) {
        return ("diaglr",checkFor(value, inList: [1,5,9]))
    }
    func checkDiagRL(#value:Int) -> (location:String,pattern:String) {
        return ("diagrl",checkFor(value, inList: [3,5,7]))
    }
    func checkFor(value:Int, inList:[Int]) -> String {
        var conclusion = ""
        for cell in inList {
            if plays[cell] == value {
                conclusion += "1"
            }else {
                conclusion += "0"
            }
        }
        return conclusion
    }
    func rowCheck(#value:Int) -> (location:String,pattern:String)? {
        var acceptableFinds = ["011","110","101"]
        var findFuncs = [checkTop,checkBottom,checkMiddle,checkLeft,checkRight,checkCenter,checkDiagLR,checkDiagRL]
        for algorthm in findFuncs {
            var algorthmResults = algorthm(value:value)
            if find(acceptableFinds, algorthmResults.pattern) {
                return algorthmResults
            }
        }
        return nil
    }
    
    func isOccupied(spot:Int) ->Bool {
        return Bool(plays[spot])
    }
    func firstAvailable(#isCorner:Bool) -> Int? {
        var spots = isCorner ? [1,3,7,9] : [2,4,6,9]
        for spot in spots{
            if !isOccupied(spot){
                return spot
            }
        }
        return nil
    }
    func aiTurn(){
        if done {
            return
        }
        aiDeciding = true
        // go for middle if available
        if !isOccupied(5){
            setImageForSpot(5, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        //ai to go for win if it has two in a row
        if let result = rowCheck(value:0) {
            var whereToPlayResult = whereToPlay(result.location,pattern:result.pattern)
    
            if !isOccupied(whereToPlayResult) {
                setImageForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        // edge cases still trying to figure out why they aren't included in the blocking strategy
        if (plays[3]==1 && plays[9]==1 && !isOccupied(6)) {
            setImageForSpot(6, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[5]==1 && plays[8]==1 && !isOccupied(2)) {
            setImageForSpot(2, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[1]==1 && plays[7]==1 && !isOccupied(4)) {
            setImageForSpot(4, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[5]==1 && plays[2]==1 && !isOccupied(8)) {
            setImageForSpot(8, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[7]==1 && plays[5]==1 && !isOccupied(3)) {
            setImageForSpot(3, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[3]==1 && plays[5]==1 && !isOccupied(7)) {
            setImageForSpot(7, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        //ai needs to block when user has 2 in a row
        if let result = rowCheck(value:1) {
            var whereToPlayResult = whereToPlay(result.location,pattern:result.pattern)

            if !isOccupied(whereToPlayResult) {
                setImageForSpot(whereToPlayResult, player: 0)
                aiDeciding = false
                checkForWin()
                return
            }
        }
        //block for fork trap
        if (plays[1]==1 && plays[9]==1 && !isOccupied(4)) {
            setImageForSpot(4, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[3]==1 && plays[7]==1 && !isOccupied(6)) {
            setImageForSpot(6, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[7]==1 && plays[6]==1 && !isOccupied(9)) {
            setImageForSpot(9, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[9]==1 && plays[4]==1 && !isOccupied(7)) {
            setImageForSpot(7, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[3]==1 && plays[8]==1 && !isOccupied(9)) {
            setImageForSpot(9, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[1]==1 && plays[8]==1 && !isOccupied(7)) {
            setImageForSpot(7, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if (plays[5]==1 && plays[7]==1 && !isOccupied(3)) {
            setImageForSpot(3, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        //this is for when there is no threat or strategic move to be made
        if let cornerAvailable = firstAvailable(isCorner:true) {
            setImageForSpot(cornerAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        if let sideAvailable = firstAvailable(isCorner:false) {
            setImageForSpot(sideAvailable, player: 0)
            aiDeciding = false
            checkForWin()
            return
        }
        
        aiDeciding = false
    }
    
    func whereToPlay(location:String,pattern:String) ->Int {
        var leftPattern = "011"
        var rightPattern = "110"
        var middlePattern = "101"
    
        switch location {
            case "top":
                if pattern == leftPattern{
                    return 1
                }else if pattern == rightPattern {
                    return 3
                }else {
                    return 2
                }
            case "bottom":
                if pattern == leftPattern{
                    return 7
                }else if pattern == rightPattern {
                    return 9
                }else {
                    return 8
                }
            case "left":
                if pattern == leftPattern{
                    return 1
                }else if pattern == rightPattern {
                    return 7
                }else {
                    return 4
                }
            case "right":
                if pattern == leftPattern{
                    return 3
                }else if pattern == rightPattern {
                    return 9
                }else {
                    return 6
                }
            case "center":
                if pattern == leftPattern{
                    return 2
                }else if pattern == rightPattern {
                    return 8
                }else {
                    return 5
                }
            case "middle":
                if pattern == leftPattern{
                    return 4
                }else if pattern == rightPattern {
                    return 6
                }else {
                    return 5
                }
            case "diagrl":
                if pattern == leftPattern{
                    return 3
                }else if pattern == rightPattern {
                    return 7
                }else {
                    return 5
                }
            case "diaglr":
                if pattern == leftPattern{
                    return 1
                }else if pattern == rightPattern {
                    return 9
                }else {
                    return 5
                }
            default:
                return 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

