//
//  AddBookVC.swift
//  Capture
//
//  Created by Gabriel Vinagre on 5/23/15.
//  Edited by Tatiana Magdalena.
//  Copyright (c) 2015 Gabriel Vinagre. All rights reserved.
//

import UIKit

class AddBookVC: UIViewController {

    var edition: Bool! 
    
//    var enableCoverDescpEdi: Bool!
    var imageId:Media!
    var bookId:Book!
    
    var alert = UIAlertView()
    
    var image : UIImage!
    @IBOutlet weak var coverImage: UIImageView?
    @IBOutlet weak var bookSynopsis: UITextView!
    @IBOutlet weak var bookTitle: UITextView!
    
//    @IBOutlet weak var bookAuthor: UITextField!
//    @IBOutlet weak var bookCategory: UITextField!
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func save(sender: AnyObject) {
        
        println("**IMAGEDETAILSVC: BOTAO DE CONCLUIDO")
        
        println("**IMAGEDETAILSVC descriptionDetailText:: ")
        println(bookSynopsis.text )
        
        println("**IMAGEDETAILSVC descricao imagem")
        println(image.description)
        
        println("**IMAGEDETAILSVC chamou a classe")
        
        
        if(bookTitle.text != "") {
        
            if edition == false {
                SaveAndLoadImage.saveCoverImage(image, title: bookTitle.text, synopsis: bookSynopsis.text)
                
                navigationController?.popViewControllerAnimated(true)
            }
            else {
                
                var newCover: Media = Media(name: bookTitle.text, path: bookId.cover.path, type: bookId.cover.type)
                
                var newBook: Book = Book(title: bookTitle.text, cover: newCover, media: bookId.media)
                newBook.synopsis = bookSynopsis.text
                
                DAO.updateBook(bookId, newBook: newBook)
                
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
            }
            
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        SaveAndLoadImage.saveImage(descriptionDetail.text,UIImage(data: NSData(contentsOfURL: NSURL(string:"\(descriptionDetail.text).png")!)!)!)
       
//        SaveAndLoadImage.saveImage(descriptionDetail.text,UIImage(data: NSData(contentsOfURL: NSURL(string:"gabriel.png")!)!)!)
        
        
       // dismissViewControllerAnimated(true, completion: nil)
        
        //bookId.media[0].path = "\(descriptionDetail.text).png"
      //  bookId.media[0].name = descriptionDetail.text
        //DAO.addBook(bookId)
        }
        else {
            alert.delegate = self
            alert.message = NSLocalizedString("NoTitleAlert", comment: "NoTitleAlert")
            alert.addButtonWithTitle(NSLocalizedString("NoTitleAlertButton", comment: "NoTitleAlertButton"))
            alert.show()
        }
    }
    
    //description for true permite editacao
    
   
    
    override func viewDidLoad() {
        
        println("&&&&&IMAGEDETAILSVC: VIEWDIDLOAD")
        
        super.viewDidLoad()
        self.coverImage?.image =  self.image
        
        if edition == true {
            self.bookTitle.text = self.bookId.title
            self.bookSynopsis.text = self.bookId.synopsis
        }
        
        self.bookSynopsis.editable = true
        self.bookTitle.editable = true


        
        print("**IMAGEDETAILSVC: editable")
        println(bookSynopsis.editable)
        println("**IMAGEDETAILSVC: termina aqui o view did LOAD")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 180
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 180
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        bookSynopsis.resignFirstResponder()
        bookTitle.resignFirstResponder()
//        bookAuthor.resignFirstResponder()
//        bookCategory.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        println("&&&&&IMAGEDETAILSVC: VIEWWILLAPPEAR")
        
//        println("view did appear--->")
//        println("antes--->")
//        println(descriptionDetail.editable)
//        descriptionDetail.editable = false
//        println("depois--->")
//        println(descriptionDetail.editable)
//        println("termina aqui o view did appear")
//
//        println(image.description)
        
//        descriptionDetail.userInteractionEnabled = true
//        imageDetail.image = UIImage(named: imageId.path)
//        descriptionDetail.text = imageId.name
        
        //self.imageDetail = UIImageView(image: self.image)
        
        
    }

    
    
    
}
