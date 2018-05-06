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
    	var lastModel = model
        return messages.map { message in
          lastModel = message.apply(to: lastModel)
          return lastModel
        }
    }
}


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

    func apply(to oldModel: Model) -> Model {
    	var model = oldModel
        switch(self) {
            case .add:
                if !model.newEntryField.isBlank() {
                    model.entries.append(Entry(id: model.nextID, description: model.newEntryField))
                }
                model.nextID += 1
                model.newEntryField = ""

            case .updateNewEntryField(let str):
                model.newEntryField = str

            case .check(let id, let isCompleted):
            	var newEntries: [Entry] = []
                for entry in model.entries {
                    if(entry.id == id) {
                    	var newEntry = entry
                        newEntry.completed = isCompleted
                        newEntries.append(newEntry)
                    } else{
                    	newEntries.append(entry)
                    }
                }
                model.entries = newEntries

            case .delete(let id):
                model.entries.remove { $0.id == id }

            case .deleteAllCompleted:
                model.entries.remove { $0.completed }
        }
        return model
    }
}


struct Model {
    var entries: [Entry]
    var newEntryField: String
    var nextID: Int

    init(nextID: Int? = nil, newEntryField: String = "", entries: [Entry] = []) {
        self.entries = entries
        self.newEntryField = newEntryField
        self.nextID = nextID ??
            (entries.map { $0.id }.max() ?? -1) + 1
    }
}

struct Entry {
    var id: Int
    var description: String
    var completed: Bool

    init(id: Int, description: String, completed: Bool = false) {
        self.id = id
        self.description = description
        self.completed = completed
    }
}

extension Model: Equatable {
    static func == (lhs: Model, rhs: Model) -> Bool {
        return lhs.newEntryField == rhs.newEntryField
            && lhs.nextID == rhs.nextID
            && lhs.entries == rhs.entries
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.id == rhs.id
            && lhs.description == rhs.description
            && lhs.completed == rhs.completed
    }
}


//
//  Utils.swift
//  Todo
//
//  Created by Paul on 2018/4/4.
//

import Foundation

extension CharacterSet {
    static let nonWhitespace = CharacterSet.whitespacesAndNewlines.inverted
}

extension String {
    func isBlank() -> Bool {
        return rangeOfCharacter(from: .nonWhitespace) == nil
    }
}

extension Array {
    mutating func remove(where predicate: (Element) -> Bool) {
        var dst = startIndex
        for src in indices {
            let elem = self[src]
            if !predicate(elem) {
                self[dst] = elem
                dst += 1
            }
        }
        removeSubrange(dst ..< endIndex)
    }
}



class TodoTests {
    var model = Model(
        entries: [
            Entry(id: 10, description: "Pat head"),
            Entry(id: 11, description: "Rub tummy")
        ]
    )

    func testModelStartsEmpty() {
        XCTAssertEqual_B(true, Model().entries.isEmpty)
        XCTAssertEqual_I(0, Model().nextID)
    }

     func testUpdateNewEntryField() {
         let newModel = Engine.run(on: model, applying: [
             .updateNewEntryField("typing away")
         ])
         XCTAssertEqual_S("typing away", newModel.newEntryField)
     }

     func testAdd() {
         let newModel = Engine.run(on: model, applying: [
             .updateNewEntryField("hop on one foot"),
             .add
         ])
         XCTAssertEqual_I(3, newModel.entries.count)
         let newEntry = newModel.entries.last!
         XCTAssertEqual_I(12, newEntry.id)
         XCTAssertEqual_S("hop on one foot", newEntry.description)
         XCTAssertEqual_B(false, newEntry.completed)
     }

     func testAddDoesNothingIfFieldIsBlank() {
         let newModel = Engine.run(on: model, applying: [
             .updateNewEntryField(""),
             .add,
             .updateNewEntryField("     "),
             .add
         ])

         XCTAssertEqual_I(2, newModel.entries.count)
     }

