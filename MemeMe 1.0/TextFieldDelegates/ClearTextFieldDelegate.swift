//
//  ClearTextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by Rinalds Domanovs on 31/05/2019.
//  Copyright © 2019 Rinalds Domanovs. All rights reserved.
//

import Foundation
import UIKit

class ClearTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
