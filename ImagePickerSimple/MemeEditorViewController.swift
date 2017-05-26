//
//  MemeEditorViewController.swift
//  ImagePickerSimple
//
//  Created by J B on 5/19/17.
//  Copyright © 2017 J B. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {

    
    // MARK: IBOutlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: Text Attributes
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3,
        NSBackgroundColorAttributeName: UIColor.clear
        ] as [String : Any]
    
    // MARK: Text Field Delegate objects
    
    var memedImage = UIImage()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Save
    
    func save(memedImage: UIImage?) {
        
        guard let memedImage = memedImage,
            let _ = imagePickerView.image else {
                
                print("No image selected or image could not be saved")
                // Show Alert to user about missing elements
                imageNotSaved()
                
                return
        }
        
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, imagePickerView: imagePickerView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // MARK: Generate Meme Image
    
    func configureBar(hidden: Bool) {
        // Show or Hide toolbar and navbar
        self.navigationBar.isHidden = hidden
        self.toolBar.isHidden = hidden
    }
    
    func generateMemedImage() -> UIImage {
        // Hide Bar
        configureBar(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame,afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show Bar
        configureBar(hidden: false)
      
        return memedImage
    }
    
    // MARK: UIAlert
    
    func imageNotSaved() {
        let alert = UIAlertController(title: "Select an Image", message: "Meme could not be saved because you did not select an image.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    
    @IBAction func pickAnImage(_ sender: Any) {
        presentPicker(withSource: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentPicker(withSource: .camera)
    }
    
    @IBAction func saveAndShare(_ sender: UIBarButtonItem) {
        let memedImage: UIImage = self.generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {
            (activityType, complete, returnedItems, activityError ) in
           
            if complete {
                self.save(memedImage: memedImage)
                self.readyToShareAndSave()
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: Dismiss Meme
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Keyboard Notifications
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomText.isFirstResponder && view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

}


// MARK: - UIImagePickerControllerDelegate

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    
    func presentPicker(withSource source: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            
            // Enable the share button
            readyToShareAndSave()
            
        } else {
            print("Something went wrong")
        }
        
        imagePickerView.contentMode = .scaleAspectFit
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension MemeEditorViewController: UITextFieldDelegate {
    
    // MARK: UI Setup
    
    func setInitialView() {
        
        imagePickerView.image = nil
        setupTextFieldWithDefaultSettings(topText, withText: "TOP")
        setupTextFieldWithDefaultSettings(bottomText, withText: "BOTTOM")
        shareButton.isEnabled = true
    }
    
    func readyToShareAndSave() {
        shareButton.isEnabled = true
    }
    
    func setupTextFieldWithDefaultSettings(_ textField: UITextField, withText text: String) {
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
        textField.borderStyle = .none
    }
    
    // MARK: Text fields
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
