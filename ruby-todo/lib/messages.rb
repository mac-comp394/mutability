module Msg

  class Add
    def apply_to(model)
      newEntries = model.entries.clone

      unless model.new_entry_field.blank?
        newEntries << Entry.new(description: model.new_entry_field,id: model.next_id)
      end

      Model.new(new_entry_field: "", entries: newEntries, next_id: model.next_id + 1 )
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      Model.new(new_entry_field: str, entries: model.entries.clone, next_id: model.next_id )
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 
    def apply_to(model)
      # [1,2,3,4].map do |digit|
      #   digit + 1
      # end == [2,3,4,5]

      Model.new(new_entry_field: model.new_entry_field, entries: model.entries.clone, next_id: model.next_id, entries: model.entries.clone.map do |entry|
        if entry.id == id
          entry = Entry.new(id: id, description: entry.description, completed: is_completed)
        end
        entry
      end
      )
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 
    def apply_to(model)
      Model.new(new_entry_field: model.new_entry_field, next_id: model.next_id, entries: model.entries.clone.reject! { |e| e.id == id }
        )
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      Model.new(new_entry_field: model.new_entry_field, next_id: model.next_id, entries: model.entries.clone.reject!(&:completed))
    end
  end

end
