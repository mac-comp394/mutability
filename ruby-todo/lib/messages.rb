module Msg

  class Add
    def apply_to(model)
      new_entries = model.entries
      unless model.new_entry_field.blank? 
        new_entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
      end
      new_model = Model.new(
        entries: new_entries,
        new_entry_field: "",
        next_id: model.next_id + 1)
      new_model
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      new_model = Model.new(
        entries: model.entries,
        new_entry_field: str)
      new_model
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 

    def apply_to(model)
      model_entries = model.entries
      model_entries.each do |entry|
        if entry.id == id
          entry.completed = is_completed
        end
      end
      new_model = Model.new(
        entries: model_entries,
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
      new_model
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      old_entries = model.entries
      new_model = Model.new(
        entries: old_entries.reject! { |e| e.id == id },
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
      new_model
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      old_entries = model.entries
      new_model = Model.new(
        entries: old_entries.reject!(&:completed),
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
      new_model
    end
  end

end
