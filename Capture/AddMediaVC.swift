//
//  AddMediaVC.swift
//  Capta
//
//  Created by Tatiana Magdalena on 6/8/15.
//  Copyright (c) 2015 Tatiana Magdalena. All rights reserved.
//

import UIKit

class AddMediaVC: UIViewController {
    
    var edition: Bool!
    
//    var mediaDescriptionEdit: Bool!
    var imageId:Media!
    var bookId:Book!
    
    var image : UIImage!
    @IBOutlet weak var mediaImage: UIImageView?
    @IBOutlet weak var mediaTitle: UITextView!
    @IBOutlet weak var mediaDescription: UITextView!
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func save(sender: AnyObject) {
        
        println("**ADDMEDIAVC: ")
        print("bookId: ")
        println(bookId.title)
        
        print("mediaTitle: ")
        println(mediaTitle.text)
        
        print("mediaDescription: ")
        println(mediaDescription.text)
        
        print("image: ")
        println(image.description)
        
        if edition == false {
            SaveAndLoadImage.saveInternImage(image, name: mediaTitle.text, description: mediaDescription.text, toBook: bookId)
            
            navigationController?.popViewControllerAnimated(true)
            
        }
        else {
            var newMedia: Media = Media(name: mediaTitle.text, path: imageId.path, type: imageId.type)
            newMedia.description = mediaDescription.text
            
            DAO.updateMedia(bookId, oldMedia: imageId, newMedia: newMedia)
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        }
        
        
    }
    
    
    
    
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        mediaDescription.resignFirstResponder()
        mediaTitle.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mediaImage?.image =  self.image
        
        if edition == true {
            self.mediaTitle.text = self.imageId.name
            self.mediaDescription.text = self.imageId.description
        }
        
        self.mediaDescription.editable = true
        self.mediaTitle.editable = true
        
        println("view did appear--->")
        println("antes--->")
        println(mediaDescription.editable)
        //descriptionDetail.editable = false
        println("depois--->")
        println(mediaDescription.editable)
        println("termina aqui o view did appear")
        
        // println(image.description)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
