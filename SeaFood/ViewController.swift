//
//  ViewController.swift
//  SeaFood
//
//  Created by Dylan Anderson on 12/12/17.
//  Copyright © 2017 Dylan Anderson. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //Image gets picked(taken)
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        imageView.image = userPickedImage
            
            //Image gets convrted into a core image below.
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage.")
            }
            
            //Image gets passed into the detect function as a ciimage which is where all the magic happens
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func detect(image: CIImage) {
        
        //The VNCoreModel comes from the vision framework which is a little bit better for analyzing photos.
        //This below is where the model(inception is used to analyze the picture)
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        //Request is made to ask model to classify data and gets passed to the handler
        let request = VNCoreMLRequest(model: model) {
            //Stuff given back from the handler is either a request or error andd do the following below.
            (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Modal Failed to Process image")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "HotDog!"
                }
                else {
                    self.navigationItem.title = "Not Hot Dog!"
                }
            }
        }
        
        //us handler to perform request and passed back to the request or the error
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
        try handler.perform([request])
        } catch {
            print(error)
        }
        
        }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
   
    
    
    
}

