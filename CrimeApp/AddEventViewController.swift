//
//  AddEventViewController.swift
//  CrimeApp
//
//  Created by lucas on 11/8/20.
//  Copyright © 2020 lucas. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var newImage: UIImageView!
    @IBOutlet var newTitleText: UITextField!
    @IBOutlet var newContentText: UITextField!
    
    private var image: UIImage? {
        didSet {
            self.newImage.image = self.image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Add"
        self.navigationItem.rightBarButtonItem = .init(title: "Submit", style: .plain, target: self, action: #selector(submitEvent(_:)))
        
        self.newImage.contentMode = .scaleToFill
    }
    
    @IBAction func useCamera(_ sender: UIButton) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.showAlert(title: "No Camera available!", message: "Please make sure your device has camera!")
        }
        else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.camera
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let capturedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true, completion: nil)

            self.image = capturedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitEvent(_ sender: UIButton) {
        guard let title = newTitleText.text, let content = newContentText.text,
              !title.isEmpty, !content.isEmpty else {
            self.showAlert(title: "Add Failed!",
                           message: "You can't submit with empty title or desciption.")
            return
        }
        
        let imgData: Data? = self.image?.jpegData(compressionQuality: 0.5)
        _ = EntityManager.shared.addCrime(title: title, content: content, image: imgData)
        self.navigationController?.popViewController(animated: true)
    }
}
