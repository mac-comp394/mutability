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
        var newModel = model
//        var modelHistory = [Model]()
//        for message in messages{
//            newModel = message.apply(to: newModel)
//            modelHistory.append(newModel)
//        }
//        return modelHistory
        return messages.map({
            (message: Message) -> Model in
            newModel = message.apply(to: newModel)
            return newModel
        })
    }
}
