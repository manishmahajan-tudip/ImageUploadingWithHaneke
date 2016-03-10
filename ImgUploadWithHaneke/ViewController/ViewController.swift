//
//  ViewController.swift
//  ImgUploadWithHaneke
//
//  Created by TT-MM-06 on 2/29/16.
//  Copyright © 2016 Tudip. All rights reserved.
//

import UIKit
import AVFoundation
import Haneke

var listImagesUrl:[String] = []

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionDelegate{
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var selectImageLabel: UILabel!
    @IBOutlet weak var downloadedImage: UIImageView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var mySpinner: UIActivityIndicatorView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var baseImageArray : Array<AnyObject> = []
    var baseImage : String!
    var downloadImageUrl : String!
    var flag:Bool = false
    var countView = Int.self
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.defaultButtonColor()
        self.mySpinner.hidden = true
        self.view.backgroundColor = SwiftUtil.getBackgroundColor()
        self.makeRoundButton(galleryButton)
        self.makeRoundButton(cameraButton)
        self.makeRoundButton(uploadButton)
        self.makeRoundButton(downloadButton)
        self.makeRoundButton(listButton)
        self.makeAnimationButton(galleryButton)
        self.makeAnimationButton(cameraButton)
        self.makeAnimationButton(listButton)
        self.makeAnimationButton(downloadButton)
        self.makeAnimationButton(uploadButton)
        if self.selectedImage.image == nil{
            self.selectImageLabel.text = "Select Image"
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: Selector("selectImage:"))
        selectedImage.userInteractionEnabled = true
        selectedImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.selectedImage.image == nil{
        self.selectImageLabel.text = "Select Image"
        }
        self.downloadButton.enabled = true

//        self.makeRoundButton(galleryButton)
//        self.makeRoundButton(cameraButton)
//        self.makeRoundButton(uploadButton)
//        self.makeRoundButton(downloadButton)
//        self.makeRoundButton(listButton)
//        self.makeAnimationButtonFast(galleryButton)
//        self.makeAnimationButtonFast(cameraButton)
//        self.makeAnimationButtonFast(listButton)
//        self.makeAnimationButtonFast(downloadButton)
//        self.makeAnimationButtonFast(uploadButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.makeAnimationButtonFast(galleryButton)
        self.makeAnimationButtonFast(cameraButton)
        self.makeAnimationButtonFast(listButton)
        self.makeAnimationButtonFast(downloadButton)
        self.makeAnimationButtonFast(uploadButton)
    }
    
    func selectImage(gestureRecognizer: UITapGestureRecognizer){
        self.selectImageLabel.text = " "
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func fromGallery(sender: AnyObject) {
        self.mySpinner.stopAnimating()
        self.defaultButtonColor()
        self.galleryButton.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.galleryButton.fadeIn()
        })
        self.selectImageLabel.text = " "
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion:nil)
    }

    @IBAction func fromCamera(sender: AnyObject) {
        self.defaultButtonColor()
        self.cameraButton.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.cameraButton.fadeIn()
        })
        self.mySpinner.stopAnimating()
        self.selectImageLabel.text = " "
        self.openCamera(sender as! UIButton)
    }
    
    @IBAction func uploadRequest(sender: AnyObject) {
        self.mySpinner.hidden = false
        self.mySpinner.transform = CGAffineTransformMakeScale(1.4, 1.4)
        self.mySpinner.hidesWhenStopped = true
        self.defaultButtonColor()
        self.uploadButton.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.uploadButton.fadeIn()
        })
        if self.selectedImage.image == nil{
        let alertController = UIAlertController(title: "Error", message:
            "Please Select Image First", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
        self.flag = true
//        To make image low quality
//            let resizedImage:UIImage = (self.selectedImage.image?.resize(0.1))!
//            let imageData: NSData = UIImagePNGRepresentation(resizedImage)!
            let image : UIImage = selectedImage.image!.normalizedImage()
            let imageData = image.lowestQualityJPEGNSData
//            self.mySpinner.bounds = self.view.frame
//            self.mySpinner.bounds = self.view.bounds
//            self.mySpinner.alpha = 0.5
            self.view.userInteractionEnabled = false
//            self.mySpinner.layer.backgroundColor = UIColor.grayColor().CGColor
            self.uploadImage(imageData, completion: {(result) in
            self.view.userInteractionEnabled = true
            print("Result \(result)")
            print(result["url"])
            self.selectedImage.image = nil
            let alertController = UIAlertController(title: "Success", message:
                "Your image uploaded Successfully", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
//            self.downloadedImage.image = nil
            if result["url"] !== nil{
            self.downloadImageUrl = result["url"] as! String
            print("doenlaod imageurl \(self.downloadImageUrl)")
            listImagesUrl.append(self.downloadImageUrl)
            print("ListImageUrl\(listImagesUrl)")
                 self.selectImageLabel.text = "Select Image"
            }else{
                let alertController = UIAlertController(title: "Error", message:
                    "Network Error", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                 self.selectImageLabel.text = "Select Image"
            }
          })
        }
     }
    
    @IBAction func listRequest(sender: AnyObject){
        self.defaultButtonColor()
        self.listButton.fadeOut(completion: {
            (finished: Bool) -> Void in
                   self.listButton.fadeIn()
        })
        if listImagesUrl.count == 0{
            let alertController = UIAlertController(title: "Error", message:
                "Frist Upload Image First", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)

        }else{
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("List") as! ListViewController
             self.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func downloadRequest(sender: AnyObject){
            self.defaultButtonColor()
            self.downloadButton.fadeOut(completion: {
                (finished: Bool) -> Void in
                self.downloadButton.fadeIn()
            })
            self.mySpinner.startAnimating()
            if self.flag == true{
                self.mySpinner.startAnimating()
                let url = NSURL(string: self.downloadImageUrl)
                self.downloadedImage.hnk_setImageFromURL(url!)
                self.downloadButton.enabled = false
                self.mySpinner.stopAnimating()
            }else{
                let alertController = UIAlertController(title: "Error", message:
                    "Please Upload Image First", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                self.mySpinner.stopAnimating()
            }
    }

    func makeRoundButton(thisButton:UIButton){
        thisButton.clipsToBounds = true
        thisButton.layer.cornerRadius = 34
        thisButton.layer.masksToBounds = true
        thisButton.backgroundColor = SwiftUtil.getButtonBG()
        thisButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    func makeAnimationButton(thisButton:UIButton){
        thisButton.frame = CGRectMake(200, self.view.frame.height - 100, 60, 60)
        UIView.animateWithDuration(3.0) { () -> Void in
            thisButton.frame = CGRectMake(200, 50, 70, 70)
           let grow = CGAffineTransformMakeScale(1.2, 1.2)
            
            let angle = CGFloat(270)
            let rotate = CGAffineTransformMakeRotation(angle)
            thisButton.transform = CGAffineTransformConcat(grow, rotate)
        }
    }
    
    func makeAnimationButtonFast(thisButton:UIButton){
        thisButton.frame = CGRectMake(200, self.view.frame.height - 100, 60, 60)
        UIView.animateWithDuration(1.0) { () -> Void in
            thisButton.frame = CGRectMake(200, 50, 70, 70)
            let grow = CGAffineTransformMakeScale(1.2, 1.2)
            
            let angle = CGFloat(270)
            let rotate = CGAffineTransformMakeRotation(angle)
            thisButton.transform = CGAffineTransformConcat(grow, rotate)
        }
    }
    
    func defaultButtonColor(){
        self.galleryButton.backgroundColor = SwiftUtil.getButtonBG()
        self.cameraButton.backgroundColor = SwiftUtil.getButtonBG()
        self.listButton.backgroundColor = SwiftUtil.getButtonBG()
        self.downloadButton.backgroundColor = SwiftUtil.getButtonBG()
        self.uploadButton.backgroundColor = SwiftUtil.getButtonBG()
    }
    
    func openCamera(sender : UIButton){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        
        if(self.checkCamera()){
            myPickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(myPickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        selectedImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func checkCamera() -> Bool{
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch authStatus {
        case .Authorized:
            return true
        case .Denied:
            alertToEncourageCameraAccessInitially()
            return false
        case .NotDetermined:
            alertPromptToAllowCameraAccessViaSetting()
            return false
        default:
            alertToEncourageCameraAccessInitially()
            return false
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .Cancel, handler: { (alert) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting(){
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Please allow camera access",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel) { alert in
            if AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo).count > 0 {
                AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { granted in
                    dispatch_async(dispatch_get_main_queue()) {
                        self.checkCamera() } }
             }
            })
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    
    func uploadImage(photo: NSData, completion: (result: NSDictionary) -> Void){
        self.mySpinner.hidden = false
        self.mySpinner.startAnimating()
        let base64String = photo.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        var jsonDictionary: NSDictionary = [:]
        
        if photo.length > 0{
            let request = NSMutableURLRequest(URL: NSURL(string:  "http://dev.postmeistr.com/content/upload")!)
            var params: NSDictionary?
            params = ["file": base64String]
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            do{
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions(rawValue: 0))
            }catch{
                print("Error \(error)")
                self.mySpinner.stopAnimating()
                self.mySpinner.hidden = true
            }
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    print("Status code \(httpResponse.statusCode)")
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300){
                        let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        if let dictionary: NSDictionary = json {
                            jsonDictionary = dictionary
                            self.mySpinner.stopAnimating()
                            completion(result: jsonDictionary)
                        }
                    }
                }else{
                    let alertController = UIAlertController(title: "", message:
                        "Network Error", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    print("Unwrapping NSHTTPResponse failed")
                    print(error)
                    
                    if (error != nil) {
                        completion(result: jsonDictionary)
                        self.mySpinner.stopAnimating()
                    }
                }
            })
            task.resume()
        }else{
            completion(result: jsonDictionary)
            self.mySpinner.stopAnimating()
        }
      }
   }

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

extension UIImage{
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)!}
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)!}
    var lowestQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.0)! }
}

extension UIImage{
    func normalizedImage() -> UIImage {
        if self.imageOrientation == UIImageOrientation.Up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.drawInRect(CGRect(origin: CGPoint(x: 0, y: 0), size: self.size))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}

extension UIImage{
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

