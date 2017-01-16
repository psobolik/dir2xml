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
    var creationDate: Date?
    var modificationDate: Date?
    var owner: String?
    var group: String?
    var type: String?
    var permissions: NSNumber?
    var size: NSNumber?
    var items: [Dir2XmlItem] = [Dir2XmlItem]()

    let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    }
    
    func isDir() -> Bool {
        return self.type == "NSFileTypeDirectory"
    }
    
    func readFrom(_ url: URL, level: Int = 0) throws {
        self.path = url.path
        self.name = url.lastPathComponent

        let fileManager = FileManager.default
        self.setAttributes(try fileManager.attributesOfItem(atPath: url.path))// as! [String : AnyObject])
        
        if self.isDir() && level >= 0 {
            let contentsOfDirectory = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options:FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
            for itemUrl in contentsOfDirectory {
                let item = Dir2XmlItem()
                self.items.append(item)
                try item.readFrom(itemUrl, level: level - 1)
            }
        }
    }

    func setAttributes(_ attributes:[FileAttributeKey: Any]) {
        self.creationDate = attributes[FileAttributeKey.creationDate] as! Date?
        self.type = attributes[FileAttributeKey.type] as! String?
        self.owner = attributes[FileAttributeKey.ownerAccountName] as! String?
        self.group = attributes[FileAttributeKey.groupOwnerAccountName] as! String?
        self.modificationDate = attributes[FileAttributeKey.modificationDate] as! Date?
        self.permissions = attributes[FileAttributeKey.posixPermissions] as! NSNumber?
        self.size = attributes[FileAttributeKey.size] as! NSNumber?
    }
    
    func toElement() -> XMLElement {
        let result = makeElement()
        for child in items {
            result.addChild(child.toElement())
        }
        return result
    }
    
    func makeElement() -> XMLElement {
        let result = XMLNode.element(withName: type!) as! XMLElement
        if (name != nil) { result.addAttribute(XMLNode.attribute(withName: "name", stringValue: name!) as! XMLNode) }
        if (path != nil) { result.addAttribute(XMLNode.attribute(withName: "path", stringValue: path!) as! XMLNode) }
        if (creationDate != nil) { result.addAttribute(XMLNode.attribute(withName: "creationDate", stringValue: dateFormatter.string(from: creationDate!)) as! XMLNode) }
        if (modificationDate != nil) { result.addAttribute(XMLNode.attribute(withName: "modificationDate", stringValue: dateFormatter.string(from: modificationDate!)) as! XMLNode) }
        if (owner != nil) { result.addAttribute(XMLNode.attribute(withName: "owner", stringValue: owner!) as! XMLNode) }
        if (group != nil) { result.addAttribute(XMLNode.attribute(withName: "group", stringValue: group!) as! XMLNode) }
        if (permissions != nil) { result.addAttribute(XMLNode.attribute(withName: "permissions", stringValue: String(format:"%2O", (permissions?.int16Value)!)) as! XMLNode) }
        if (size != nil) { result.addAttribute(XMLNode.attribute(withName: "size", stringValue: String(describing: size!)) as! XMLNode) }
        return result
    }
}
