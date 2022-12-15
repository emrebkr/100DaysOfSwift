//
//  ViewController.swift
//  Hangman Consolidation
//
//  Created by Emre Bakır on 14.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var allWords = [String]()
    var currentWord: String!
    var usedLetters = [Character]()
    var currentAnswer = UITextField()
    
    var letterButtons =  [UIButton]()
    var activatedButtons = [UIButton]()
    var wordLabel: UILabel!
    var guessesLabel: UILabel!
    var guesses = 0 {
        didSet {
            guessesLabel.text = "Incorrect guesses made: \(guesses)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        guessesLabel = UILabel()
        guessesLabel.translatesAutoresizingMaskIntoConstraints = false
        guessesLabel.textAlignment = .center
        guessesLabel.text = "Incorrect Guessed Made: 0/7"
        view.addSubview(guessesLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "????????"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let newGame = UIButton(type: .system)
        newGame.translatesAutoresizingMaskIntoConstraints = false
        newGame.setTitle("New Game", for: .normal)
        newGame.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
        view.addSubview(newGame)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            guessesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            guessesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            currentAnswer.topAnchor.constraint(equalTo: guessesLabel.bottomAnchor, constant: 20),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            
            newGame.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            newGame.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            newGame.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        ])
        
        let theLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var letterCount = 0
        let width = 50
        let height = 40
        
        for row in 0..<5 {
            for column in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
                letterButton.setTitle("?", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterCount += 1
                
            }
        }
        
        for (index, char) in theLetters.enumerated() {
            letterButtons[index].setTitle(String(char), for: .normal)
        }
        
        for button in letterButtons {
            if button.titleLabel?.text == "?" {
                button.isHidden = true
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(inBackground: #selector(loadWords), with: nil)
    }
    
    @objc func loadWords() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        performSelector(onMainThread: #selector(startNewGame), with: nil, waitUntilDone: false)
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        
        guard let buttonTitle = sender.titleLabel?.text else { return }
        usedLetters.append(Character(buttonTitle))
        sender.isEnabled = false
        
        if currentWord.contains(buttonTitle) {
            var newAnswerText = currentAnswer.text
            for (index, char) in currentWord.enumerated() {
                if char == Character(buttonTitle) {
                    newAnswerText = String(newAnswerText!.prefix(index) + String(char) + newAnswerText!.dropFirst(index+1))
                }
            }
            currentAnswer.text = newAnswerText
            
            
            if currentAnswer.text?.contains("?") == false {
                let ac = UIAlertController(title: "You Won!", message: "You guessed the word and lived! Do you want to play again?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: restartGame))
                present(ac, animated: true)
                return
            }
        } else {
            addBodyPart()
        }
        
    }
    
    @objc func startNewGame() {
        for button in letterButtons {
            button.isEnabled = true
        }
        
        usedLetters.removeAll(keepingCapacity: true)
        guesses = 0
        
        currentWord = allWords.randomElement()
        
        let numberChars = currentWord.count
        var i = 1
        var newEmptyField = ""
        while i <= numberChars {
            newEmptyField = newEmptyField + "?"
            i += 1
        }
        
        currentAnswer.text = newEmptyField
        print(currentWord!)
        
        
    }
    
    
    @objc func newGameTapped() {
        startNewGame()
    }
    
    
    
    func addBodyPart() {
        guesses += 1
        if guesses == 7 {
            let ac = UIAlertController(title: "Game Over", message: "You have died! The word was \(currentWord!). Do you want to play again?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: restartGame))
            present(ac, animated: true)
        }
    }
    func restartGame(action: UIAlertAction) {
            startNewGame()
        }
    
}
