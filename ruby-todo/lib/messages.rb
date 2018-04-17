module Msg

  class Add
    def apply_to(model)
      entries = [] + model.entries
      new_model = Model.new(entries: entries, new_entry_field: "", next_id: model.next_id + 1)
      unless model.new_entry_field.blank?
        entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
      end
      return new_model
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
        new_model = Model.new(entries: [] + model.entries, new_entry_field: str, next_id: model.next_id)
        new_model
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 

    def apply_to(model)
      model.entries.each do |entry|
        if entry.id == id
          new_entry = Entry.new(id: id, description: entry.description, completed: is_completed)
          model.entries[model.entries.index(entry)] = new_entry
          new_model = Model.new(entries: [] + model.entries, new_entry_field: model.new_entry_field, next_id: model.next_id)
          return new_model
        end
      end
      model
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      new_entries = []
      model.entries.map do |e|
        if e.id != @id
          new_entries << e
        end
      end
      new_model = Model.new(entries: new_entries, new_entry_field: model.new_entry_field, next_id: model.next_id)
      new_model
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      new_entries = []
      model.entries.map do |e|
        if ! e.completed 
          new_entries << e
        end
      end
      new_model = Model.new(entries: new_entries, new_entry_field: model.new_entry_field, next_id: model.next_id)
      new_model
    end
  end

end
