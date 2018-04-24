//
//  Messages.swift
//  Todo
//
//  Created by Paul on 2018/4/4.
//

import Foundation

enum Message {
    case add
    case updateNewEntryField(String)
    case check(Int, Bool)
    case delete(Int)
    case deleteAllCompleted

    func apply(to model: Model) -> Model {
        var newModel: Model = model
        switch(self) {
            case .add:
                if !newModel.newEntryField.isBlank() {
                    newModel.entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                newModel.nextID += 1
                newModel.newEntryField = ""

            case .updateNewEntryField(let str):
                newModel.newEntryField = str

            case .check(let id, let isCompleted):
                var newEntries: [Entry] = []
                for entry in newModel.entries {
                    if(entry.id == id) {
                        newEntries.append(
                            Entry(
                                id: entry.id,
                                description: entry.description,
                                completed: isCompleted
                            )
                        )
                    } else {
                        newEntries.append(entry)
                    }
                }
               newModel.entries = newEntries

            case .delete(let id):
                newModel.entries.remove { $0.id == id }

            case .deleteAllCompleted:
                newModel.entries.remove { $0.completed }
        }
        return newModel
    }
}
