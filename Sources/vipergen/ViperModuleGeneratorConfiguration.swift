//
//  ViperModuleGeneratorConfig.swift
//  viper-module-generator
//
//  Created by Roberto on 20/10/17.
//

import Foundation

struct ViperModuleGeneratorConfiguration {
    var moduleName: String
    var creator: String?
    
    init(moduleName name: String) {
        self.moduleName = name
    }
}
