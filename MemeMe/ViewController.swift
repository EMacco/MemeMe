//
//  ViewController.swift
//  MemeMe
//
//  Created by Emmanuel Okwara on 04/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit

enum TextFont: String, CaseIterable {
    case Default = "Impact"
    case Helvetica
    case Courier
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var memeSourceToolbar: UIToolbar!
    @IBOutlet weak var selectImgLbl: UILabel!
    @IBOutlet weak var imageScaleBtn: UIBarButtonItem!
    @IBOutlet weak var backgroundColorBtn: UIBarButtonItem!
    
    let top = "TOP"
    let bottom = "BOTTOM"
    var memedImage: UIImage!
    var adjustView = false
    var backgroundOn = true
    var aspectFit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activateButtons(false)
        configureTextField(textField: topTextField, font: .Default)
        configureTextField(textField: bottomTextField, font: .Default)
        navigationController?.navigationBar.barTintColor = UIColor.orange
    }
    
    @IBAction func changeBackgroundColor(_ sender: UIBarButtonItem) {
        backgroundOn = !backgroundOn
        if backgroundOn {
            view.backgroundColor = .white
            backgroundColorBtn.tintColor = .black
        } else {
            view.backgroundColor = .black
            backgroundColorBtn.tintColor = .white
        }
        
    }
    
    @IBAction func changeImageScale(_ sender: UIBarButtonItem) {
        aspectFit = !aspectFit
        memeImageView.contentMode = aspectFit ? .scaleAspectFit : .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func save() {
        let _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
        
        let alertView = UIAlertController(title: "Meme Saved!", message: "Meme has been saved successfully", preferredStyle: .alert)
        present(alertView, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func generateMemedImage() -> UIImage {
        hideToolbars()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        showToobars()
        
        return memedImage
    }
    
    func hideToolbars() {
        memeSourceToolbar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    func showToobars() {
        memeSourceToolbar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if adjustView {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureTextField(textField: UITextField, font: TextFont) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: font.rawValue, size: 40)!,
            NSAttributedString.Key.strokeWidth: -3
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }

    @IBAction func shareBtnClicked(_ sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { [weak self] type, completed, items, error in
            if completed {
               self?.save()
            }
            activityVC.dismiss(animated: true, completion: nil)
        }
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIBarButtonItem) {
        memeImageView.image = nil
        memedImage = nil
        topTextField.text = top
        bottomTextField.text = bottom
        activateButtons(false)
    }
    
    @IBAction func selectImageSource(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sender.tag == 0 ? .camera : .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func fontTypeBtnClicked(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Select Font", message: "Select your meme font style.", preferredStyle: .actionSheet)
        
        for (index, font) in TextFont.allCases.enumerated() {
            let fontName = font.rawValue + (index == 0 ? " (default)" : "")
            let fontBtn = UIAlertAction(title: fontName, style: .default) { (_) in
                self.configureTextField(textField: self.topTextField, font: font)
                self.configureTextField(textField: self.bottomTextField, font: font)
            }
            actionSheet.addAction(fontBtn)
        }
        
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelBtn)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            memeImageView.image = image
            activateButtons(true)
        } else if let image = info[.originalImage] as? UIImage {
            memeImageView.image = image
            activateButtons(true)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func activateButtons(_ enabled: Bool) {
        cancelBtn.isEnabled = enabled
        shareBtn.isEnabled = enabled
        selectImgLbl.isHidden = enabled
        imageScaleBtn.isEnabled = enabled
        topTextField.alpha = enabled ? 1 : 0
        bottomTextField.alpha = enabled ? 1 : 0
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == top || textField.text == bottom {
            textField.text = ""
        }
        adjustView = textField.tag == 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = textField.tag == 0 ? top : bottom
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
