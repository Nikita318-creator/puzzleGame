//
//  Model.swift
//  giis4
//
//  Created by никита уваров on 3.11.21.
//

import UIKit

class Model {
    let countRow = 4
    let countCell = 16
    var voidCellNumber = 4
    var currentCell = 0
    var backgroundImageNumder = 1

    var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
    var allImages: [UIImage?] = []

    func createImageCells(numberImage: Int) {
        allImages = []
        
        if let image = UIImage(named: String(numberImage)) {
            let image1 = image.topHalf?.topHalf?.leftHalf?.leftHalf
            allImages.append(contentsOf: [image1])
            
            let image2 = image.topHalf?.topHalf?.leftHalf?.rightHalf
            allImages.append(contentsOf: [image2])
            
            let image3 = image.topHalf?.topHalf?.rightHalf?.leftHalf
            allImages.append(contentsOf: [image3])
            
            let image4 = image.topHalf?.topHalf?.rightHalf?.rightHalf
            allImages.append(contentsOf: [image4])
            
            let image5 = image.topHalf?.bottomHalf?.leftHalf?.leftHalf
            allImages.append(contentsOf: [image5])
            
            let image6 = image.topHalf?.bottomHalf?.leftHalf?.rightHalf
            allImages.append(contentsOf: [image6])
            
            let image7 = image.topHalf?.bottomHalf?.rightHalf?.leftHalf
            allImages.append(contentsOf: [image7])
            
            let image8 = image.topHalf?.bottomHalf?.rightHalf?.rightHalf
            allImages.append(contentsOf: [image8])
            
            let image9 = image.bottomHalf?.topHalf?.leftHalf?.leftHalf
            allImages.append(contentsOf: [image9])
            
            let image10 = image.bottomHalf?.topHalf?.leftHalf?.rightHalf
            allImages.append(contentsOf: [image10])
            
            let image11 = image.bottomHalf?.topHalf?.rightHalf?.leftHalf
            allImages.append(contentsOf: [image11])
            
            let image12 = image.bottomHalf?.topHalf?.rightHalf?.rightHalf
            allImages.append(contentsOf: [image12])
            
            let image13 = image.bottomHalf?.topHalf?.leftHalf?.leftHalf
            allImages.append(contentsOf: [image13])
            
            let image14 = image.bottomHalf?.topHalf?.leftHalf?.rightHalf
            allImages.append(contentsOf: [image14])
            
            let image15 = image.bottomHalf?.topHalf?.rightHalf?.leftHalf
            allImages.append(contentsOf: [image15])
            
            let image16 = image.bottomHalf?.topHalf?.rightHalf?.rightHalf
            allImages.append(contentsOf: [image16])
        }
    }
}

extension UIImage {
    var topHalf: UIImage? {
        guard let cgImage = cgImage, let image = cgImage.cropping(to: CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height/2))) else { return nil }
        return UIImage(cgImage: image, scale: 1, orientation: imageOrientation)
    }
    var bottomHalf: UIImage? {
        guard let cgImage = cgImage, let image = cgImage.cropping(to: CGRect(origin: CGPoint(x: 0,  y: CGFloat(Int(size.height)-Int(size.height/2))), size: CGSize(width: size.width, height: CGFloat(Int(size.height) - Int(size.height/2))))) else { return nil }
        return UIImage(cgImage: image)
    }
    var leftHalf: UIImage? {
        guard let cgImage = cgImage, let image = cgImage.cropping(to: CGRect(origin: .zero, size: CGSize(width: size.width/2, height: size.height))) else { return nil }
        return UIImage(cgImage: image)
    }
    var rightHalf: UIImage? {
        guard let cgImage = cgImage, let image = cgImage.cropping(to: CGRect(origin: CGPoint(x: CGFloat(Int(size.width)-Int((size.width/2))), y: 0), size: CGSize(width: CGFloat(Int(size.width)-Int((size.width/2))), height: size.height)))
            else { return nil }
        return UIImage(cgImage: image)
    }
}
