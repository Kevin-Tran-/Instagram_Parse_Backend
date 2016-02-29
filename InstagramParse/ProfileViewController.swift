//
//  ProfileViewController.swift
//  InstagramParse
//
//  Created by Kevin Tran on 2/28/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var instagram: [PFObject]?
    var user: PFUser?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 260

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let instagram = instagram {
            return instagram.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //print(instagram)
        let cell = tableView.dequeueReusableCellWithIdentifier("InstagramCell", forIndexPath: indexPath) as! InstagramCell
        cell.instagram = self.instagram![indexPath.section]
        //print(indexPath.row)
        
        return cell
    }
    
    // Need a better way of implementing Headers with autolayout. Right now it is slow on screen rotation. Username and create time will most likely overlap
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let superViewWidth = Int(self.view.frame.width)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 10, width: superViewWidth, height: 60))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        let user = PFUser.currentUser()
        if let userPicture = user!["profile_image"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    let image = UIImage(data:imageData!)
                    profileView.image = image!
                    profileView.hidden = false
                }
            })
        } else {
            profileView.hidden = true
        }
        
        headerView.addSubview(profileView)
        print(section)
        // Add a UILabel for the username here
        let nameView = UILabel(frame: CGRect(x: 50, y: 5, width: superViewWidth - 200, height: 30))
        
        nameView.font = UIFont.boldSystemFontOfSize(16)
        nameView.textColor = UIColor(red: 18/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1) //http://designpieces.com/palette/instagram-colour-palette-hex-and-rgb/
        
        if let name = instagram![section].valueForKeyPath("username_str") as? String {
            nameView.text = name
        }
        nameView.sizeToFit()
        headerView.addSubview(nameView)
        
        let createdView = UILabel(frame: CGRect(x: superViewWidth - 200 - 8, y: 0, width: 200, height: 30))
        
        createdView.font = UIFont.boldSystemFontOfSize(16)
        createdView.textColor = UIColor(red: 18/255.0, green: 86/255.0, blue: 136/255.0, alpha: 1) //http://designpieces.com/palette/instagram-colour-palette-hex-and-rgb/
        createdView.textAlignment = NSTextAlignment.Right
        
        //createdView.text = "4h"
        print(instagram![section].valueForKeyPath("created_at")!)
        if let createdAt = instagram![section].valueForKeyPath("created_at")! as? NSDate {
            
            let time = secondsToTime(createdAt)
            createdView.text = time
        }
        headerView.addSubview(createdView)
        
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func secondsToTime(createdAt: NSDate?) -> String {
        let today = NSDate()
        let secs = 60
        let mins = 60
        let hours = 24
        
        var sec = Int(today.timeIntervalSinceDate(createdAt!))
        if sec > 518400 { //greater than 6 days
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            return formatter.stringFromDate(createdAt!)
        }
        
        if sec > 86400 { // greater than 24 hours
            sec /= (mins*secs*hours)
            let s = "\(sec)d"
            return s
        }
        
        if sec > 3600 { // greater than 1h
            sec /= (secs*mins)
            let s = "\(sec)h"
            return s
        }
        
        sec = sec / secs
        let s = "\(sec)m"
        return s
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
