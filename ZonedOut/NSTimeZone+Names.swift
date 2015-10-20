//
//  NSTimeZone+Names.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

extension NSTimeZone {

    var displayName: String {
        return name.stringByReplacingOccurrencesOfString("_", withString: " ")
    }

}
