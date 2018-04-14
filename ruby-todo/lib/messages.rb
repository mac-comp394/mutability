module Msg

  class Add
    def apply_to(model)
      model_entries = model.entries.clone
      unless model.new_entry_field.blank? 
        model_entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
      end
      Model.new(
        entries: model_entries,
        new_entry_field: "",
        next_id: model.next_id + 1)
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      Model.new(
        entries: model.entries.clone,
        new_entry_field: str,
        next_id: model.next_id)
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 

    def apply_to(model)
      model_entries = model.entries.clone
      model_entries.each.with_index do |entry, index|
        if entry.id == id
          model_entries[index] = Entry.new(
            description: entry.description,
            id: entry.id,
            completed: is_completed)
        end
      end
      Model.new(
        entries: model_entries,
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      model_entries = model.entries.clone
      model_entries.reject! { |e| e.id == id }
      Model.new(
        entries: model_entries,
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      model_entries = model.entries.clone
      model_entries.reject!(&:completed)
      Model.new(
        entries: model_entries,
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
    end
  end

end
