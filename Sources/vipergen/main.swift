
var configuration = ViperModuleGeneratorConfiguration(moduleName: "Onboarding")
configuration.creator = "Awesome Developer"

let viperModuleGenerator = ViperModuleGenerator(withConfiguration: configuration)
viperModuleGenerator.generateModule()
