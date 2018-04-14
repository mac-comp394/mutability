//
//  Engine.swift
//  Todo
//
//  Created by Paul on 2018/4/4.
//

import Foundation

struct Engine {
    static func run(on model: Model, applying messages: [Message]) -> Model {
        return runWithHistory(on: model, applying: messages).last!
    }

    static func runWithHistory(on model: Model, applying messages: [Message]) -> [Model] {
        var models: [Model] = []
        var new_model = model
        for message in messages {
            new_model = message.apply(to: new_model)
            models.append(new_model)
        }
        return models
    }
}
