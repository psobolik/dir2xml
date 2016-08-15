import Cocoa

class File {
    var path: String?
    var creationDate: NSDate?
    var modificationDate: NSDate?
    var owner: String?
    var group: String?
    var type: String?
    var permissions: NSNumber?
    var size: NSNumber?
}

func ReadDirectory(path: NSURL) throws -> [File] {
    let fileManager = NSFileManager.defaultManager()
    let contentsOfDirectory = try fileManager.contentsOfDirectoryAtURL(path, includingPropertiesForKeys: nil, options:NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants)
    var files = [File]()
    for fileUrl in contentsOfDirectory {
        let file = File()
        file.path = fileUrl.path
        let attributes = try fileManager.attributesOfItemAtPath(file.path!)
        file.creationDate = attributes["NSFileCreationDate"] as! NSDate?
        file.type = attributes["NSFileType"] as! String?
        file.owner = attributes["NSFileOwnerAccountName"] as! String?
        file.group = attributes["NSFileGroupOwnerAccountName"] as! String?
        file.modificationDate = attributes["NSFileModificationDate"] as! NSDate?
        file.permissions = attributes["NSFilePosixPermissions"] as! NSNumber?
        file.size = attributes["NSFileSize"] as! NSNumber?
        files += [file]
    }
    return files
}
let path = NSURL(fileURLWithPath: "/Users/psobolik")
do {
    var files = try ReadDirectory(path)
} catch {
    let e = error as NSError
    print ("Whoops! \(e.localizedDescription)")
}
//let fileManager = NSFileManager.defaultManager()
//do {
//    let contentsOfDirectory = try fileManager.contentsOfDirectoryAtURL(path, includingPropertiesForKeys: nil, options:NSDirectoryEnumerationOptions.SkipsSubdirectoryDescendants)
//    var files = [File]()
//    for fileUrl in contentsOfDirectory {
//        var file = File()
//        file.path = fileUrl.path
//        let attributes = try fileManager.attributesOfItemAtPath(fileUrl.path!)
//        file.creationDate = attributes["NSFileCreationDate"] as! NSDate?
//        file.type = attributes["NSFileType"] as! String?
//        file.owner = attributes["NSFileOwnerAccountName"] as! String?
//        file.group = attributes["NSFileGroupOwnerAccountName"] as! String?
//        file.modificationDate = attributes["NSFileModificationDate"] as! NSDate?
//        file.permissions = attributes["NSFilePosixPermissions"] as! NSNumber?
//        file.size = attributes["NSFileSize"] as! NSNumber?
//        files += [file]
////        print(fileUrl.path)
////        let creationDate = attributes["NSFileCreationDate"]
////        let type = attributes["NSFileType"]
////        let owner = attributes["NSFileOwnerAccountName"]
////        let group = attributes["NSFileGroupOwnerAccountName"]
////        let modificationDate = attributes["NSFileModificationDate"]
////        let permissions = attributes["NSFilePosixPermissions"]
////        let size = attributes["NSFileSize"]
//    }
//} catch {
//    let e = error as NSError
//    print ("Whoops! \(e.localizedDescription)")
//}
