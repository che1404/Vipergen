//
//  ViperModuleGenerator.swift
//  viper-module-generator
//
//  Created by Roberto on 20/10/17.
//

import Foundation
import Stencil
import Files
import PathKit

class ViperModuleGenerator {
    static let vipergenTemplatesFolderName = "vipergen_templates"
    fileprivate let context: [String: Any]
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
            // Abort if the template selected by the user doesn't exitst in the templates folder
            let templateName = configuration.template
            if templateName != "default" {
                let templateExistsInTemplatesFolder = try Folder(path: Bundle.main.bundlePath).subfolder(named: ViperModuleGenerator.vipergenTemplatesFolderName).containsSubfolder(named: templateName)
                if !templateExistsInTemplatesFolder {
                    print("The template \"\(templateName)\" doesn't exist in the templates folder. Please copy the template named \"\(templateName)\" to the templates folder")
                    return
                }
            }
            
            /*
             Set the output folder. If the output folder is the default, use the current folder as output folder,
             otherwise create the folder selected by the user
             */
            var outputFolder: Folder!
            if configuration.outputFolder != "." {
                try FileManager.default.createDirectory(at: URL(string: "file://\(configuration.outputFolder)")!, withIntermediateDirectories: true, attributes: nil)
                outputFolder = try Folder(path: configuration.outputFolder)
            } else {
                outputFolder = Folder.current
            }
            
            // Create the module folder
            let moduleFolder = try outputFolder.createSubfolderIfNeeded(withName: "\(moduleName)")
            
            // Get the reference to the output folder
            let templateFolder = try Folder(path: Bundle.main.bundlePath.appending("/\(ViperModuleGenerator.vipergenTemplatesFolderName)/\(configuration.template)"))
            
            // Copy the contents of the template to the output folder
            try templateFolder.subfolders.forEach { folder in
                try folder.copy(to: moduleFolder)
            }
            
            // For each template file in the output folder structure, replace it with rendered file
            try moduleFolder.makeFileSequence(recursive: true, includeHidden: false).forEach { templateFile in
                guard let parentFolder = templateFile.parent else { throw NSError(domain: "generateModule", code: -1, userInfo: [NSLocalizedDescriptionKey: "The template file \(templateFile.name) doesn't have a parent\nAborting"]) }
                try render(template: templateFile.path, toFile: parentFolder.path.appending("\(moduleName)\(templateFile.nameExcludingExtension).swift"))
                try templateFile.delete()
            }
        } catch (let error) {
            switch error {
            case Folder.PathError.invalid(let stringError):
                print("Invalid path error: \(stringError)")
            case FileSystem.Item.OperationError.deleteFailed(let item):
                print("Error deleting: \(item.name)")
            default:
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func render(template templateName: String, toFile: String) throws {
        let moduleName = configuration.moduleName
        let templatesPath = configuration.outputFolder.appending("/\(moduleName)")
        
        // Prepare the Stencil environment
        let fileSystemLoader = FileSystemLoader(paths: [Path(templatesPath)])
        let environment = Environment(loader: fileSystemLoader)
        
        // Render the template to a string, and write it to the output file path
        let renderedTemplate = try environment.renderTemplate(name: templateName, context: context)
        try renderedTemplate.write(toFile: toFile, atomically: false, encoding: .utf8)
    }
}
