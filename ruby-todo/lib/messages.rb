module Msg

  class Add
    def apply_to(model)
      list = model.entries.dup
      unless model.new_entry_field.blank?
        list<<Entry.new(
          description: model.new_entry_field, id: model.next_id)
      end
      #model.next_id += 1
#      model.new_entry_field = ""
      tempid = model.next_id+1
      return Model.new(next_id: tempid, new_entry_field: "", entries: list)
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      return Model.new(next_id: model.next_id, new_entry_field: str, entries: model.entries)
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 

    def apply_to(model)
      list = []
      model.entries.each do |entry|
        if entry.id == id
          list<<Entry.new(description: entry.description, id: entry.id, completed: is_completed)
        else
          list<<Entry.new(description: entry.description, id: entry.id, completed: entry.completed)
 
        end
      end
      return Model.new(next_id: model.next_id, new_entry_field: model.new_entry_field, entries: list)
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      list = model.entries.dup
      list.reject!{ |e| e.id == id }
      return Model.new(next_id: model.next_id, new_entry_field: model.new_entry_field, entries: list)
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      list = model.entries.dup
      list.reject!(&:completed)
      return Model.new(next_id: model.next_id, new_entry_field: model.new_entry_field, entries: list)
    end
  end

end
