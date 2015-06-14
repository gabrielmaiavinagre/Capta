//
//  InternImgDetails.swift
//  Capture
//
//  Created by Gabriel Vinagre on 5/28/15.
//  Edited by Daphne Schinazi and Erika Bueno.
//  Copyright (c) 2015 Gabriel Vinagre. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class InternImgDetails: UIViewController {
    
//    @IBAction func concluido(sender: AnyObject) {
//    }
    
    var enableCoverDescpEdi: Bool!
    var imageId:Media!
    var bookId:Book!
    
    var image : UIImage!
    var alert = UIAlertView()

   
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var mediaTitle: UITextView!
    @IBOutlet weak var mediaDescription: UITextView! // postText
    
//    @IBAction func editDescriptionBt(sender: AnyObject) {
//        println("**INTERNIMGDETAILS: botao pressionado")
//        println(mediaDescription.editable)
//        println("**INTERNIMGDETAILS: passou do press")
//        
//        //description false nao permite edicao
//        //if(descriptionDetail.editable==false || enableCoverDescpEdi == false ){
//        if(mediaDescription.editable==false){
//            
//            println("**INTERNIMGDETAILS: description era false e ficou true")
//            print("**INTERNIMGDETAILS: Antes: ")
//            println(mediaDescription)
//            
//            mediaDescription.editable=true
//            print("**INTERNIMGDETAILS: Depois: ")
//            println(mediaDescription.editable)
//
//            //  enableCoverDescpEdi = false
//        }
//            
//            //description for true permite editacao
//        else{
//            println("**INTERNIMGDETAILS: EDITABLE == TRUE")
//            mediaDescription.editable=false
//            // enableCoverDescpEdi = false
//        }
//        
//    }
    
//    @IBAction func believe(sender: AnyObject) {
//        
//        var activityItems: [AnyObject]?
//        let image = mediaImage!.image
//        
//        if (mediaImage!.image != nil) {
//            activityItems = [mediaDescription.text, mediaImage!.image!]
//        } else {
//            activityItems = [mediaDescription.text]
//        }
//        
//        let activityController = UIActivityViewController(activityItems: activityItems!, applicationActivities: nil)
//        self.presentViewController(activityController, animated: true, completion: nil)
//
//        
//    }
    
    @IBAction func deleteButton(sender: UIButton) {
        alert.delegate = self
        alert.message = nil
        alert.addButtonWithTitle(NSLocalizedString("Share", comment: "Share"))
        alert.addButtonWithTitle(NSLocalizedString("Edit", comment: "Edit"))
        alert.addButtonWithTitle(NSLocalizedString("Delete", comment: "Delete"))
        alert.addButtonWithTitle(NSLocalizedString("Cancel", comment: "Cancel"))
        alert.show()
    }
  
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex
        {
        case 0:
            var activityItems: [AnyObject]?
            let image = mediaImage!.image
            
            if (mediaImage!.image != nil) {
                activityItems = [mediaTitle.text, mediaImage!.image!]
            } else {
                activityItems = [mediaTitle.text]
            }
            
            let activityController = UIActivityViewController(activityItems: activityItems!, applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
            
        case 1:
            performSegueWithIdentifier("editMedia", sender: self)
            
        case 2:
            println("**INTERNIMGDETAILS: pressionou delete")
            DAO.removeMedia(imageId, fromBook: bookId)
            navigationController!.popViewControllerAnimated(true)
            
        default:
            
            println("**INTERNIMGDETAILS: nada")
            //statusLabelAlert.text = "error"
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editMedia" {
            
            var addMediaController: AddMediaVC = segue.destinationViewController as! AddMediaVC
            
            addMediaController.bookId = self.bookId
            addMediaController.imageId = self.imageId
            addMediaController.image = self.mediaImage.image
            addMediaController.edition = true
            
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
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.imageId.name
        
        self.image = SaveAndLoadImage.loadImageFromPath(self.imageId.path)
        self.mediaImage?.image =  SaveAndLoadImage.loadImageFromPath(self.imageId.path)
        self.mediaTitle.text = self.imageId.name
        self.mediaDescription.text = self.imageId.description
        
        mediaDescription.editable = false
        mediaTitle.editable = false
        
        mediaDescription.userInteractionEnabled = true
        mediaTitle.userInteractionEnabled = true
        
        
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
        
        mediaDescription.userInteractionEnabled = true
    }

    
}
