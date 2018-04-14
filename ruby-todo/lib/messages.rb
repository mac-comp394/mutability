module Msg
  class Add
    def apply_to(model)
      model0 = model.dup    # Steven Roach told me about .dup
      unless model0.new_entry_field.blank?
        model0.entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
      end
      Model.new(next_id: model.next_id + 1, entries: model0.entries, new_entry_field: "")
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str

    def apply_to(model)
      Model.new(next_id: model.next_id, entries: model.entries, new_entry_field: str)
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed

    def apply_to(model)
      entries0 = []
      model.entries.each do |entry|
        if entry.id == id
          entries0 << Entry.new(id: entry.id, description: entry.description, completed: is_completed)
        else
          entries0 << entry.dup
        end
      end
      Model.new(entries: entries0, new_entry_field: model.new_entry_field, next_id: model.next_id)
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id

    def apply_to(model)
      entries1 = model.entries.dup
      entries1.reject! { |e| e.id == id }
      Model.new(entries: entries1, new_entry_field: model.new_entry_field, next_id: model.next_id)
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      entries2 = model.entries.dup
      entries2.reject!(&:completed)
      Model.new(entries: entries2, new_entry_field: model.new_entry_field, next_id: model.next_id)
    end
  end

end
