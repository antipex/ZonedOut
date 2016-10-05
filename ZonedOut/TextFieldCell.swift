//
//  TextFieldCell.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 21/02/2016.
//  Copyright © 2016 Kyle Rohr. All rights reserved.
//

import UIKit

protocol TextFieldCellDelegate {
    func textFieldCell(_ cell: TextFieldCell, didUpdateValue value: String?)
}

class TextFieldCell: UITableViewCell, UITextFieldDelegate {

    var delegate: TextFieldCellDelegate?

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }

    // MARK: - UITextFieldDelegate

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldCell(self, didUpdateValue: textField.text)
    }

}
