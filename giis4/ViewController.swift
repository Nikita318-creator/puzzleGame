//
//  ViewController.swift
//  giis4
//
//  Created by никита уваров on 3.11.21.
//

import UIKit

enum CellsType {
    case digit, image
}

class ViewController: UIViewController {
    let scringSize = UIScreen.main.bounds
    let boardView = UIView()
    let restartButton = UIButton()
    let backToMenuButton = UIButton()
    let imageView = UIImageView()
    var cells: [UIView] = []
    
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBoard()
        setCells()
        setRestartButton()
        setBackToMenuButton()
        setMenu()
    }
    
    func setBoard() {
        view.addSubview(boardView)
        boardView.frame = CGRect(x: 0, y: scringSize.width / 2, width: scringSize.width, height: scringSize.width)
        boardView.backgroundColor = .systemBlue
        
        imageView.frame = CGRect(x: 0, y: 0, width: scringSize.width, height: scringSize.width)
        imageView.image = UIImage(named: "")
        boardView.addSubview(imageView)
    }
    
    func setCells(cellsType: CellsType = .digit) {
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
                    cellView.frame = CGRect(x: CGFloat(itemRow) * scringSize.width / 4, y: CGFloat(item) * scringSize.width / 4, width: widthOneCell, height: widthOneCell)
                    cells.append(contentsOf: [cellView])
                    continue
                }
                let cellView = CellView(cellsType: cellsType)
                boardView.addSubview(cellView)
                cellView.frame = CGRect(x: CGFloat(itemRow) * scringSize.width / 4, y: CGFloat(item) * scringSize.width / 4, width: widthOneCell, height: widthOneCell)
                let image = cellsType == .digit ? nil : model.allImages[model.currentCell]
                cellView.setup(numberCell: model.numbers[model.currentCell], image: image)
                model.currentCell += 1
                cells.append(contentsOf: [cellView])
                
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
        restartButton.frame.size = CGSize(width: scringSize.width / 4, height: scringSize.width / 8)
        restartButton.center = CGPoint(x: view.center.x, y: scringSize.width + scringSize.width / 2 + 70)
        restartButton.backgroundColor = .darkText
        restartButton.setTitle("restart", for: .normal)
        restartButton.addTarget(self, action: #selector(tapRestartButton), for: .touchUpInside)
    }
    
    func setBackToMenuButton() {
        view.addSubview(backToMenuButton)
        backToMenuButton.frame.size = CGSize(width: scringSize.width / 2, height: scringSize.width / 8)
        backToMenuButton.center = CGPoint(x: view.center.x, y: scringSize.width / 2 - 100)
        backToMenuButton.backgroundColor = .darkText
        backToMenuButton.setTitle("back to menu", for: .normal)
        backToMenuButton.addTarget(self, action: #selector(tapBackToMenuButton), for: .touchUpInside)
    }
    
    @objc func tapRestartButton() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveLinear, animations: {
            self.boardView.subviews.forEach {
                if !($0 is UIImageView) {
                    $0.removeFromSuperview()
                }
            }
            self.setCells()
        })
    }
    
    @objc func tapBackToMenuButton() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            self.setMenu()
        })
    }
    
    func isMove(movedCell number: Int) -> Bool {
        return (cells[self.model.voidCellNumber].frame.midX == cells[number].frame.midX
               && abs(cells[self.model.voidCellNumber].frame.midY - cells[number].frame.midY) == scringSize.width / 4)
                || (abs(cells[self.model.voidCellNumber].frame.midX - cells[number].frame.midX) == scringSize.width / 4
                    && cells[self.model.voidCellNumber].frame.midY == cells[number].frame.midY)
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
    
    func setMenu() {
        let menuView = MenuView()
        view.addSubview(menuView)
        menuView.frame = scringSize
        menuView.setup()
        menuView.onDidTapImage = { number in
            if menuView.chosenImageKind == .background {
                self.model.backgroundImageNumder = number
                self.imageView.image = UIImage(named: String(self.model.backgroundImageNumder))
                menuView.removeFromSuperview()
            } else {
                self.boardView.subviews.forEach {
                    if !($0 is UIImageView) {
                        $0.removeFromSuperview()
                    }
                }
                self.model.createImageCells(numberImage: number)
                self.setCells(cellsType: .image)
                menuView.removeFromSuperview()
            }
        }
    }
}

