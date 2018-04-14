module Msg

  class Add
    def apply_to(model)
      newEntries = model.entries.clone

      unless model.new_entry_field.blank?
        newEntries << Entry.new(
         description: model.new_entry_field,
         id: model.next_id)
      end
      
      newNextId = model.next_id + 1
      newModel = Model.new(next_id: newNextId, new_entry_field: "", entries: newEntries)
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      newModel = Model.new(entries: model.entries.clone, next_id: model.next_id, new_entry_field: str)
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 

    def apply_to(model)
      newEntries = model.entries.map do |entry|
          newEntry = entry
            if entry.id == id
                newEntry = Entry.new(description: entry.description, id: entry.id, completed: is_completed)
            end
            newEntry
      end
      
      newModel = Model.new(next_id: model.next_id, new_entry_field: model.new_entry_field, entries: newEntries)
      
      newModel
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
        
        newModel = Model.new(next_id: model.next_id, new_entry_field: model.new_entry_field, entries: model.entries.clone)

        newModel.entries.reject! { |e| e.id == id }
        newModel
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
        
        newEntries = model.entries.clone
        newEntries.reject!(&:completed)
        
        newModel = Model.new(next_id: model.next_id, new_entry_field: model.new_entry_field, entries: newEntries)
    end
  end
end
