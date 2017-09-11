//
//  ViewController.swift
//  UploadImage
//
//  Created by user11 on 9/11/17.
//  Copyright © 2017 user11. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ActivityIndicator.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func SelectimgClick(_  sender: Any)
    {
        let myimg = UIImagePickerController()
        myimg.delegate = self
        myimg.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myimg, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        img.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func UploadimgClick(_ sender: Any)
    {
        let str = img.image
        self.ActivityIndicator.isHidden = false
        self.ActivityIndicator.startAnimating()
        
        let data = UIImageJPEGRepresentation(str!, 1)
        
        let parameters = ["key" : "Value"]
        
        let urlString = "API"
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData .append(data!, withName: "Image perameter", fileName: "img.png", mimeType: "image/png")
            
            for (key, val) in parameters {
                multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: urlString) { (encodingResult) in
            
            switch encodingResult
            {
            case .success(let upload, _, _):upload.responseJSON { response in
                
                print(response.result.value!)
                
                    if let jsonResponse = response.result.value as? [String: Any]
                    {
                        self.ActivityIndicator.stopAnimating()
                        print(jsonResponse)
                        
                        let alert = UIAlertController(title: "Alert",
                                                      message: "Data Succesfully Saved",
                                                      preferredStyle: UIAlertControllerStyle.alert)
                        
                        let cancelAction = UIAlertAction(title: "OK",
                                                         style: .cancel, handler: nil)
                        
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                        self.ActivityIndicator.isHidden = true
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

