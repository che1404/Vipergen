//
// Created by Roberto Garrido on 17/12/17.
//

import Stencil
import PathKit

class TemplateRendererStencil: TemplateRenderer {
    func renderTemplate(withName: String, fromTemplatesPath: String, outputPath: String, templateContext: [String: Any]) throws {
        // Prepare the Stencil environment
        let fileSystemLoader = FileSystemLoader(paths: [Path(fromTemplatesPath)])
        let environment = Environment(loader: fileSystemLoader)

        // Render the template to a string, and write it to the output file path
        let renderedTemplate = try environment.renderTemplate(name: withName, context: templateContext)
        try renderedTemplate.write(toFile: outputPath, atomically: false, encoding: .utf8)
    }
}
