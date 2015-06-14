//
//  BookDetailVC.swift
//  Capta
//
//  Created by Tatiana Magdalena on 6/8/15.
//  Copyright (c) 2015 Tatiana Magdalena. All rights reserved.
//

import UIKit

class BookDetailVC: UIViewController {
    
    var image : UIImage!
    var bookId:Book!
    
  //  @IBOutlet weak var scroller:UIScrollView!

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookTitle: UITextView!
    @IBOutlet weak var bookSynopsis: UITextView!
    
    //    @IBOutlet weak var bookAuthor: UITextField!
    //    @IBOutlet weak var bookCategory: UITextField!
    
    var alert = UIAlertView()
    
    
    @IBAction func selectOptions(sender: UIButton) {
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
            let image = coverImage!.image
            
            if (coverImage!.image != nil) {
                activityItems = [bookTitle.text, coverImage!.image!]
            } else {
                activityItems = [bookTitle.text]
            }
            
            let activityController = UIActivityViewController(activityItems: activityItems!, applicationActivities: nil)
            self.presentViewController(activityController, animated: true, completion: nil)
            
        case 1:
            performSegueWithIdentifier("editBook", sender: self)
            
        case 2:
            DAO.removeBook(bookId)
//            navigationController!.popViewControllerAnimated(true)
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as! [UIViewController];
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
            
        default:
            
            println("**INTERNIMGDETAILS: nada")
            //statusLabelAlert.text = "error"
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editBook" {
            
            var bookDetailsController: AddBookVC = segue.destinationViewController as! AddBookVC
            
            bookDetailsController.bookId = self.bookId
            bookDetailsController.image = self.coverImage.image
            bookDetailsController.edition = true
            
        }
    }

//    
//    @IBAction func selectOptions(sender: AnyObject) {
//        
//        let actionSheet = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
//        
//        let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            
//            //Codigo caso seja pressionado delete
//            println("File Deleted")
//        })
//        
//        let editAction = UIAlertAction(title: "Edit", style: .Default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            
//            //Codigo caso seja pressionado Edit
//            println("Edit File")
//        })
//        
//        //
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
//            (alert: UIAlertAction!) -> Void in
//            
//            //Codigo caso seja pressionado Cancel
//            println("Cancelled")
//        })
//        
//        actionSheet.addAction(deleteAction)
//        actionSheet.addAction(editAction)
//        actionSheet.addAction(cancelAction)
//        
//        self.presentViewController(actionSheet, animated: true, completion: nil)
//        
//        
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BookDetail_BG")!)
        
        self.coverImage.image = UIImage(named: self.bookId.cover.path)
        self.bookTitle.text = self.bookId.title
        self.bookSynopsis.text = self.bookId.synopsis
        
        bookSynopsis.userInteractionEnabled = true
        bookTitle.userInteractionEnabled = true
        bookSynopsis.userInteractionEnabled = true
        
        bookTitle.editable = false
        bookSynopsis.editable = false
        
        
        //self.view.
        
       // self.view.addConstraints( [coverImage])
        
        //self.view.addConstraint(coverImage.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0,0,0,0))
     //   scroller.contentSize.height = 700
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        bookSynopsis.resignFirstResponder()
        bookTitle.resignFirstResponder()
//        bookAuthor.resignFirstResponder()
//        bookCategory.resignFirstResponder()
    }

    
    
}
