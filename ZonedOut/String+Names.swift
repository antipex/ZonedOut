//
//  String+Names.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

extension String {

    /// Returns the first character of the String
    var firstCharacter: String {
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: 1))
    }

}
