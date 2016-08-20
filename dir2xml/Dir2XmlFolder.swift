//
//  Dir2XmlFolder.swift
//  dir2xml
//
//  Created by Paul Sobolik on 2016-08-14.
//  Copyright © 2016 Paul Sobolik. All rights reserved.
//

import Foundation

//class Dir2XmlFolder: Dir2XmlItem {
//    var items: [Dir2XmlItem] = [Dir2XmlItem]()
//    
//    override init() {
//        super.init()
//        elementName = "folder"
//    }
//    
//    func Read(url: NSURL, level: Int = 0) throws {
//        try super.Read(url)
//        
//        let contentsOfDirectory = try fileManager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options:NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants)
//        for itemUrl in contentsOfDirectory {
//            var isDir : ObjCBool = false
//            if fileManager.fileExistsAtPath(itemUrl.path!, isDirectory: &isDir) {
//                var item: Dir2XmlItem
//                if isDir {
//                    item = Dir2XmlFolder()
//                    item.path = itemUrl.path!
//                    item.name = itemUrl.lastPathComponent
//                    item.setAttributes(try fileManager.attributesOfItemAtPath(itemUrl.path!))
//                } else {
//                    item = Dir2XmlFile()
//                    item.path = itemUrl.path!
//                    item.name = itemUrl.lastPathComponent
//                    item.setAttributes(try fileManager.attributesOfItemAtPath(itemUrl.path!))
//                }
//                self.items.append(item)
//            }
//        }
//    }

//    func Read(url: NSURL) throws {
//        let fileManager = NSFileManager.defaultManager()
//        self.path = url.path
//        self.name = url.lastPathComponent
//        self.setAttributes(try fileManager.attributesOfItemAtPath(url.path!))
//        
//        let contentsOfDirectory = try fileManager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options:NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants)
//        for itemUrl in contentsOfDirectory {
//            var isDir : ObjCBool = false
//            if fileManager.fileExistsAtPath(itemUrl.path!, isDirectory: &isDir) {
//                var item: Dir2XmlItem
//                if isDir {
//                    item = Dir2XmlFolder()
//                    item.path = itemUrl.path!
//                    item.name = itemUrl.lastPathComponent
//                    item.setAttributes(try fileManager.attributesOfItemAtPath(itemUrl.path!))
//                } else {
//                    item = Dir2XmlFile()
//                    item.path = itemUrl.path!
//                    item.name = itemUrl.lastPathComponent
//                    item.setAttributes(try fileManager.attributesOfItemAtPath(itemUrl.path!))
//                }
//                self.items.append(item)
//            }
//        }
//    }
//}