//
//  ListViewController.swift
//  ImgUploadWithHaneke
//
//  Created by TT-MM-06 on 3/2/16.
//  Copyright © 2016 Tudip. All rights reserved.
//

import Foundation
import UIKit
import Haneke

class ListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate {
    
    @IBOutlet weak var listTableView: UITableView!
    var countThis:Int = 0
    var feedModelArray = [MyModel]()
    var myTableViewCell = MyTableViewCell()
    var viewControllerObj = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(listImagesUrl.count)
        self.automaticallyAdjustsScrollViewInsets = false
//        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Bordered, target: self, action: "back:")
//        self.navigationItem.leftBarButtonItem = newBackButton;
        self.navigationController?.navigationItem.hidesBackButton
        listTableView.registerNib(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "myCell")
        print("feedmodelArray\(feedModelArray)")
        setUpModel()
        print("feedModelArray in viewdidLoad\(feedModelArray)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
              self.navigationItem.hidesBackButton = false
    }
    
    func setUpModel()
    {
        for i in listImagesUrl {
            let object = MyModel()
                getDataFromUrl( NSURL(string:i)!) { (data, response, error)  in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        guard let data = data where error == nil else { return }
                        print(response?.suggestedFilename ?? "")
                        print("Download Finished")
//                        print("data \(data)")
//                        imageView.image = UIImage(data: data)
                        object.profileImage = UIImage(data: data)
                        self.feedModelArray.append(object)
                        self.listTableView.delegate = self
                        self.listTableView.dataSource = self
                        self.listTableView.reloadData()
                    }
                }
            }
    }

    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell") as! MyTableViewCell
        cell.likeButtondelegate = self
        cell.listedImageDelegate = self
        if feedModelArray.count > indexPath.row{
            cell.setupWithModel(feedModelArray[indexPath.row])
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listImagesUrl.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 234
    }
    
    func likeUnlikeApiCall(row: Int) {
        
        let header = ["auth_token": "8a3c43c6b3fd322f2d7731150c3c2e69"]
        
//        Alamofire.request(.POST, BASE_PATH + "status/like",headers: header, parameters: parameters)
//            .responseJSON { response in
//                switch response.result {
//
//                case .Success:
//                    print("Like Unlike api call success")
//                    if let value = response.result.value {
//                        let json = JSON(value)
//                        print("Like Unlike API Response: \(json)")
//                        if json["code"] == 0 {
//                            //Actions need to be perform after successfull response
////                            LoadingOverlay.shared.hideOverlayView()
//                            print(json["data"].count)
//                        } else {
//                            LoadingOverlay.shared.hideOverlayView()
//                            print("Like Unlike API Response: \(json)")
//                            
//                            let alertController = UIAlertController(title: "Error", message:
//                                "Oops something went wrong. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
//                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
//                            self.presentViewController(alertController, animated: true, completion: nil)
//                        }
//                    }
//                case .Failure(let error):
////                    LoadingOverlay.shared.hideOverlayView()
//                    print(error)
////                    AppUtils.showErrorMessage( "Oops something went wrong. Try again.", messageTitle: errorAlertTitle,   completion: { return})
//                    let alertController = UIAlertController(title: "Error", message:
//                        "Oops something went wrong. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
//                    self.presentViewController(alertController, animated: true, completion: nil)
//                }
//        }
        var jsonDictionary: NSDictionary = [:]
            let request = NSMutableURLRequest(URL: NSURL(string:"https://ilove:tudip@dev.tudip.com/training-amigo-dev/public/api/status/like")!)
            var params: NSDictionary?
        params = [
                 "status_id": feedModelArray[row].status_id,
                 "post_type_id": feedModelArray[row].post_type_id
                ]
            let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            do{
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions(rawValue: 0))
            }catch{
                print("\(error)")
            }
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                print("data\(data)")
                print("response\(response)")
                print("error \(error)")
                if let httpResponse = response as? NSHTTPURLResponse {
                    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300){
                        let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        if let dictionary: NSDictionary = json {
                            jsonDictionary = dictionary
                            print("json")
                            print(jsonDictionary)
//                            completion(result: jsonDictionary)
                        }
                    }
                } else {
                    print("Unwrapping NSHTTPResponse failed")
                    if (error != nil) {
                        jsonDictionary.setValue(error, forKey: "error")
//                        completion(result: jsonDictionary)
                    }
                }
            })
            task.resume()
     }
}

extension ListViewController: ListViewControllerDelegate{
    
    func likeButtonTapped(cell: MyTableViewCell ) {
        
                let index: Int = (listTableView.indexPathForCell(cell)?.row)!
//                let postDetail = feedModelArray[index]
                let data = self.feedModelArray[index]
//                let likes_Count = data.likesCount
//                var totalLikeCount = Int(likes_Count)
//                let sender = cell.likeButton
        
                if data.is_liked_by_me == false {
                    data.is_liked_by_me = true
//                    totalLikeCount = Int(likes_Count)!  + 1
////                    sender.tintColor = UIColor.redColor()
                    print("self.feedModelArray[index]\(self.feedModelArray[index].is_liked_by_me)")
                    listTableView.reloadData()
                    print("self.feedModelArray[index]\(self.feedModelArray[index].is_liked_by_me)")
//                    totalLikeCount = Int(likes_Count)! - 1
//                    feedModelArray[index].likesCount = String(totalLikeCount)
                    print("Like button tapped \(index)")
                    self.likeUnlikeApiCall(index)
                }else{
//                    totalLikeCount = Int(likes_Count)! - 1
//                    var unlikeImage:UIImage = UIImage(named: "likeImage3")!
//                    sender.imageView!.image = unlikeImage
//                    feedModelArray[index].likesCount = String(totalLikeCount)
                      data.is_liked_by_me = false
                      listTableView.reloadData()
                      print("Unlike button tapped \(index)")
                      self.likeUnlikeApiCall(index)
                }
          }
    
    func didSelectedImage(image: UIImage){
            let photoViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PhotoView") as! PhotoViewController
            photoViewController.image = image
            self.navigationController!.pushViewController(photoViewController, animated: true)
            print("image selected")
    }
}