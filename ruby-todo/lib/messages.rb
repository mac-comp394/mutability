module Msg

  class Add
    def apply_to(model)

      new_entries = model.entries.dup
      unless model.new_entry_field.blank?
        # model.entries << Entry.new(
        #   description: model.new_entry_field,
        #   id: model.next_id)
        new_entry = Entry.new(
          description: model.new_entry_field,
          id: model.next_id)

        new_entries << new_entry
      end
      # model.next_id += 1
      # model.new_entry_field = ""
      # puts "ADD:" + new_entries.to_s
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
      # model.new_entry_field = str

      Model.new(
        entries: model.entries.dup, # dup or not
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
      new_model = model.dup
      new_model.entries.each do |entry|
        if entry.id == id
          entry.completed = is_completed
        end
      end
      new_model
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      new_model = model.dup     
      new_model.entries.reject! { |e| e.id == id }
      # puts "DELETE", model.inspect, new_model.inspect
      new_model
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      new_model = model.dup     
      new_model.entries.reject!(&:completed)
      new_model
      # model.dup.entries.reject!(&:completed)
    end
  end

end
