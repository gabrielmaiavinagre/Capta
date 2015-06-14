//
//  SaveLoadCameraRow.swift
//  Capture
//
//  Created by Gabriel Vinagre on 5/28/15.
//  Edited by Tatiana Magdalena.
//  Copyright (c) 2015 Gabriel Vinagre. All rights reserved.
//

import UIKit
//var myImageName:String!

//// Get the documents Directory
//
//func documentsDirectory() -> String {
//    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
//    return documentsFolderPath
//}
//// Get path for a file in the directory
//
//func fileInDocumentsDirectory(filename: String) -> String {
//    return documentsDirectory().stringByAppendingPathComponent(filename)
//}
//
//// Define the specific path, image name
//let imagePath = fileInDocumentsDirectory(myImageName)

class SaveAndLoadImage{
    
    class func saveCoverImage (image: UIImage, title:String, synopsis: String) {
        
        println("&&&&&SAVEANDLOADIMAGE: SAVECOVERIMAGE")
        
        println("**SAVEANDLOADIMAGE: TITULO DA CAPA A SER SALVA")
        println(title)
        println("**SAVEANDLOADIMAGE: ORIENTACAO DA IMAGEM _____>")
        println(image.imageOrientation)
        
        let pngImageData = UIImagePNGRepresentation(image)
        let imageIndex = DAO.booksWithSameName(title)
        var pngPath = NSHomeDirectory()
        
        if imageIndex == 0 {
            pngPath = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(title).png")
        }
        else if imageIndex > 0 {
            pngPath = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(title)_\(imageIndex).png")
        }
        
        var book:Book!
        var cover: Media!
        
        cover = Media(name: "\(title)", path: pngPath, type: "coverImage")
        
//        media.name = "\(title).png"
//        media.path = pngPath
//        media.type = "coverImage"
        
//        book.title = title
//        book.media[0].name = "\(title).png"
//        book.media[0].path = pngPath
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        // let result = pngImageData.writeToFile(path, atomically: true)
       // let result = pngImageData.writeToFile(pngPath, atomically: true)
        
        UIImagePNGRepresentation(image).writeToFile(pngPath, atomically: true)
       // DAO.addBook()
        book = Book(title: title, cover: cover, media: [Media]())
        book.synopsis = synopsis
        
        DAO.addBook(book)
    }
    
    class func saveInternImage (image: UIImage, name: String, description: String, toBook: Book) {
        
        println("&&&&&SAVEANDLOADIMAGE: SAVECOVERIMAGE")
        
        let pngImageData = UIImagePNGRepresentation(image)
        let imageIndex = DAO.mediasWithSameName(name, book: toBook)
        var pngPath = NSHomeDirectory()
        
        if imageIndex == 0 {
            pngPath = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(name).png")
        }
        else if imageIndex > 0 {
            pngPath = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(name)_\(imageIndex).png")
        }
        
        UIImagePNGRepresentation(image).writeToFile(pngPath, atomically: true)
        
        var internImage = Media(name: name, path: pngPath, type: "internImage")
        internImage.description = description
        DAO.addMedia(internImage, toBook: toBook)
    }
    
    
    
//    class func saveImage (image: UIImage, path: String ) -> Bool{
//        
//        let pngImageData = UIImagePNGRepresentation(image)
//        let pngPath = NSHomeDirectory().stringByAppendingPathComponent("Documents/Gabriel.png")
//        
//        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
//       // let result = pngImageData.writeToFile(path, atomically: true)
//        let result = pngImageData.writeToFile(pngPath, atomically: true)
//        
//        return result
//        
//    }
    
    
   class func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            println("missing image at: (path)")
        }
        println("(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    
}
