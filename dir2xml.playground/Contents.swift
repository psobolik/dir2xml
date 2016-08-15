import Cocoa

class Dir2XmlFile {
    var path: String?
    var creationDate: NSDate?
    var modificationDate: NSDate?
    var owner: String?
    var group: String?
    var type: String?
    var permissions: NSNumber?
    var size: NSNumber?
}

func ReadDirectory(path: NSURL) throws -> [Dir2XmlFile] {
    let fileManager = NSFileManager.defaultManager()
    let contentsOfDirectory = try fileManager.contentsOfDirectoryAtURL(path, includingPropertiesForKeys: nil, options:NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants)
    var result = [Dir2XmlFile]()
    for fileUrl in contentsOfDirectory {
        let file = Dir2XmlFile()
        file.path = fileUrl.path
        let attributes = try fileManager.attributesOfItemAtPath(file.path!)
        file.creationDate = attributes["NSFileCreationDate"] as! NSDate?
        file.type = attributes["NSFileType"] as! String?
        file.owner = attributes["NSFileOwnerAccountName"] as! String?
        file.group = attributes["NSFileGroupOwnerAccountName"] as! String?
        file.modificationDate = attributes["NSFileModificationDate"] as! NSDate?
        file.permissions = attributes["NSFilePosixPermissions"] as! NSNumber?
        file.size = attributes["NSFileSize"] as! NSNumber?
        result += [file]
    }
    return result
}

let RFC3339DateFormatter = NSDateFormatter()
RFC3339DateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
RFC3339DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)

let path = NSURL(fileURLWithPath: "/Users/psobolik")
do {
    var dir2XmlFiles = try ReadDirectory(path)
    let root = NSXMLElement.elementWithName("directory") as! NSXMLElement
    for dir2XmlFile in dir2XmlFiles {
        let node = NSXMLNode.elementWithName("file") as! NSXMLElement
        node.addAttribute(NSXMLNode.attributeWithName("path", stringValue: dir2XmlFile.path!) as! NSXMLNode)
        node.addAttribute(NSXMLNode.attributeWithName("creationDate", stringValue: RFC3339DateFormatter.stringFromDate(dir2XmlFile.creationDate!)) as! NSXMLNode)
        node.addAttribute(NSXMLNode.attributeWithName("modificationDate", stringValue: RFC3339DateFormatter.stringFromDate(dir2XmlFile.modificationDate!)) as! NSXMLNode)
        node.addAttribute(NSXMLNode.attributeWithName("type", stringValue: dir2XmlFile.type!) as! NSXMLNode)
        node.addAttribute(NSXMLNode.attributeWithName("owner", stringValue: dir2XmlFile.owner!) as! NSXMLNode)
        node.addAttribute(NSXMLNode.attributeWithName("group", stringValue: dir2XmlFile.group!) as! NSXMLNode)
        node.addAttribute(NSXMLNode.attributeWithName("permissions", stringValue: String(format:"%2O", (dir2XmlFile.permissions?.shortValue)!)) as! NSXMLNode)
        node.addAttribute(NSXMLNode.attributeWithName("size", stringValue: String(dir2XmlFile.size!)) as! NSXMLNode)
        root.addChild(node)
    }
    var doc = NSXMLElement.documentWithRootElement(root) as! NSXMLDocument
    doc.version = "1.0"
    doc.characterEncoding = "UTF-8"
    let s = doc.XMLStringWithOptions(NSXMLNodePrettyPrint)
} catch {
    let e = error as NSError
    print ("Whoops! \(e.localizedDescription)")
}


//var node = NSXMLNode.elementWithName("Foo") as! NSXMLElement
//node.addAttribute(NSXMLNode.attributeWithName("name", stringValue: "bar") as! NSXMLNode)
//root.addChild(node)
//
//var date = NSDate()
//var attribute = NSXMLNode.attributeWithName("date", stringValue: RFC3339DateFormatter.stringFromDate(date)) as! NSXMLNode
//node.addAttribute(attribute)
//
// var xmlData = doc.XMLDataWithOptions(NSXMLDocumentTidyXML)
//var doc = NSXMLElement.documentWithRootElement(root) as! NSXMLDocument
//doc.version = "1.0"
//doc.characterEncoding = "UTF-8"
//let s = doc.XMLStringWithOptions(NSXMLDocumentTidyXML)
//print (s)
