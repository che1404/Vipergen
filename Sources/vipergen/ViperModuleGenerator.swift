//
//  ViperModuleGenerator.swift
//  viper-module-generator
//
//  Created by Roberto on 20/10/17.
//

import Foundation
import Stencil
import Files

class ViperModuleGenerator {
    fileprivate let context: [String: Any]
    fileprivate let fileSystemLoader = FileSystemLoader(bundle: [Bundle.main])
    fileprivate var environment: Environment {
        return Environment(loader: fileSystemLoader)
    }
    fileprivate let configuration: ViperModuleGeneratorConfiguration
    
    init(withConfiguration configuration: ViperModuleGeneratorConfiguration) {
        self.configuration = configuration
        context = [
            "moduleName": configuration.moduleName,
            "creator": configuration.creator as Any
        ]
    }
    
    func generateModule() {
        let moduleName = configuration.moduleName
        do {
            let moduleFolder = try Folder.current.createSubfolderIfNeeded(withName: "\(moduleName)")
            let templateFolder = try Folder(path: "Templates/default")
            
            try templateFolder.subfolders.forEach { folder in
                try folder.copy(to: moduleFolder)
            }
            
            try moduleFolder.makeFileSequence(recursive: true, includeHidden: false).forEach { templateFile in
                guard let parentFolder = templateFile.parent else { throw NSError(domain: "generateModule", code: -1, userInfo: [NSLocalizedDescriptionKey: "The template file \(templateFile.name) doesn't have a parent\nAborting"]) }
                try render(template: templateFile.path, toFile: parentFolder.path.appending("\(moduleName)\(templateFile.nameExcludingExtension).swift"))
                try templateFile.delete()
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func render(template templateName: String, toFile: String) throws {
        let renderedTemplate = try environment.renderTemplate(name: templateName, context: context)
        try renderedTemplate.write(toFile: toFile, atomically: false, encoding: .utf8)
    }
}
