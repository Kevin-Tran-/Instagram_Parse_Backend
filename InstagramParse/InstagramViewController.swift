//
//  InstagramViewController.swift
//  InstagramParse
//
//  Created by Kevin Tran on 2/28/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class InstagramViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var window: UIWindow?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.hidden = true
        cancelButton.hidden = true

    }
    
    override func viewDidAppear(animated: Bool) {
        let user = PFUser.currentUser()
        usernameLabel.text = user!.username!
        
        usernameLabel.font = UIFont.boldSystemFontOfSize(18)
        usernameLabel.textColor = UIColor(red: 18/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1)
        print(user!)
        //print(user!["_User"])
        if let userPicture = user!["profile_image"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    let image = UIImage(data:imageData!)
                    self.userImage.image = image!
                    self.userImage.hidden = false
                    
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            let resizeImage = resize(originalImage, newSize: CGSize(width: 1280, height: 800))
            saveButton.hidden = false
            userImage.hidden = false
            cancelButton.hidden = false
            userImage.image = resizeImage
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    @IBAction func onLogout(sender: UIButton) {
        PFUser.logOut()
        let vc = storyboard!.instantiateInitialViewController()! as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        print("User logged out")
    }
    
    @IBAction func onUpload(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func onSave(sender: UIButton) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        UserMedia.uploadProfilePic(userImage.image) { (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Successfully uploaded user image")
            } else {
                print("Failed to upload user image with error: \(error)")
            }
            self.saveButton.hidden = true
            self.cancelButton.hidden = true
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        userImage.hidden = true
        saveButton.hidden = true
        cancelButton.hidden = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
