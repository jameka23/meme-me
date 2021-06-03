//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Jameka Echols on 5/29/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var uploadButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageViewPicker: UIImageView!
    var meme: Meme!
    
    struct Meme {
        var topText: String?
        var bottomText: String?
        var originalImage: UIImage?
        var memeImage: UIImage?
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if !cameraButton.isEnabled {
            cameraButton.isEnabled = false
        }
        
        //disable the upload button
        uploadButton.isEnabled = false;
        
        //        topTextfield.defaultTextAttributes =
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -5.0
        ]
        
        self.view.backgroundColor = UIColor.black
        
        topTextfield.defaultTextAttributes = memeTextAttributes
        topTextfield.textAlignment = .center
        topTextfield.backgroundColor = UIColor.black
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.textAlignment = .center
        bottomTextfield.backgroundColor = UIColor.black
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomTextfield.delegate = self
        topTextfield.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //MARK: handle the MemedImage
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        toolBar.isHidden = true
        navBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // TODO: Show toolbar and navbar
        toolBar.isHidden = false
        navBar.isHidden = false
        
        return memedImage
    }

    // MARK: ACTIONs for choosing an image or camera & saving
    @IBAction func pickAnImage(_ sender: Any) {
        uploadButton.isEnabled = true
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = .photoLibrary
        present(pickImageController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        uploadButton.isEnabled = true
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        present(cameraController, animated: true, completion: nil)
        
    }
    
    @IBAction func save(_ sender: Any) {
        let image = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems:[image],applicationActivities: nil)

        present(activityController, animated: true, completion: nil)
        
        //completion handler
        activityController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed:
                                                            Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                //save the meme
                self.meme = Meme(topText: self.topTextfield.text, bottomText: self.bottomTextfield.text, originalImage: self.imageViewPicker.image, memeImage: image)
                self.dismiss(animated: true, completion: nil)
            }else{
                print("cancelled")
            }
            
            if let shareError = error {
                print("error while sharing: \(shareError.localizedDescription)")
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        topTextfield.text = .none
        topTextfield.text = "TOP"
        
        bottomTextfield.text = .none
        bottomTextfield.text = "BOTTOM"
        
        imageViewPicker.image = .none
    }
    
    
    
    
    // MARK: Protocols for image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // save the chosen image to the imageViewPicker
        let pic = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageViewPicker.image = pic
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // now dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK : Protocols for textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        textField.clearsOnBeginEditing = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: keyboard notifications and methods
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextfield.isFirstResponder{
            view.frame.origin.y = -300
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        if bottomTextfield.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    
    func subscribeToKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
         
         NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
     }

}

