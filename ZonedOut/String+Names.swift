//
//  String+Names.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

extension String {

    var firstCharacter: String {
        return self.substringToIndex(self.startIndex.advancedBy(1))
    }

}
