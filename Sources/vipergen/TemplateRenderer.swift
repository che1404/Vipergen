//
//  TemplateRenderer.swift
//
//  Created by Roberto Garrido on 17/12/17.
//

import Foundation

protocol TemplateRenderer {
    func renderTemplate(withName: String, fromTemplatesPath: String, outputPath: String, templateContext: [String: Any]) throws
}
