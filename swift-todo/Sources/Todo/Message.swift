//
//  Messages.swift
//  Todo
//
//  Created by Paul on 2018/4/4.
//

import Foundation

//array = [a,b,c]
//
//map (function)
//array: a -> function(a) -> x
//
//
//function = { y in
//
//    return x
//}

enum Message {
    case add
    case updateNewEntryField(String)
    case check(Int, Bool)
    case delete(Int)
    case deleteAllCompleted

    func apply(to model: Model) -> Model {
        var mutableModel = model
        
        switch(self) {
            case .add:
                if !model.newEntryField.isBlank() {
                    mutableModel.entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                
                mutableModel.nextID += 1
                mutableModel.newEntryField = ""

            case .updateNewEntryField(let str):
                mutableModel.newEntryField = str

            case .check(let id, let isCompleted):
                mutableModel.entries = mutableModel.entries.map { entry in
                    var mutableEntry = entry
                    if(entry.id == id) {
                        mutableEntry.id = id
                        mutableEntry.completed = isCompleted
                    }
                    return mutableEntry
                }

            case .delete(let id):
                mutableModel.entries.remove { $0.id == id }

            case .deleteAllCompleted:
                mutableModel.entries.remove { $0.completed }
        }
        return mutableModel
    }
}
