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
    @IBOutlet var btnSelect: UIButton!

    @IBOutlet var blurView: UIView!
    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var img: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ActivityIndicator.isHidden = true
        self.blurView.isHidden = true
        
        self.blurView.layer.cornerRadius = 10;
        self.blurView.layer.masksToBounds = true;

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
        self.btnSelect.isUserInteractionEnabled = false
        self.btnUpload.isUserInteractionEnabled = false
        let str = img.image
        self.ActivityIndicator.isHidden = false
        self.ActivityIndicator.startAnimating()
        self.blurView.isHidden = false
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.blurView.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.blurView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.blurView.addSubview(blurEffectView)
        }
        else
        {
            self.blurView.backgroundColor = UIColor.black
        }
        
        let data = UIImageJPEGRepresentation(str!, 1)
        
        let parameters = ["type" : "image" , "sender" : "" ,"reciver" : ""]
        
        let urlString = "API"
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData .append(data!, withName: "uploadedfile", fileName: "img.png", mimeType: "image/png")
            
            for (key, val) in parameters
            {
                multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, to: urlString) { (encodingResult) in
            
            switch encodingResult
            {
            case .success(let upload, _, _):upload.responseJSON { response in
                
                print(response.result.value!)
                
                    if let jsonResponse = response.result.value as? [String: Any],let status = jsonResponse["status"] as? Int, status == 1
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
                        
                        self.btnUpload.isUserInteractionEnabled = true
                        self.btnSelect.isUserInteractionEnabled = true
                        self.ActivityIndicator.isHidden = true
                        self.blurView.isHidden = true
                    }
                else
                    {
                        let alert = UIAlertController(title: "Alert",
                                                      message: "Profile is not updated",
                                                      preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction = UIAlertAction(title: "OK",
                                                         style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)

                        self.btnUpload.isUserInteractionEnabled = true
                        self.btnSelect.isUserInteractionEnabled = true
                        self.ActivityIndicator.isHidden = true
                        self.blurView.isHidden = true
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

