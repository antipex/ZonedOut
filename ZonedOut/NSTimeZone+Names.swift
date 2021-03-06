//
//  NSTimeZone+Names.swift
//  ZonedOut
//
//  Created by Kyle Rohr on 20/10/2015.
//  Copyright © 2015 Kyle Rohr. All rights reserved.
//

import UIKit

extension TimeZone {

    /// Returns the time zone name formatted with spaces instead of underscores
    var displayName: String {
        return identifier.replacingOccurrences(of: "_", with: " ")
    }

}
