import Commander

let vipergenCommand = command (
    Argument<String>("module name", description: "The name of the module", validator: nil),
    Option<String>("template", "default", flag: nil, description: "The template (Should exist in the Templates directory)", validator: nil),
    Option<String>("creator", "John Doe", flag: nil, description: "The name of the creator", validator: nil),
    Option<String>("output", ".", flag: nil, description: "The output directory", validator: nil)
) { (moduleName: String, template: String, creator: String, output: String) in
    
    let configuration = ViperModuleGeneratorConfiguration(moduleName: moduleName, template: template, creator: creator, outputFolder: output)
    let viperModuleGenerator = ViperModuleGenerator(withConfiguration: configuration)
    viperModuleGenerator.generateModule()
    
}

vipergenCommand.run()
