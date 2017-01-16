//
//  StandardErrorOutputStream.swift
//  dir2xml
//
//  Created by Paul Sobolik on 2016-08-20.
//  Copyright © 2016 Paul Sobolik. All rights reserved.
//

import Foundation

class StandardErrorOutputStream: TextOutputStream {
    func write(_ string: String) {
        let stderr = FileHandle.standardError
        stderr.write(string.data(using: String.Encoding.utf8)!)
    }
}
