//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Rinalds Domanovs on 30/05/2019.
//  Copyright © 2019 Rinalds Domanovs. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UITextFieldDelegate {

    // MARK: Outlets

    @IBOutlet var memeImage: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var navigation: UINavigationItem!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var toolbar: UIToolbar!

    var memedImage: UIImage?
    // MARK: App lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initAppSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: Configuration methods
    func initAppSettings() {
        memeImage.image = nil
        memeImage.contentMode = .scaleAspectFit
        // Add Cancel button
        navigation.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                                        action: #selector(cancelTapped))
        navigation.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                                       action: #selector(shareItem))
        navigation.leftBarButtonItem?.isEnabled = false
        navigation.title = Constants.TextField.appName
        initTextFields()
    }

    func initTextFields() {
        configureTextField(topTextField, with: Constants.TextField.topText)
        configureTextField(bottomTextField, with: Constants.TextField.bottomText)
    }

    func configureTextField(_ textField: UITextField, with defaultText: String) {
        textField.delegate = self
        textField.text = defaultText
        textField.borderStyle = .none
        textField.autocapitalizationType = .allCharacters
        textField.defaultTextAttributes = [
            .font: UIFont(name: Constants.TextField.font, size: CGFloat(Constants.TextField.size))!,
            .foregroundColor: Constants.TextField.foreGroundColor,
            .strokeColor: Constants.TextField.strokeColor,
            .strokeWidth: Constants.TextField.strokeWidth
        ]
        textField.textAlignment = .center
    }

    // MARK: Image methods

    @IBAction func pickAlbumImage(_ sender: UIBarButtonItem) {
        pickAnImage(from: .photoLibrary)
    }

    @IBAction func pickCameraImage(_ sender: UIBarButtonItem) {
        pickAnImage(from: .camera)
    }

    func pickAnImage(from source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            memeImage.image = image
            navigation.leftBarButtonItem?.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }

    // MARK: Text field methods

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        if textField.tag == 1 {
            subscribeToKeyboardNotifications()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        unsubscribeFromKeyboardNotification()
        return true
    }

    // MARK: Keyboard methods

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    // MARK: Misc methods

    @objc func cancelTapped() {
        initAppSettings()
    }

    @objc func shareItem() {
        memedImage = generateImage()
        let ac = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        ac.completionWithItemsHandler = {
            (activityType, completed, returnedItems, activityError) in
            if completed {
                self.saveMeme()
            }
        }
        present(ac, animated: true)
    }

    func saveMeme() {
        if memeImage != nil {
            let meme = Meme(topString: topTextField.text!,
                            bottomString: bottomTextField.text!,
                            originalImage: memeImage.image!,
                            updatedImage: memedImage!)
        }
    }

    func generateImage() -> UIImage {
        navigationBar.isHidden = true
        toolbar.isHidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        navigationBar.isHidden = false
        toolbar.isHidden = false

        return memedImage
    }

}
