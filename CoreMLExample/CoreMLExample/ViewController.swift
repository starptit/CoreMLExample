//
//  ViewController.swift
//  CoreMLExample
//
//  Created by Planday Macbook on 6/9/17.
//  Copyright © 2017 Planday Macbook. All rights reserved.
//

import UIKit
import CoreML
import AVKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    private func presentImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker,animated: true,completion: nil)
    }
    
    //MARK: Class variables
    let model = VGG16()
    
    //MARK: IBAction
    @IBAction func actionChoosePhoto(_ sender: Any) {
        presentImagePicker()
    }
    
    //MARK: IBOutlet
    @IBOutlet weak var imgSamplePhoto: UIImageView!
    @IBOutlet weak var lbPredicted: UILabel!
    
}

//MARK: UIImagePickerControllerDelegate
extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        if let gettedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            imgSamplePhoto.image = gettedImage
            
            let reduceSize = CGSize(width: 112, height: 112)
            guard let convertImage = Utils.resizeImage(image: gettedImage, convertSize: reduceSize) else {return}
            
            let imgAsPixelBuffer = Utils.getPixelBuffer(fromImage: convertImage)
            do{
                let predicted = try model.prediction(image: imgAsPixelBuffer)
                self.lbPredicted.text = predicted.classLabel
            }catch{
                
            }
        }
    }
}



