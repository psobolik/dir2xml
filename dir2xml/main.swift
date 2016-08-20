//
//  main.swift
//  dir2xml
//
//  Created by Paul Sobolik on 2016-08-14.
//  Copyright © 2016 Paul Sobolik. All rights reserved.
//

import Foundation

enum ArgError: ErrorType {
    case InvalidSwitch(invalidSwitch: String)
    case WrongNumberOfArguments
}

func ParseArgs(args: [String]) throws -> (pathArg: String, prettyPrint: Bool) {
    var result: (pathArg: String, prettyPrint: Bool) = ("", false)
    
    switch args.count {
    case 1:
        break
    case 2:
        if args[1].commonPrefixWithString("-", options: NSStringCompareOptions.LiteralSearch) == "-" {
            throw ArgError.WrongNumberOfArguments
        } else {
            result.pathArg = args[1]
        }
    case 3:
        if args[1] == "-p" {
            result.prettyPrint = true
            result.pathArg = args[2]
        } else {
            throw ArgError.InvalidSwitch(invalidSwitch: args[1])
        }
    default:
        throw ArgError.WrongNumberOfArguments
    }
    return result
}

func PrintUsage() {
    print ("usage: \(Process.arguments[0]) [-p] <path>")
}

func PrintErrorAndFail(message: String) {
    var mx_stderr = StandardErrorOutputStream()
    print ("Error: \(message)", toStream:&mx_stderr)
    PrintUsage()
    exit(EXIT_FAILURE)
}

do {
    let (pathArg, prettyPrint) = try ParseArgs(Process.arguments)
    if pathArg == "" {
        PrintUsage()
        exit(EXIT_FAILURE)
    }
    let pathUrl = NSURL(fileURLWithPath: NSString(string: pathArg).stringByExpandingTildeInPath)
    let dir2XmlFolder = Dir2XmlFolder()
    try dir2XmlFolder.Read(pathUrl)
    
    let root = dir2XmlFolder.makeElement()
    for item in dir2XmlFolder.items {
        root.addChild(item.makeElement())
    }
    var doc = NSXMLElement.documentWithRootElement(root) as! NSXMLDocument
    doc.version = "1.0"
    doc.characterEncoding = "UTF-8"
    let str = doc.XMLStringWithOptions(prettyPrint ? NSXMLNodePrettyPrint : NSXMLNodeOptionsNone)
    print (str)
} catch ArgError.WrongNumberOfArguments {
    PrintErrorAndFail("Wrong number of arguments")
} catch ArgError.InvalidSwitch(let invalidSwitch) {
    PrintErrorAndFail("Invalid switch: \(invalidSwitch)")
} catch {
    let e = error as NSError
    PrintErrorAndFail(e.localizedDescription)
}
exit(EXIT_SUCCESS)

