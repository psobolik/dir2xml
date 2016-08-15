//
//  main.swift
//  dir2xml
//
//  Created by Paul Sobolik on 2016-08-14.
//  Copyright © 2016 Paul Sobolik. All rights reserved.
//

import Foundation

if Process.arguments.count < 2 {
    print ("usage: \(Process.arguments[0]) <path>")
    exit(EXIT_FAILURE)
}
let path = NSURL(fileURLWithPath: NSString(string: Process.arguments[1]).stringByExpandingTildeInPath)
do {
    let dir2XmlFolder = Dir2XmlFolder()
    try dir2XmlFolder.Read(path)
    
    let root = dir2XmlFolder.makeElement()
    for item in dir2XmlFolder.items {
        root.addChild(item.makeElement())
    }
    var doc = NSXMLElement.documentWithRootElement(root) as! NSXMLDocument
    doc.version = "1.0"
    doc.characterEncoding = "UTF-8"
    let s = doc.XMLStringWithOptions(NSXMLNodePrettyPrint)
    print (s)
} catch {
    let e = error as NSError
    print ("Whoops! \(e.localizedDescription)")
    exit(EXIT_FAILURE)
}
exit(EXIT_SUCCESS)

