//
//  MenuView.swift
//  giis4
//
//  Created by никита уваров on 3.11.21.
//

import UIKit

enum ChosenImageKind {
    case cell, background
}

class MenuView: UIView {
    var onDidTapImage: ((Int) -> Void)?
    var isEnableChoseImage = false
    var chosenImageKind: ChosenImageKind = .background

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setPlayButton()
        setChangeBackgroundColorButton()
        setChangeImageButton()
    }
    
    func setPlayButton() {
        let playButton = UIButton()
        playButton.frame = CGRect(x: frame.width / 6, y: frame.height / 6, width: frame.width / 1.5, height: frame.height / 10)
        addSubview(playButton)
        playButton.setTitle("play", for: .normal)
        playButton.backgroundColor = .systemBrown
        playButton.layer.cornerRadius = 30
        playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
    }
    
    @objc func playButtonAction() {
        removeFromSuperview()
    }
    
    func setChangeBackgroundColorButton() {
        let changeColorButton = UIButton()
        changeColorButton.frame = CGRect(x: frame.width / 6, y: frame.height / 6 + 1.5 * frame.height / 10, width: frame.width / 1.5, height: frame.height / 10)
        addSubview(changeColorButton)
        changeColorButton.setTitle("change background", for: .normal)
        changeColorButton.backgroundColor = .systemBrown
        changeColorButton.layer.cornerRadius = 30
        changeColorButton.addTarget(self, action: #selector(changeBackgroundColorButtonAction), for: .touchUpInside)
    }
    
    @objc func changeBackgroundColorButtonAction() {
        let choseImageStackView = UIStackView()
        choseImageStackView.frame = frame
        choseImageStackView.backgroundColor = .systemGreen
        choseImageStackView.alignment = .fill
        choseImageStackView.distribution = .fillEqually
        choseImageStackView.axis = .vertical
        addSubview(choseImageStackView)
        
        let image1 = UIImageView()
        image1.image = UIImage(named: "1")
        choseImageStackView.addArrangedSubview(image1)
        
        let image2 = UIImageView()
        image2.image = UIImage(named: "2")
        choseImageStackView.addArrangedSubview(image2)
        
        let image3 = UIImageView()
        image3.image = UIImage(named: "3")
        choseImageStackView.addArrangedSubview(image3)
        
        let image4 = UIImageView()
        image4.image = UIImage(named: "4")
        choseImageStackView.addArrangedSubview(image4)
        
        chosenImageKind = .background
        isEnableChoseImage = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnableChoseImage else { return }
        if let touch = touches.first {
            if touch.location(in: self).y < frame.height / 4 {
                onDidTapImage?(1)
            } else if touch.location(in: self).y < 2 * frame.height / 4 {
                onDidTapImage?(2)
            } else if touch.location(in: self).y < 3 * frame.height / 4 {
                onDidTapImage?(3)
            } else if touch.location(in: self).y < frame.height {
                onDidTapImage?(4)
            }
            isEnableChoseImage = false
        }
    }
    
    func setChangeImageButton() {
        let changeColorButton = UIButton()
        changeColorButton.frame = CGRect(x: frame.width / 6, y: frame.height / 6 + 3 * frame.height / 10, width: frame.width / 1.5, height: frame.height / 10)
        addSubview(changeColorButton)
        changeColorButton.setTitle("change item image", for: .normal)
        changeColorButton.backgroundColor = .systemBrown
        changeColorButton.layer.cornerRadius = 30
        changeColorButton.addTarget(self, action: #selector(changeImageButtonAction), for: .touchUpInside)
    }
    
    @objc func changeImageButtonAction() {
        changeBackgroundColorButtonAction()
        chosenImageKind = .cell
    }
}
