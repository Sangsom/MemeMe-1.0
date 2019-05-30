//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Rinalds Domanovs on 30/05/2019.
//  Copyright © 2019 Rinalds Domanovs. All rights reserved.
//

import UIKit

struct Constants {

    struct TextField {
        static let topText = "TOP"
        static let bottomText = "BOTTOM"
        static let font = "HelveticaNeue-CondensedBlack"
        static let size = 30
    }

}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // TODO: Set impact font, all caps, white with black outline by using defaultTextAttributes
    // TODO: When user click inside text field - initial text disappears - textFieldDidBeginEditing
    // TODO: By pressing return - keyboard should be dismissed - textFieldShouldReturn

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

    func initTextFields() {
        topTextField.text = Constants.TextField.topText
        bottomTextField.text = Constants.TextField.bottomText

        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center

        topTextField.font = UIFont(name: Constants.TextField.font, size: CGFloat(Constants.TextField.size))
        bottomTextField.font = UIFont(name: Constants.TextField.font, size: CGFloat(Constants.TextField.size))
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
}
