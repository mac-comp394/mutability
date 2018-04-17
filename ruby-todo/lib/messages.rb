module Msg

  class Add
    def apply_to(model)
      new_entries = model.entries.dup
      new_id = model.next_id
      unless model.new_entry_field.blank?
        new_entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
      end
      return Model.new(
            entries: new_entries,
            new_entry_field: "",
            next_id: new_id += 1)
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      return Model.new(
        entries: model.entries.dup,
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
      new_entries = model.entries.dup
      new_entries.each do |entry|
        if entry.id == id
          updated_entry = Entry.new(
            description: entry.description,
            completed: is_completed,
            id: entry.id)
          new_entries[new_entries.index(entry)] = updated_entry
        end
      end
      return Model.new(
        entries: new_entries,
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
      new_entries = model.entries.dup
      new_entries.reject! { |e| e.id == id }
      return Model.new(
        entries: new_entries,
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      new_entries = model.entries.dup
      new_entries.reject!(&:completed)
      return Model.new(
        entries: new_entries,
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
    end
  end

end
