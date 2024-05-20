//
//  EmotionDiaryViewController.swift
//  EmotionDiary
//
//  Created by NERO on 5/20/24.
//

import UIKit

class EmotionDiaryViewController: UIViewController {
    @IBOutlet var emotionDiaryView: UIView!
    @IBOutlet var emotionDiaryNavigationBar: UINavigationItem!
    @IBOutlet var emotionDiaryBarItem: UIBarButtonItem!
    
    @IBOutlet var happinessButton: UIButton!
    @IBOutlet var loveButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var angryButton: UIButton!
    @IBOutlet var boredButton: UIButton!
    @IBOutlet var gloomyButton: UIButton!
    @IBOutlet var panicButton: UIButton!
    @IBOutlet var upsetButton: UIButton!
    @IBOutlet var sadButton: UIButton!
    
    @IBOutlet var happinessLabel: UILabel!
    @IBOutlet var loveLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var angryLabel: UILabel!
    @IBOutlet var boredLabel: UILabel!
    @IBOutlet var gloomyLabel: UILabel!
    @IBOutlet var panicLabel: UILabel!
    @IBOutlet var upsetLabel: UILabel!
    @IBOutlet var sadLabel: UILabel!
    
    @IBOutlet var emotionButtons: [UIButton]!
    @IBOutlet var emotionLabels: [UILabel]!
    let EmotionTexts = ["행복해", "사랑해", "좋아해", "분노해", "심심해", "우울해", "멘붕해", "속상해", "슬퍼해"]
    
    var emotionButtonLabels = [UIButton: UILabel]()
    var emotionLabelTexts = [UILabel: String]()
    var emotionLabelCounts = [UILabel: Int]()
    
    @IBOutlet var resetCountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setEmotionDicts()
        setEmotionLabelText()
        updateEmotionLabelCount(nil)
        setCountResetButton()
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        updateEmotionLabelCount(sender)
    }
    
    @IBAction func countResetButtonTapped(_ sender: UIButton) {
        for label in emotionLabels {
            emotionLabelCounts[label] = 0
        }
        setEmotionLabelText()
    }
}

extension EmotionDiaryViewController {
    func setView() {
        emotionDiaryNavigationBar.titleView?.tintColor = .black
        emotionDiaryNavigationBar.title = "감정 다이어리"
        emotionDiaryBarItem.image = .init(systemName: "list.bullet")
        emotionDiaryBarItem.tintColor = .black
        setEmotionButtonImage()
    }
    
    func setEmotionButtonImage() {
        let buttonImages: [UIImage] = [.slime1, .slime2, .slime3, .slime4, .slime5, .slime6, .slime7, .slime8, .slime9]
        
        for (button, image) in zip(emotionButtons, buttonImages) {
            button.frame.size = CGSize(width: 85, height: 80)
            button.setImage(image, for: .normal)
        }
    }
    
    func setEmotionDicts() {
        for (button, label) in zip(emotionButtons, emotionLabels) {
            emotionButtonLabels[button] = label
        }
        for (label, text) in zip(emotionLabels, EmotionTexts) {
            emotionLabelTexts[label] = text
        }
        for label in emotionLabels {
            emotionLabelCounts[label] = 0
        }
    }
    
    func setEmotionLabelText() {
        for EmotionLabel in emotionButtonLabels.values {
            EmotionLabel.text = "\(emotionLabelTexts[EmotionLabel]!) \(emotionLabelCounts[EmotionLabel]!)"
        }
    }
    
    func updateEmotionLabelCount(_ sender: UIButton?) {
        guard let senderButton = sender else {
            return
        }
        emotionLabelCounts[emotionButtonLabels[senderButton]!]! += 1
        setEmotionLabelText()
    }
    
    func setCountResetButton() {
        resetCountButton.setTitle("새로 기록하기", for: .normal)
        resetCountButton.titleLabel?.numberOfLines = 0
        resetCountButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        resetCountButton.tintColor = .white
        resetCountButton.imageEdgeInsets.left = 5
        resetCountButton.imageEdgeInsets.right = 15
        resetCountButton.backgroundColor = .resetButton
        resetCountButton.layer.cornerRadius = 4
    }
}
