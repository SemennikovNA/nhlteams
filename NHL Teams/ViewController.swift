//  ViewController.swift
//  Apple pie
//
//  Created by rezra on 23.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - UIProperties
    
    let buttonStackView = UIStackView()
    var currentGame: Game!
    let correctWordLabel = UILabel()
    let gatesImageVIew = UIImageView()
    var letterButtons = [UIButton]()
    let lowStackView = UIStackView()
    let mainStackView = UIStackView()
    let otherWordButton = UIButton()
    
    //MARK: - Properties
    var incorrectMovesAlowed = 7
    var listOfComands = ["Hurricanes", "Blue Jackets", "Devils", "Islanders", "Rangers", "Flyers", "Penguins", "Capitals", "Bruins", "Sabres", "Red Wings", "Panthers", "Canadiens", "Senators", "Lightning", "Maple Leafs", "Coyotes", "Blackhawks", "Avalanche", "Stars", "Wild", "Predators", "Blues", "Jets", "Ducks", "Flames", "Oilers", "Kings", "Sharks", "Kraken", "Canucks", "Golden Knights"]
    let scoreLabel = UILabel()
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    
    //MARK: - Methods
    
    func enableButton(_ enable: Bool = true) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    func initLetterButtons(fontSize: CGFloat = 17) {
        //Init letter buttons
        let buttonsTitle = "QWERTYUIOPASDFGHJKLZXCVBNM_"
        for buttonTitle in buttonsTitle {
            let title: String = buttonTitle == "_" ? "" : String(buttonTitle)
            let button = UIButton()
            button.addTarget(self, action: #selector(letterButtonPressed), for: .touchUpInside)
            button.setTitle(title, for: [])
            button.setTitleColor(.white, for: .normal)
            button.setTitleColor(.gray, for: .highlighted)
            button.setTitleColor(.systemGray, for: .disabled)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
            button.titleLabel?.textAlignment = .center
            letterButtons.append(button)
        }
        // Init buttons stack view
        let buttonRows = [UIStackView(), UIStackView()]
        let rowCount = letterButtons.count / 2
        
        for row in 0..<buttonRows.count {
            for index in 0..<rowCount {
                buttonRows[row].addArrangedSubview(letterButtons[row * rowCount + index])
            }
            buttonRows[row].distribution = .fillEqually
            buttonStackView.addArrangedSubview(buttonRows[row])
        }
    }
    
    @objc func letterButtonPressed(sender: UIButton) {
        sender.isEnabled = false
        let letter = sender.title(for: .normal)!
        currentGame.playerGuessed(letter: Character(letter))
        updateState()
    }
    
    func loseAllert() {
        let falseAlert = UIAlertController(title: "Losses☹️", message: "Oh sorry, try again.", preferredStyle: .alert)
        let falseButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        falseAlert.addAction(falseButton)
        present(falseAlert, animated: true, completion: nil)
    }
    
    @objc func newWordButtonPressed() {
        newRound()
    }
    
    func newRound() {
        guard !listOfComands.isEmpty else {
            enableButton(false)
            updateUI()
            return
        }
        let newWord = listOfComands.removeFirst()
        currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAlowed)
        updateUI()
        enableButton()
    }
    
    func updateStackSize(to size: CGSize) {
        mainStackView.axis = size.height < size.width ? .horizontal : .vertical
        mainStackView.frame = CGRect(x: 8, y: 8, width: size.width - 16, height: size.height - 16)
    }
    
    func updateUI() {
        let imageNumber = (currentGame.incorrectMovesRemaining + 64) % 8
        let image = "Gates\(imageNumber)"
        gatesImageVIew.image = UIImage(named: image)
        updateCorrectWordLabel()
        scoreLabel.text = "Выигрыши: \(totalWins) Проигрыши: \(totalLosses)"
    }
    
    func updateCorrectWordLabel() {
        var displayWord = [String]()
        for letter in currentGame.guessedWord {
            displayWord.append(String(letter))
        }
        correctWordLabel.text = displayWord.joined(separator: " ")
    }
    
    func updateState() {
        if currentGame.incorrectMovesRemaining < 1 {
            loseAllert()
            totalLosses += 1
        } else if currentGame.guessedWord == currentGame.word {
            winAllert()
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func winAllert() {
        let trueAlert = UIAlertController(title: "Wins!🥳", message: "Great keep up the good work!", preferredStyle: .alert)
        let trueButton = UIAlertAction(title: "Great", style: .default, handler: nil)
        trueAlert.addAction(trueButton)
        present(trueAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = view.bounds.size
        let factor = min(size.height, size.width)
        
        // Setup button Stack view
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 30
        
        // Setup correct word label
        correctWordLabel.font = UIFont.boldSystemFont(ofSize: factor / 15)
        correctWordLabel.textAlignment = .center
        correctWordLabel.textColor = .white
        
        // Setup tree Image view
        gatesImageVIew.image = UIImage(named: "Tree3")
        gatesImageVIew.contentMode = .scaleAspectFit
        
        //Setup letter buttons
        initLetterButtons(fontSize: factor / 15)
        
        // Setup lower Stack view
        lowStackView.backgroundColor = .clear
        lowStackView.addArrangedSubview(buttonStackView)
        lowStackView.addArrangedSubview(correctWordLabel)
        lowStackView.addArrangedSubview(scoreLabel)
        lowStackView.addArrangedSubview(otherWordButton)
        lowStackView.axis = .vertical
        lowStackView.distribution = .fillEqually
        lowStackView.spacing = 5
        
        // Setup top Stack view
        mainStackView.addArrangedSubview(gatesImageVIew)
        mainStackView.addArrangedSubview(lowStackView)
        mainStackView.frame = view.bounds
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 10
        
        //Setup new word button
        otherWordButton.setTitle("Other word", for: [])
        otherWordButton.setTitleColor(.black, for: [])
        otherWordButton.backgroundColor = .white
        otherWordButton.layer.cornerRadius = 20
        otherWordButton.addTarget(self, action: #selector(newWordButtonPressed), for: .touchUpInside)
        
        // Setup score label
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont.boldSystemFont(ofSize: factor / 20)
        scoreLabel.text = "Wins: \(totalWins) Losses: \(totalLosses)"
        
        // Setup view
        view.addSubview(mainStackView)
        view.backgroundColor = .clear
        
        updateStackSize(to: view.bounds.size)
        newRound()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateStackSize(to: size)
    }
    
}

