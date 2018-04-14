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
        var model1 = model
        return messages.map { message in
          model1 = message.apply(to: model1)
          return model1
        }
    }
}
