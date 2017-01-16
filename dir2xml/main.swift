//
//  main.swift
//  dir2xml
//
//  Created by Paul Sobolik on 2016-08-14.
//  Copyright © 2016 Paul Sobolik. All rights reserved.
//

import Foundation

enum ArgError: Error {
    case invalidSwitch(invalidSwitch: String)
    case wrongNumberOfArguments
}

func ParseArgs(_ args: [String]) throws -> (pathArg: String, prettyPrint: Bool) {
    var result: (pathArg: String, prettyPrint: Bool) = ("", false)
    
    switch args.count {
    case 1:
        break
    case 2:
        if args[1].commonPrefix(with: "-", options: NSString.CompareOptions.literal) == "-" {
            throw ArgError.wrongNumberOfArguments
        } else {
            result.pathArg = args[1]
        }
    case 3:
        if args[1] == "-p" {
            result.prettyPrint = true
            result.pathArg = args[2]
        } else {
            throw ArgError.invalidSwitch(invalidSwitch: args[1])
        }
    default:
        throw ArgError.wrongNumberOfArguments
    }
    return result
}

func PrintUsage() {
    print ("usage: \(CommandLine.arguments[0]) [-p] <path>")
}

func PrintErrorAndFail(_ message: String) {
    var mx_stderr = StandardErrorOutputStream()
    print ("Error: \(message)", to:&mx_stderr)
    PrintUsage()
    exit(EXIT_FAILURE)
}

func main() {
    do {
        let (pathArg, prettyPrint) = try ParseArgs(CommandLine.arguments)
        if pathArg == "" {
            PrintUsage()
            exit(EXIT_FAILURE)
        }
        
        let pathUrl = URL(fileURLWithPath: NSString(string: pathArg).expandingTildeInPath)
        let dir2XmlRoot = Dir2XmlItem()
        try dir2XmlRoot.readFrom(pathUrl)
        
        let root = dir2XmlRoot.toElement()
        let doc = XMLElement.document(withRootElement: root) as! XMLDocument
        doc.version = "1.0"
        doc.characterEncoding = "UTF-8"
//        let options = prettyPrint ? XMLNode.Options.nodePrettyPrint : XMLNode.Options.nodePreserveQuotes
        // Can't pretty print! Can't call XMLNode.xmlString(withOptions:)!
        let str =  doc.xmlString // prettyPrint ? doc.xmlString : doc.xmlString(withOptions: XMLNode.Options.nodePrettyPrint)
        print (str)
    } catch ArgError.wrongNumberOfArguments {
        PrintErrorAndFail("Wrong number of arguments")
    } catch ArgError.invalidSwitch(let invalidSwitch) {
        PrintErrorAndFail("Invalid switch: \(invalidSwitch)")
    } catch {
        let e = error as NSError
        PrintErrorAndFail(e.localizedDescription)
    }
    exit(EXIT_SUCCESS)
}

main()
