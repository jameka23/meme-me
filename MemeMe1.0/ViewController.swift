//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Jameka Echols on 5/29/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var cameraButton: UIToolbar!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageViewPicker: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // Mark: ACTIONs for choosing an image or taking one

    @IBAction func pickAnImage(_ sender: Any) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        present(pickImageController, animated: true, completion: nil)
    }
    
    
    
    // Mark: protocols
    
    // save the chosen image to the imageViewPicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageViewPicker.image = pic
    }
    
    
    // now dismiss the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

