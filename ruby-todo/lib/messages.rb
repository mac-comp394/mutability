module Msg

  class Add
    def apply_to(model)
      new_entries = model.entries.dup
      unless model.new_entry_field.blank?
        new_entries << Entry.new(description: model.new_entry_field, id: model.next_id)
      end
      next_id = model.next_id.dup #even need the dup?
      next_id += 1
      new_model = Model.new(entries: new_entries, new_entry_field: "", next_id: next_id)
      return new_model
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      new_entry_field = str
      entries = model.entries
      next_id = model.next_id
      new_model = Model.new(entries: entries, new_entry_field: new_entry_field, next_id: next_id)
      return new_model
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 

    def apply_to(model)
      entries = model.entries.dup
      new_entries = []
      entries.each do |entry|
        is_completed_val = entry.completed
        if entry.id == id
          is_completed_val = is_completed
        end
        new_entry = Entry.new(id: entry.id, description: entry.description, completed: is_completed_val)
        new_entries << new_entry
      end
      new_model = Model.new(entries: new_entries, new_entry_field: model.new_entry_field, next_id: model.next_id)
      return new_model
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      entries = model.entries.dup
      entries.reject! { |e| e.id == id }
      new_model = Model.new(entries: entries, new_entry_field: model.new_entry_field, next_id: model.next_id)
      return new_model
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      entries = model.entries.dup
      entries.reject!(&:completed)
      new_model = Model.new(entries: entries, new_entry_field: model.new_entry_field, next_id: model.next_id)
      return new_model
    end
  end

end
