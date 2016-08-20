//
//  Dir2XmlItem.swift
//  dir2xml
//
//  Created by Paul Sobolik on 8/14/16.
//  Copyright © 2016 Paul Sobolik. All rights reserved.
//

import Foundation

class Dir2XmlItem {
    var path: String?
    var name: String?
    var creationDate: NSDate?
    var modificationDate: NSDate?
    var owner: String?
    var group: String?
    var type: String?
    var permissions: NSNumber?
    var size: NSNumber?
    var items: [Dir2XmlItem] = [Dir2XmlItem]()

    let dateFormatter = NSDateFormatter()
    
    init() {
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    }
    
    func isDir() -> Bool {
        return self.type == "NSFileTypeDirectory"
    }
    
    func readFrom(url: NSURL, level: Int = 0) throws {
        self.path = url.path
        self.name = url.lastPathComponent

        let fileManager = NSFileManager.defaultManager()
        self.setAttributes(try fileManager.attributesOfItemAtPath(url.path!))
        
        if self.isDir() && level >= 0 {
            let contentsOfDirectory = try fileManager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options:NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants)
            for itemUrl in contentsOfDirectory {
                let item = Dir2XmlItem()
                self.items.append(item)
                try item.readFrom(itemUrl, level: level - 1)
            }
        }
    }

    func setAttributes(attributes:[String : AnyObject]) {
        self.creationDate = attributes["NSFileCreationDate"] as! NSDate?
        self.type = attributes["NSFileType"] as! String?
        self.owner = attributes["NSFileOwnerAccountName"] as! String?
        self.group = attributes["NSFileGroupOwnerAccountName"] as! String?
        self.modificationDate = attributes["NSFileModificationDate"] as! NSDate?
        self.permissions = attributes["NSFilePosixPermissions"] as! NSNumber?
        self.size = attributes["NSFileSize"] as! NSNumber?
    }
    
    func toElement() -> NSXMLElement {
        let result = makeElement()
        for child in items {
            result.addChild(child.toElement())
        }
        return result
    }
    
    func makeElement() -> NSXMLElement {
        let result = NSXMLNode.elementWithName(type!) as! NSXMLElement
        if (name != nil) { result.addAttribute(NSXMLNode.attributeWithName("name", stringValue: name!) as! NSXMLNode) }
        if (path != nil) { result.addAttribute(NSXMLNode.attributeWithName("path", stringValue: path!) as! NSXMLNode) }
        if (creationDate != nil) { result.addAttribute(NSXMLNode.attributeWithName("creationDate", stringValue: dateFormatter.stringFromDate(creationDate!)) as! NSXMLNode) }
        if (modificationDate != nil) { result.addAttribute(NSXMLNode.attributeWithName("modificationDate", stringValue: dateFormatter.stringFromDate(modificationDate!)) as! NSXMLNode) }
        if (owner != nil) { result.addAttribute(NSXMLNode.attributeWithName("owner", stringValue: owner!) as! NSXMLNode) }
        if (group != nil) { result.addAttribute(NSXMLNode.attributeWithName("group", stringValue: group!) as! NSXMLNode) }
        if (permissions != nil) { result.addAttribute(NSXMLNode.attributeWithName("permissions", stringValue: String(format:"%2O", (permissions?.shortValue)!)) as! NSXMLNode) }
        if (size != nil) { result.addAttribute(NSXMLNode.attributeWithName("size", stringValue: String(size!)) as! NSXMLNode) }
        return result
    }
}
