//
//  UserMedia.swift
//  InstagramParse
//
//  Created by Kevin Tran on 2/28/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import Parse
import UIKit

class UserMedia: NSObject {
    /**
     * Other methods
     */
     
     /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "UserMedia")
        
        // Add relevant fields to the object
        media["media"] = getPFFileFromImage(image) // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["caption"] = caption
        media["likesCount"] = 0
        media["commentsCount"] = 0
        media["created_at"] = NSDate()
        media["username_str"] = PFUser.currentUser()?.username

        // Save object (following function will save the object in Parse asynchronously)
        media.saveInBackgroundWithBlock(completion)
    }
    
    /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    class func queryParse(limit: Int?, completion: (instagram: [PFObject]!, error: NSError?) -> ()) {
        // construct query
        //let predicate = NSPredicate(format: "likesCount > 100")
        var query = PFQuery(className: "UserMedia") //, predicate: predicate)
        query.limit = limit!
        query.orderByDescending("createdAt")
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                // do something with the array of object returned by the call
                completion(instagram: media, error: error)
                //print(media)
            } else {
                print(error?.localizedDescription)
            }
        }
//        query.getObjectInBackgroundWithId("\(id)") {
//            (userMedia: PFObject?, error: NSError?) -> Void in
//            if error == nil && userMedia != nil {
//                print(userMedia)
//                //                return UserMedia
//            } else {
//                print("Failed with error : \(error)")
//            }
//        }
    }
    
    class func uploadProfilePic(image: UIImage?, withCompletion completion: PFBooleanResultBlock) {
        
        let user = PFUser.currentUser()!
        user["profile_image"] = getPFFileFromImage(image)
        
        user.saveInBackgroundWithBlock(completion)
    }

    

}
