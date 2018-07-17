//
//  ViewController.swift
//  CoreMLImageRec
//
//  Created by Stephen Selvaraj on 7/16/18.
//  Copyright © 2018 Stephen Selvaraj. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    @IBOutlet weak var UserImage: UIImageView!
    
    let imagepicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagepicker.delegate = self
        imagepicker.sourceType = .camera
        imagepicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let  userpickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UserImage.image = userpickedImage
            
            guard let ciImage = CIImage(image : userpickedImage) else {
                fatalError("fatal error with CIImage")
            }
           detectImage(image: ciImage)
            
        }
        
        imagepicker.dismiss(animated: true, completion: nil)
    }
    
    func detectImage(image : CIImage) {
       
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Model Error")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Error getting classification information")
            }
            print(result)
            
            if let firstresult = result.first {
                print(firstresult.identifier.description)
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func CameraClicked(_ sender: UIBarButtonItem) {
     
        present(imagepicker, animated: true, completion: nil)
    
    }
    
}

