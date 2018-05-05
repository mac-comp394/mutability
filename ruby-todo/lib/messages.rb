module Msg

  class Add
    def apply_to(model)
      entriesList = model.entries.dup
      unless model.new_entry_field.blank?
        entriesList<<Entry.new(
          description: model.new_entry_field, id: model.next_id)
      end
	  newModel = Model.new(entries: entriesList, next_id: model.next_id + 1, new_entry_field: "")
      return newModel
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
      return Model.new(entries: model.entries, next_id: model.next_id, new_entry_field: str)
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 

    def apply_to(model)
	
      entriesList = []
	  
      model.entries.each do |entry|
        if entry.id == id
          entriesList<<Entry.new(id: entry.id, description: entry.description, completed: is_completed)
        else
          entriesList<<Entry.new(id: entry.id, description: entry.description, completed: entry.completed)
        end
      end
      return Model.new(entries: entriesList, next_id: model.next_id, new_entry_field: model.new_entry_field)
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      
	  entriesList = []
	  
	  model.entries.map do |e|
		if e.id != @id
		  entriesList << e
		end
	  end
      return Model.new(entries: entriesList, next_id: model.next_id, new_entry_field: model.new_entry_field)
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      entriesList = model.entries.dup
      entriesList.reject!(&:completed)
      return Model.new(entries: entriesList, next_id: model.next_id, new_entry_field: model.new_entry_field)
    end
  end

end
