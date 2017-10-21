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
    
    init(withConfiguration configuration: ViperModuleGeneratorConfiguration) {
        context = [
            "moduleName": configuration.moduleName,
            "creator": configuration.creator as Any
        ]
    }
    
    func generateModule() {
        guard let moduleName = context["moduleName"],
            let moduleFolder = try? Folder.current.createSubfolderIfNeeded(withName: "\(moduleName)"),
            let templateFolder = try? Folder(path: "Templates/default") else { return }
        
        templateFolder.subfolders.forEach { folder in
            try! folder.copy(to: moduleFolder)
        }

        moduleFolder.makeFileSequence(recursive: true, includeHidden: false).forEach { templateFile in
            guard let parentFolder = templateFile.parent else { return }
            render(template: templateFile.path, toFile: parentFolder.path.appending("\(moduleName)\(templateFile.nameExcludingExtension).swift"))
            try! templateFile.delete()
        }
    }
    
    fileprivate func render(template templateName: String, toFile: String) {
        do {
            let renderedTemplate = try environment.renderTemplate(name: templateName, context: context)
            print(renderedTemplate)
            
            try renderedTemplate.write(toFile: toFile, atomically: false, encoding: .utf8)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
}
