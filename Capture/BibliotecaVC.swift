//
//  BibliotecaVC.swift
//  Capture
//
//  Created by Gabriel Vinagre on 5/23/15.
//  Edited by Erika Bueno and Tatiana Magdalena.
//  Copyright (c) 2015 Gabriel Vinagre. All rights reserved.
//

import UIKit

class BibliotecaVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBSDKLoginButtonDelegate {
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    @IBAction func logMeOut(sender: AnyObject) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            navigationController!.popViewControllerAnimated(true) // dismiss
            println("User Logged Out")
            println("Going back to Main Screen")
        }

        
    }
    //colection view de capas de livro
    @IBOutlet weak var bibliCV: UICollectionView!
    
    var alert = UIAlertView()
    var imgPicker = UIImagePickerController()
    var bookId:Book!
    var coverImgPicked = UIImage()
    
    var urlImage = UIImagePickerControllerReferenceURL
    
    // botao para adicionar um novo livro
    @IBAction func addNewBook(sender: UIButton)
    {
        alert.delegate = self
        alert.message = NSLocalizedString("AddBook", comment: "AddBook")
        alert.addButtonWithTitle(NSLocalizedString("TakeCoverPicture", comment: "TakeCoverPicture"))
        alert.addButtonWithTitle(NSLocalizedString("SelectCoverPicture", comment: "SelectCoverPicture"))
        alert.addButtonWithTitle(NSLocalizedString("Cancel", comment: "Cancel"))
        alert.show()
        // imgPicker.sourceType = .photoLibrary
        //presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    //funcao para identificar que item do alerta de add livro foi clicado
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        switch buttonIndex
        {
        case 0:
            println("**BIBLIOTECAVC selecionou FOTO")
            imgPicker.sourceType = .Camera
            presentViewController(imgPicker, animated: true, completion: nil)
        case 1:
            println("**BIBLIOTECAVC selecionou uma imagem de capa")
            imgPicker.sourceType = .PhotoLibrary
            presentViewController(imgPicker, animated: true, completion: nil)
            // statusLabelAlert.text = "3rd"
        default:
            
            println("**BIBLIOTECAVC nada")
            //statusLabelAlert.text = "error"
        }
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        println("~^~^~^~^~^~^~^~^BIBLIOTECAVC: ESCOLHEU IMAGEM COM INFO...")
        
        println("**BibliotecaVC: coverImgPicked:")
        println(coverImgPicked.description)
        println(coverImgPicked.imageAsset)

        coverImgPicked = info[UIImagePickerControllerOriginalImage] as! UIImage
        let squareImage: UIImage = SquareCrop.cropToSquare(image: coverImgPicked)
        coverImgPicked = squareImage
        
        println(coverImgPicked.description)
        println(coverImgPicked.imageAsset)

        println("**BIBLIOTECAVC: PERFORMSEGUE COM addBook")
        dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("addBook", sender: self)
        
        
    }
    
    
    //envia o objeto livro para tela de media
    override func prepareForSegue (segue: UIStoryboardSegue, sender: AnyObject?)
    {
        println("**BIBLIOTECAVC: PREPAREFORSEGUE")
        
        if( segue.identifier == "bookIdSegue"){
            
            println("**BIBLIOTECAVC: PREPARE COM BOOKIDSEGUE")
            
            var mediaViewController: MediaVC = segue.destinationViewController as! MediaVC
            mediaViewController.bookId = self.bookId
        }
            
        else if(segue.identifier == "addBook"){
            
            println("**BIBLIOTECAVC: PREPARE COM addBook")
            
            var imgCover = segue.destinationViewController as! AddBookVC
            //imgCover.imageDetail.image = coverImgPicked
            imgCover.image = coverImgPicked
            imgCover.edition = false
            //            imgCover.enableCoverDescpEdi = true
            //    imgCover.imageDetail.image = coverImgPicked
            // imgCover.imageDetail.image = sender as? UIImage
            //            imgCover.imageDetail.contentMode = .ScaleAspectFit
        }
    }
    
    

    
    

    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        coverImgPicked = image
//        dismissViewControllerAnimated(true, completion: nil)
//        performSegueWithIdentifier("addBook", sender: self)
    
    //*************
    
//        println(editingInfo.description)
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        coverImgPicked = image
//        var controller =
//        coverImgPicked = image
       // coverImgPicked
        //println( coverImgPicked. )
     //   dismissViewControllerAnimated(true, completion: nil)
//        imgPicker.presentViewController(sef, animated: true, completion: nil)
//        dismissViewControllerAnimated(true, completion: nil)
//        self.performSegueWithIdentifier("livroSegue", sender: self.coverImgPicked)
        
       //  self.coverImgPicked = image
        
//        self.dismissViewControllerAnimated(true, completion: { () -> Void in
//           
//            self.performSegueWithIdentifier("addBook", sender: nil)
//
//        })
    
    
    //************
   // }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //determina quantas celulas existem naquele sessao da collection
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return Data.sharedInstance.allBooks.count
    }
    
    
  
    
    //cria as celulas da collection
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell: BiblioColViewCCell = collectionView.dequeueReusableCellWithReuseIdentifier("bibliCell", forIndexPath: indexPath) as! BiblioColViewCCell
        var bookAux:Book = Data.sharedInstance.allBooks[indexPath.item]
        
        cell.bookTitle.text = bookAux.title
        
        cell.bookCoverImage.image = UIImage(named: bookAux.cover.path)
        return cell
    }
    
    //Reconhecer celula da collection pressionada pelo user
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        print("**BIBLIOTECAVC indexPath.row: ")
        println(indexPath.row)
        
        bookId = Data.sharedInstance.allBooks[indexPath.item]
        
        print("**BIBLIOTECAVC book title que foi pego: ")
        println(bookId.title)
        
        performSegueWithIdentifier("bookIdSegue", sender: self)
        
    }
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 112.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 0.72)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationBar.topItem.title = "Capta"
        
//        navigationBar.topItem.title = "some title"
        self.navigationController?.navigationBar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.topItem?.title = "CAPTA"
        //self.navigationController?.navigationBar.topItem?
        
//        let navBackButton = UIImage(named: "BookDetail_ARROW")
//        let navBackButtonView = UIImageView(image: navBackButton)
//        let navBackground = UIImage(named: "BookDetail_navigationBarBlurTransparent")
        
//        UINavigationBar.appearance().setBackgroundImage(navBackground, forBarMetrics: .Default)
        
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 159.0/255.0, green: 78.0/255.0, blue: 41.0/255.0, alpha: 1.0)
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //img picker da camera
        imgPicker.delegate = self
        
        //pega todos os livros cadastrados e coloca no data
        DAO.getAllBooks()
        
        
        //        println("print do data**********")
        //        for(var i = 0; i < Data.sharedInstance.allBooks.count; i++)
        //        {
        //            println("*book\(i+1): \(Data.sharedInstance.allBooks[i].title)")
        //            for (var j = 0; j < Data.sharedInstance.allBooks[i].media.count; j++)
        //            {
        //                println(Data.sharedInstance.allBooks[i].media[j].path)
        //            }
        //        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
        bibliCV.reloadData()
    
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "BookDetail_navigationBarBlurTransparent"), forBarPosition: UIBarPosition.Top, barMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 112.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 0.72)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    
    }
    
    
}