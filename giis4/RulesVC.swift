//
//  RulesVC.swift
//  giis4
//
//  Created by никита уваров on 16.11.23.
//

import Foundation
import UIKit

class RulesVC: UIViewController {
    let rulseLabel = UILabel()
    let okBtton = UIButton()
    
    let scringSize = UIScreen.main.bounds

    let rulesText = "передвигайте ячейки пока не соберете пазл в правильном порядке, для того чтоб передвинуть ячейку недходимо нажать на нее пальце и перетащить на место пустой ячейки. Двигать можно только те ячейки которые расположены непосредство рядом с пустой ячейкой."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rulesView = UIView()
        rulesView.frame = view.frame
        rulesView.backgroundColor = UIColor(red: 3 / 255, green: 34 / 255, blue: 133 / 255, alpha: 1)
        view.addSubview(rulesView)

        rulseLabel.frame.size = CGSize(width: scringSize.width / 1.2, height: scringSize.height / 2)
        rulseLabel.center = CGPoint(x: view.center.x, y: 200)
        rulseLabel.text = rulesText
        rulseLabel.font = UIFont(name: "Helvetica Neue", size: 24)
        rulseLabel.numberOfLines = 0
        
        okBtton.frame.size = CGSize(width: scringSize.width / 2, height: scringSize.width / 8)
        okBtton.center = CGPoint(x: view.center.x, y: 250 + scringSize.height / 2)
        okBtton.layer.cornerRadius = 23
        okBtton.clipsToBounds = true
        okBtton.backgroundColor = UIColor(red: 30 / 255, green: 34 / 255, blue: 85 / 255, alpha: 1)
        okBtton.setTitle("OK", for: .normal)
        okBtton.addTarget(self, action: #selector(tapOKBtton), for: .touchUpInside)
        rulesView.addSubview(rulseLabel)
        rulesView.addSubview(okBtton)
    }
    
    @objc func tapOKBtton() {
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveLinear, animations: {
            self.okBtton.backgroundColor = UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)
            self.dismiss(animated: true)
        })
    }
}
