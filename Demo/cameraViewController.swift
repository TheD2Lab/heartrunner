//
//  cameraViewController.swift
//  Demo
//
//  Created by Dennis Lo on 11/22/22.
//  Copyright © 2022 NPE INC. All rights reserved.
//

import UIKit
//import Foundation


class cameraViewController: UIViewController  {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delay(0.7){self.startcamera()}
        
        
    }
    
    @IBAction func takepicture(_ sender: Any) {
    }
    
    
    func startcamera(){
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
}

extension cameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as?
                UIImage else {return}
        
        imageView.image = image
        
        
        let resizedImage = image.resized(to: CGSize(width: 60, height: 60))
        if let data = resizedImage.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent("avatar.png")
            try? data.write(to: filename)
        }
    }
}

func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
