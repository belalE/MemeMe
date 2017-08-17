//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by mac pro on 7/28/17.
//  Copyright © 2017 Elsiesy Industries. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    //Outlets
    
    @IBOutlet weak var ShareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var TopTextField: UITextField!
    @IBOutlet weak var BottomTextField: UITextField!
    
   
    //properties
    
    
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName: -3.0]

    
    struct Meme {
        
        var toptext = ""
        var bottomtext = ""
        
        var originalImage : UIImage
        
        var memedImage : UIImage
        
    }
    
    // Basic Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareTextField(textField: BottomTextField, defaultText: "BOTTOM")
        prepareTextField(textField: TopTextField, defaultText: "TOP")
        ShareButton.isEnabled = false
        
    }
    
     func prepareTextField(textField: UITextField, defaultText: String) {
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: defaultText,
                                                               attributes: [
                                                                NSStrokeColorAttributeName: UIColor.black,
                                                                NSForegroundColorAttributeName: UIColor.white,
                                                                NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size: 30)!,
                                                                NSStrokeWidthAttributeName: -3.0])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardHideNotifications()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        unsubscribeFromKeyboardHideNotifications()
       
    }

    //TextField Actions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
        
    }
    //ImagePicker (IBActions/Functions)
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pick(sourceType: .photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pick(sourceType: .camera)
    }
     func pick(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismiss(animated: true, completion: nil)
            ShareButton.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
        
    }
    
    //Keyboard
    
    
    func keyboardWillShow(_ notification:Notification) {
        if BottomTextField.isFirstResponder {
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if BottomTextField.isFirstResponder {
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
        
    }
    
    func subscribeToKeyboardHideNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
    }
    func unsubscribeFromKeyboardHideNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
    }
    
        // Saving and Exporting
    
    func HideToolbarandNavbar(bool:Bool) {
        navigationController?.setToolbarHidden(bool, animated: true)
        navigationController?.setNavigationBarHidden(bool, animated: true)
    }
    
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        HideToolbarandNavbar(bool: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        HideToolbarandNavbar(bool: false)
        
        
        return memedImage
    }
    @IBAction func ShareAction(_ sender: Any) {
        let memedimage = generateMemedImage()
        let activityVC = UIActivityViewController(
            activityItems: [memedimage as Any],
            applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = {
            (activityType, complete, returnedItems, activityError ) in
            
            if complete {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func save() {
        let memedimage = generateMemedImage()
        let meme = Meme(toptext: TopTextField.text!, bottomtext: BottomTextField.text!, originalImage: imageView.image!, memedImage: memedimage)
    }
    
    
    
}


