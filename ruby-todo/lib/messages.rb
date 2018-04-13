module Msg

  class Add
    def apply_to(model)
      # copy model.entries to a new array of entries
      new_entries = []
      model.entries.each do |entry|
        new_entries << Entry.new(
          id: entry.id, 
          description: entry.description, 
          completed: entry.completed)
      end

      unless model.new_entry_field.blank?
        new_entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
      end

      Model.new(
        entries: new_entries, 
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
      # copy model.entries to a new array of entries
      new_entries = []
      model.entries.each do |entry|
        new_entries << Entry.new(
          id: entry.id, 
          description: entry.description, 
          completed: entry.completed)
      end

      Model.new(
        entries: new_entries,
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
      new_entries = []
      model.entries.each do |entry|
        new_complete_status = (entry.id == id) ? is_completed : entry.completed
        new_entries << Entry.new(
          id: entry.id, 
          description: entry.description, 
          completed: new_complete_status) 
      end
      Model.new(
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
      new_entries = []
      model.entries.each do |entry|
        new_entries << Entry.new(
          id: entry.id, 
          description: entry.description, 
          completed: entry.completed)
      end
      new_entries.reject! { |e| e.id == id }
      Model.new(
        entries: new_entries,
        new_entry_field: model.new_entry_field, 
        next_id: model.next_id)
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      new_entries = []
      model.entries.each do |entry|
        new_entries << Entry.new(
          id: entry.id, 
          description: entry.description, 
          completed: entry.completed)
      end
      new_entries.reject!(&:completed)
      Model.new(
        entries: new_entries,
        new_entry_field: model.new_entry_field, 
        next_id: model.next_id)
    end
  end

end
