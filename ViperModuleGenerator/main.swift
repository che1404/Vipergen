//
//  main.swift
//  ViperModuleGenerator
//
//  Created by Roberto on 17/10/17.
//  Copyright © 2017 robertogarrido.com. All rights reserved.
//

import Stencil

let template = Template(templateString: "Hello {{ name }}")
_ = try template.render(["name": "kyle"])