     func testCheck() {
         let newModel = Engine.run(on: model, applying: [
             .check(10, true),
         ])
         XCTAssertEqual_B(true,  newModel.entries[0].completed)
         XCTAssertEqual_B(false, newModel.entries[1].completed)
     }

     func testUncheck() {
         let newModel = Engine.run(on: model, applying: [
             .check(10, true),
             .check(11, true),
             .check(10, false),
         ])
         XCTAssertEqual_B(false, newModel.entries[0].completed)
         XCTAssertEqual_B(true,  newModel.entries[1].completed)
     }

     func testDelete() {
         let newModel = Engine.run(on: model, applying: [
             .delete(10)
         ])
         XCTAssertEqual_A([11], newModel.entries.map { $0.id })
     }

     func testDeleteAllCompleted() {
         let newModel = Engine.run(on: model, applying: [
             .check(10, true),
             .deleteAllCompleted
         ])
         XCTAssertEqual_A([11], newModel.entries.map { $0.id })
     }

//*
     func testTimeTravel() {
        let actualHistory = Engine.runWithHistory(on: Model(), applying: [
             .updateNewEntryField("go forward in time"),
             .add,
             .add,  // no effect
             .updateNewEntryField("delete this item"),
             .add,
             .delete(2),
             .updateNewEntryField("go in time"),
             .updateNewEntryField("go backward in time"),
             .add,
             .check(0, true),
             .check(3, true),
             .check(3, false),
             .deleteAllCompleted
         ])

         let expectedHistory = [
             Model(nextID: 0, newEntryField: "go forward in time", entries: []),
             Model(nextID: 1, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 2, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 2, newEntryField: "delete this item", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 3, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false),
                 Entry(id: 2, description: "delete this item", completed: false)
             ]),
             Model(nextID: 3, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 3, newEntryField: "go in time", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 3, newEntryField: "go backward in time", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: false),
                 Entry(id: 3, description: "go backward in time", completed: false)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: true),
                 Entry(id: 3, description: "go backward in time", completed: false)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: true),
                 Entry(id: 3, description: "go backward in time", completed: true)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 0, description: "go forward in time", completed: true),
                 Entry(id: 3, description: "go backward in time", completed: false)
             ]),
             Model(nextID: 4, newEntryField: "", entries: [
                 Entry(id: 3, description: "go backward in time", completed: false)
             ]),
         ]

         XCTAssertEqual_I(expectedHistory.count, actualHistory.count)
         for (index, (expected, actual)) in zip(expectedHistory, actualHistory).enumerated() {
             XCTAssertEqual_mess(expected, actual, "History mismatch at step \(index)")
         }
    }
//*/


    private func XCTAssertEqual_I(_ expectedValue: Int, _ value: Int){
        if expectedValue != value{
            print("\(expectedValue) != \(value)")
        }
    }
    private func XCTAssertEqual_B(_ expectedValue: Bool, _ value: Bool){
        if expectedValue != value{
            print("\(expectedValue) != \(value)")
        }
    }
    private func XCTAssertEqual_S(_ expectedValue: String, _ value: String){
        if expectedValue != value{
            print("\(expectedValue) != \(value)")
        }
    }
    private func XCTAssertEqual_A(_ expectedValue: [Int], _ value: [Int]){
        if expectedValue != value{
            print("\(expectedValue) != \(value)")
        }
    }
    private func XCTAssertEqual_mess(_ expectedValue: Model, _ value: Model, _ message: String){
        if expectedValue != value{
            print(message)
        }
    }

}



var tests = TodoTests()
tests.testModelStartsEmpty()

tests = TodoTests()
tests.testUpdateNewEntryField()

tests = TodoTests()
tests.testAdd()

tests = TodoTests()
tests.testAddDoesNothingIfFieldIsBlank()

tests = TodoTests()
tests.testCheck()

tests = TodoTests()
tests.testUncheck()

tests = TodoTests()
tests.testDelete()

tests = TodoTests()
tests.testDeleteAllCompleted()

tests = TodoTests()
tests.testTimeTravel()

