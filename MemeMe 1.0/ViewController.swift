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
    // TODO: By pressing return - keyboard should be dismissed - textFieldShouldReturn
    // TODO: Move up view only when pressing on bottom text view

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
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
