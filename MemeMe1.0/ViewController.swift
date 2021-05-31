//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Jameka Echols on 5/29/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var cameraButton: UIToolbar!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageViewPicker: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //disable the upload button
        uploadButton.isEnabled = false;
        
        //set the text attributes for top and bottom
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  1.2
        ]
        
        topTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        topTextfield.textAlignment = .center
        bottomTextfield.textAlignment = .center
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // enable the upload button once the top and bottom text have values and the imageviewpicker has an image
        if bottomTextfield.text != nil && topTextfield.text != nil && imageViewPicker.image != nil {
            uploadButton.isEnabled = true
        }
    }

    // MARK: ACTIONs for choosing an image or taking one
    @IBAction func pickAnImage(_ sender: Any) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = .photoLibrary
        present(pickImageController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        present(cameraController, animated: true, completion: nil)
    }
    
    
    // MARK: Protocols for image picker
    // save the chosen image to the imageViewPicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageViewPicker.image = pic
    }
    
    // now dismiss the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK : Protocols for textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.clearsOnBeginEditing = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

