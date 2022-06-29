//U-N00B-or-Bot

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var a1: MyButton!
    @IBOutlet weak var a2: MyButton!
    @IBOutlet weak var a3: MyButton!
    @IBOutlet weak var b1: MyButton!
    @IBOutlet weak var b2: MyButton!
    @IBOutlet weak var b3: MyButton!
    @IBOutlet weak var c1: MyButton!
    @IBOutlet weak var c2: MyButton!
    @IBOutlet weak var c3: MyButton!
    @IBOutlet weak var initButton: MyButton!
    
    
    var human = "0"
    var computer = "X"
    //var depth = 0
    
    var board = [MyButton]()
    var notPressedButtons = [MyButton]()
    
    private func boardInit(){
        board = [a1,a2,a3,b1,b2,b3,c1,c2,c3]
        
        // depth = 0
        for index in 0..<board.count {
            let name = ["a1","a2","a3","b1","b2","b3","c1","c2","c3"]
            
            board[index].name = name[index]
            board[index].pressed = false
            board[index].value = ""
            board[index].fakePressed = false
            board[index].fakeValue = ""
            board[index].isEnabled = true
            board[index].setTitle("", for: .normal)
            board[index].setTitleColor(.black, for: .disabled)
            board[index].titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
            board[index].score = 0
            board[index].backgroundColor = .white
        }
    }
    
    var notPressedButton = [MyButton]()
    
    func checkPressedButton(){
        for board in board {
            if board.pressed == false{
                notPressedButton.append(board)
            }
        }
        
    }
    
    
    
    
    
    func ifComputerXGetFirstStep(){
        let array = [a1,a3,b2,c1,c3]
        let myStep = array.randomElement()!
        
        myStep!.pressed = true
        myStep!.setTitle(computer, for: .normal)
        myStep!.value = computer
        myStep?.isEnabled = false
    }
    
    
    func restart(){
        boardInit()
        
        let allertController = UIAlertController(title: "Hello", message: "You choice X or 0", preferredStyle: .alert)
        let action = UIAlertAction(title: "X", style: .default) { action in
            self.human = "X"
            self.computer = "0"
        }
        let action2 = UIAlertAction(title: "0", style: .default) { action in
            self.human = "0"
            self.computer = "X"
            self.notPressedButton.removeAll()
            self.checkPressedButton()
            self.ifComputerXGetFirstStep()
        }
        allertController.addAction(action)
        allertController.addAction(action2)
        self.present(allertController, animated: true, completion: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        restart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restart()
        
        
    }
    
    @IBAction func restartPressed(_ sender: MyButton) {
        sender.score = 0
        viewDidLoad()
    }
    
    
    
    @IBAction func pressed(_ sender: MyButton) {
        notPressedButton.removeAll()
        sender.setTitle(human, for: .normal)
        sender.isEnabled = false
        sender.pressed = true
        sender.value = human
        if win(){
            for board in board {
                board.isEnabled = false
                board.backgroundColor = .gray
            }
            let allertController = UIAlertController(title: "Поздравляем!", message: "вы победили!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "ОК", style: .default) { action in
            }
            allertController.addAction(action)
            
            self.present(allertController, animated: true, completion: nil)
            
            
        }
        
        checkPressedButton()
        if notPressedButton.count > 0{
            minimax(btn: initButton, currentPlayer: computer, isMain: true)
            if win(){
                for board in board {
                    board.isEnabled = false
                    board.backgroundColor = .gray
                }
                let allertController = UIAlertController(title: "Победил компьютер", message: "Не огорчайтесь, он умнее!", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "ОК", style: .default) { action in
                }
                allertController.addAction(action)
                
                self.present(allertController, animated: true, completion: nil)
            }
            
        } else {
            let allertController = UIAlertController(title: "Ничья", message: "Ничья", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "ОК", style: .default) { action in
            }
            allertController.addAction(action)
            
            self.present(allertController, animated: true, completion: nil)
        }
    }
    
    
    func minimax(btn: MyButton, currentPlayer: String, isMain: Bool){
        
        
        
        if notPressedButton.count == 0 {
            // btn.score = 0
            return
        }
        var values = [Int]()
        var buttons = [MyButton]()
        
        //let depth = board.count - notPressedButton.count
        //NEW
        
        
        
        for button in notPressedButton {
            var onestepWin = false
            if button.pressed {continue}
            
            for button in notPressedButton {
                if button.pressed {continue}
                button.pressed = true
                button.value = currentPlayer
                if win() && button.value == computer{
                    values.append(10)
                    buttons.append(button)
                    button.pressed = false
                    button.value = ""
                    onestepWin = true
                    break
                }else if win() && button.value == human{
                    print(win())
                    values.append(-10)
                    buttons.append(button)
                    button.pressed = false
                    button.value = ""
                    onestepWin = true
                    break
                }else {
                    button.pressed = false
                    button.value = ""
                    continue
                }
            }
            if onestepWin == true {
                onestepWin = false
                break}
            
            
            
            button.pressed = true
            button.value = currentPlayer
            
            
            
            
            /* if win() && button.value == computer{
             values.append(10-depth)
             buttons.append(button)
             button.pressed = false
             button.value = ""
             continue
             }else if win() && button.value == human{
             values.append(-10+depth)
             buttons.append(button)
             button.pressed = false
             button.value = ""
             continue
             }else {*/
            // print("рекурсия")
            if currentPlayer == computer {
                
                minimax(btn: button, currentPlayer: human, isMain: false)
                values.append(button.score)
                buttons.append(button)
                button.pressed = false
                button.value = ""
                button.score = 0
                
            } else if currentPlayer == human{
                minimax(btn: button, currentPlayer: computer, isMain: false)
                values.append(button.score)
                buttons.append(button)
                button.pressed = false
                button.value = ""
                button.score = 0
                
            }
            continue
            
            
            
            
            //}
        }// while end
        
        if currentPlayer == computer {
            let max = values.max() ?? 0
            btn.score = max//values.max() ?? 0
            let btnIndex = values.firstIndex(of: max) ?? 0
            if isMain{
                buttons[btnIndex].pressed = true
                buttons[btnIndex].value = computer
                buttons[btnIndex].isEnabled = false
                buttons[btnIndex].setTitle(computer, for: .normal)
                print(values)
                
            }
            
            
            
            //print(values.max() ?? 0)
        } else {
            btn.score = values.min() ?? 0
            // print(values.min() ?? 0)
        }
        if isMain{
            
            print(values)
            
        }
        
    }//func end
    
    
    func win()-> Bool{
        if  a1.value == a2.value && a2.value == a3.value && a1.value != "" ||
                b1.value == b2.value && b2.value == b3.value && b1.value != "" ||
                c1.value == c2.value && c2.value == c3.value && c1.value != "" ||
                a1.value == b1.value && b1.value == c1.value && a1.value != "" ||
                a2.value == b2.value && b2.value == c2.value && a2.value != "" ||
                a3.value == b3.value && b3.value == c3.value && a3.value != "" ||
                a1.value == b2.value && b2.value == c3.value && a1.value != "" ||
                a3.value == b2.value && b2.value == c1.value && a3.value != ""{
            return true
            
        }
        return false
    }
    
}

