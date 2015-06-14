//
//  SquareCrop.swift
//  SquareCrop
//
//  Created by Erika Bueno on 31/05/15.
//  Copyright (c) 2015 Erika Bueno. All rights reserved.
//

/*

Adiciona essas duas linhas ANTES da linha
println(coverImgPicked.description)
no BibliotecaVC.swift

let squareImage: UIImage = SquareCrop.cropToSquare(image: coverImgPicked)
coverImgPicked = squareImage

*/

import UIKit

class SquareCrop: NSObject {
    
    static func cropToSquare(image originalImage: UIImage) -> UIImage {
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage)!
        let contextSize: CGSize = contextImage.size
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)
        
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)!
        
        return image
    }
    
}
