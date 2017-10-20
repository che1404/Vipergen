//
//  ViperModuleGenerator.swift
//  viper-module-generator
//
//  Created by Roberto on 20/10/17.
//

import Foundation
import Stencil

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
        renderWireframe()
        renderView()
        renderPresenter()
        renderInteractor()
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
    
    fileprivate func renderWireframe() {
        render(template: "Templates/Wireframe.stencil", toFile: "\(context["moduleName"]!)Wireframe.swift")
    }
    
    fileprivate func renderView() {
        render(template: "Templates/View.stencil", toFile: "\(context["moduleName"]!)View.swift")
    }
    
    fileprivate func renderPresenter() {
        render(template: "Templates/Presenter.stencil", toFile: "\(context["moduleName"]!)Presenter.swift")
    }
    
    fileprivate func renderInteractor() {
        render(template: "Templates/Interactor.stencil", toFile: "\(context["moduleName"]!)Interactor.swift")
    }
}
