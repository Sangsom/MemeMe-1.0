//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Rinalds Domanovs on 30/05/2019.
//  Copyright © 2019 Rinalds Domanovs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UITextFieldDelegate {

    // MARK: Outlets

    @IBOutlet var memeImage: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!

    // MARK: App lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memeImage.contentMode = .scaleAspectFit

        initTextFields()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func initTextFields() {
        topTextField.delegate = self
        bottomTextField.delegate = self

        topTextField.text = Constants.TextField.topText
        bottomTextField.text = Constants.TextField.bottomText

        topTextField.autocapitalizationType = .allCharacters
        bottomTextField.autocapitalizationType = .allCharacters

        let textAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: Constants.TextField.strokeColor,
            .foregroundColor: Constants.TextField.foreGroundColor,
            .font: UIFont(name: Constants.TextField.font, size: CGFloat(Constants.TextField.size))!,
            .strokeWidth: Constants.TextField.strokeWidth
        ]

        topTextField.defaultTextAttributes = textAttributes
        bottomTextField.defaultTextAttributes  = textAttributes

        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }

    // MARK: Custom methods

    @IBAction func pickAlbumImage(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickCameraImage(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            memeImage.image = image
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

}
