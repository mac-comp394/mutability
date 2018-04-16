module Msg

  class Add
    def apply_to(model)

      entries = model.entries.dup

      unless model.new_entry_field.blank?
        entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
      end

      new_model = Model.new(
        entries: entries,
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
        new_entry_field: str,
        next_id: model.next_id)
      new_model
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
        if entry.id == id
          new_entries.push(Entry.new(
            id: entry.id,
            description: entry.description, 
            completed: is_completed))
        else
          new_entries.push(entry)
        end
      end

      new_model = Model.new(
        entries: new_entries,
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
      entries = model.entries.dup

      entries.reject! { |e| e.id == id }

      new_model = Model.new(
        entries: entries,
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
      new_model
    end
  end

  class DeleteAllCompleted
    def apply_to(model)

      entries = model.entries.dup

      entries.reject!(&:completed)

      new_model = Model.new(
        entries: entries,
        new_entry_field: model.new_entry_field,
        next_id: model.next_id)
      new_model
    end
  end

end
