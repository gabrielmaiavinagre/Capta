//
//  BibliotecaVC.swift
//  Capture
//
//  Created by Gabriel Vinagre on 5/23/15.
//  Edited by Daphne Schinazi and Tatiana Magdalena.
//  Copyright (c) 2015 Gabriel Vinagre. All rights reserved.
//

import UIKit



class MediaVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var MediaCollectionView: UICollectionView!
    

   // var bookID:String = livroID.text
    
    //var bookID: String!
   // var livrinhoID=String()
    //var quantDeMedia:[Int]!
    var mediaSelecionada=String()
    var bookId:Book!
    var mediaId:Media!
    var imgInternPicker = UIImagePickerController()
    var internImgPicked = UIImage()
    var alert = UIAlertView()
    
    
    @IBAction func addMedia(sender: UIButton) {
        
        println("~^~^~^~^~^~^~^~^MEDIAVC: ALERT DO ADD MEDIA")
        
        alert.delegate = self
        alert.message = NSLocalizedString("AddImage", comment: "AdImage")
        alert.addButtonWithTitle(NSLocalizedString("TakePicture", comment: "TakePicture"))
        alert.addButtonWithTitle(NSLocalizedString("SelectPicture", comment: "SelectPicture"))
        alert.addButtonWithTitle(NSLocalizedString("Cancel", comment: "Cancel"))
        alert.show()
        
    }
    
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        println("~^~^~^~^~^~^~^~^MEDIAVC: CLICOU EM BOTAO DO ALERT")
        
        switch buttonIndex
        {
        case 0:
            println("MEDIAVC selecionou FOTO")
            imgInternPicker.sourceType = .Camera
            presentViewController(imgInternPicker, animated: true, completion: nil)
        case 1:
            println("MEDIAVC selecionou uma imagem de capa")
            imgInternPicker.sourceType = .PhotoLibrary
            presentViewController(imgInternPicker, animated: true, completion: nil)
            // statusLabelAlert.text = "3rd"
        default:
            
            println("MEDIAVC nada")
            //statusLabelAlert.text = "error"
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        println("~^~^~^~^~^~^~^~^MEDIAVC: ESCOLHEU IMAGEM COM INFO...")
        
        println("interImgPicked:")
        println(internImgPicked.description)
        println(internImgPicked.imageAsset)
        println("*********************")
        
        internImgPicked = info[UIImagePickerControllerOriginalImage] as! UIImage
        let squareImage: UIImage = SquareCrop.cropToSquare(image: internImgPicked)
        internImgPicked = squareImage
        
        println(internImgPicked.description)
        println(internImgPicked.imageAsset)
        
        dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("addInternMedia", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        println("~^~^~^~^~^~^~^~^MEDIAVC: PREPAREFORSEGUE")
        
        if(segue.identifier == "imageDetailSegue"){
            
            println("~^~^~^~^~^~^~^~^MEDIAVC: SEGUE = IMAGEDETAILSEGUE")
            
            var imageDetail = segue.destinationViewController as! InternImgDetails
            imageDetail.bookId = self.bookId
            imageDetail.imageId = self.mediaId
            imageDetail.image = self.internImgPicked
        }
        
        else if (segue.identifier == "addInternMedia") {
            
            println("~^~^~^~^~^~^~^~^MEDIAVC: SEGUE = ADDINTERNMEDIA")
            
            var addMediaView = segue.destinationViewController as! AddMediaVC
            addMediaView.image = internImgPicked
            addMediaView.bookId = self.bookId
            addMediaView.edition = false
        }
        
        else if (segue.identifier == "bookDetail") {
            
            var presentBookDetail = segue.destinationViewController as! BookDetailVC
            presentBookDetail.bookId = self.bookId
            presentBookDetail.image = self.internImgPicked
            
        }
        
        
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("**MEDIAVC livroId count igual ---->")
        println(bookId.media.count)

        return bookId.media.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cellMedia: MediaColViewCCell = collectionView.dequeueReusableCellWithReuseIdentifier("mediaCell", forIndexPath:indexPath) as! MediaColViewCCell
        //cellMedia.mediaImage.image = UIImage(named: "tucano87x58.png")
       // cellMedia.mediaDescription.text = "sjjdjds"
        //cellMedia.mediaDescription.text = livroId.media[indexPath.item]
        
        println(indexPath.item)
        
        if(indexPath.item == 0){
            cellMedia.mediaImage.image = UIImage(named: bookId.cover.path)
            cellMedia.mediaDescription.text = bookId.cover.name
            
            println("**MEDIAVC: COLLECTIONVIEW")
            println("**MEDIAVC indexPath entrou no if 0")
            print("**MEDIAVC valor de indexPath =")
            println(indexPath.item)
            
        }
        else {
            cellMedia.mediaDescription.text = bookId.media[indexPath.item - 1].name
            
            print("~^~^~^~^~^MEDIAVC: imagePath = ")
            println(bookId.media[indexPath.item - 1].path)
            
            var teste = UIImage(named: bookId.media[indexPath.item - 1].path)
            print("~^~^~^~^~^MEDIAVC: uiimage da cell: ")
            println(teste?.description)
            
            
            cellMedia.mediaImage.image = UIImage(named: bookId.media[indexPath.item - 1].path)

            println("**MEDIAVC indexPath entrou no else")
            print("**MEDIAVC valor de indexPath =")
            println(indexPath.item)
            
            print("")
        }
        
        return cellMedia
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("indexPath.item: ")
        println(indexPath.item)
     
        if(indexPath.item == 0){
            println("**MEDIAVC escolheu a capa -> performSegue pro bookDetail ")
            mediaId = Media(name: bookId.cover.name, path: bookId.cover.path, type: "cover")
            performSegueWithIdentifier("bookDetail", sender: self)
        }
        else{
            mediaId = bookId.media[indexPath.item - 1]
            performSegueWithIdentifier("imageDetailSegue", sender: self)
        }
        
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       // livroID.text = livrinhoID
       // println("livroID: \(livroID.text)")
        MediaCollectionView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.bookId.title
        
        imgInternPicker.delegate = self
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navBarMedia.png"), forBarMetrics: .Default)
        
self.navigationController?.navigationBar.setBackgroundImage(UIImage(named:"navigationBarBlurTransparent"), forBarMetrics: UIBarMetrics.Default)

    }
    
}
