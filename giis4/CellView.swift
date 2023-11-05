//
//  CellView.swift
//  giis4
//
//  Created by никита уваров on 3.11.21.
//

import UIKit

class CellView: UIView {
    var onDidTapCell: ((Int) -> Void)?
    var numberCellOnBoard = 0
    let cellsType: CellsType
    
    init(cellsType: CellsType = .digit) {
        self.cellsType = cellsType
        super.init(frame: .zero)
        backgroundColor = .systemGreen
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(numberCell: Int, image: UIImage?) {
        if cellsType == .digit {
            let label = UILabel()
            addSubview(label)
            label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            label.text = String(numberCell)
            label.textAlignment = .center
        } else {
            let imageView = UIImageView()
            addSubview(imageView)
            imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            imageView.image = image
        }
        
        let tapButton = UIButton()
        tapButton.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(tapButton)
        tapButton.addTarget(self, action: #selector(tapButtonAction), for: .touchUpInside)
    }
    
    @objc func tapButtonAction() {
        onDidTapCell?(numberCellOnBoard)
    }
}
