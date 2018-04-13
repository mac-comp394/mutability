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
        switch(self) {
            case .add:
                if !model.newEntryField.isBlank() {
                    return Model(nextID: model.nextID + 1,
                                          newEntryField: "",
                                          entries: model.entries + [Entry(id: model.nextID,
                                                                          description: model.newEntryField)])
                }
                return Model(nextID: model.nextID + 1,
                             newEntryField: "",
                             entries: model.entries)

            case .updateNewEntryField(let str):
                return Model(nextID: model.nextID,
                                      newEntryField: str,
                                      entries: model.entries)

            case .check(let id, let isCompleted):
                var model_entries = model.entries
                for (index, entry) in model_entries.enumerated() {
                    if(entry.id == id) {
                        let new_entry = Entry(id: entry.id,
                                              description: entry.description,
                                              completed: isCompleted)
                        model_entries[index] = new_entry
                        return Model(nextID: model.nextID,
                                              newEntryField: model.newEntryField,
                                              entries: model_entries)
                    }
                }
                return model

            case .delete(let id):
                var model_entries = model.entries
                model_entries.remove { $0.id == id }
                return Model(nextID: model.nextID,
                                  newEntryField: model.newEntryField,
                                  entries: model_entries)

            case .deleteAllCompleted:
                var model_entries = model.entries
                model_entries.remove { $0.completed }
                return Model(nextID: model.nextID,
                                      newEntryField: model.newEntryField,
                                      entries: model_entries)
        }
    }
}
