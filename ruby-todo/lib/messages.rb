module Msg

  class Add
    def apply_to(model)
	  new_mod_entries = model.entries.dup
      unless model.new_entry_field.blank?
        new_mod_entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
      end
	  Model.new(entries: new_mod_entries, new_entry_field: "", next_id: model.next_id + 1)
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      Model.new(entries: model.entries, new_entry_field: str, next_id: model.next_id)
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 
	
    def apply_to(model)
	  new_mod_entries = []
      model.entries.each do |entry|
        if entry.id == id
		  new_mod_entries << Entry.new(description: entry.description,
									   id: entry.id, 
									   completed: is_completed)
		else
          new_mod_entries << entry		
        end
      end
	  Model.new(entries: new_mod_entries, new_entry_field: model.new_entry_field, next_id: model.next_id)
    end	
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      new_mod_entries = model.entries.reject { |e| e.id == id }
	  Model.new(entries: new_mod_entries, new_entry_field: model.new_entry_field, next_id: model.next_id)
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      new_mod_entries = model.entries.reject(&:completed)
	  Model.new(entries: new_mod_entries, new_entry_field: model.new_entry_field, next_id: model.next_id)
    end
  end

end
