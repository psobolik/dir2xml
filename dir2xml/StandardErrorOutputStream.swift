//
//  StandardErrorOutputStream.swift
//  dir2xml
//
//  Created by Paul Sobolik on 2016-08-20.
//  Copyright © 2016 Paul Sobolik. All rights reserved.
//

import Foundation

class StandardErrorOutputStream: OutputStreamType {
    func write(string: String) {
        let stderr = NSFileHandle.fileHandleWithStandardError()
        stderr.writeData(string.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
}
