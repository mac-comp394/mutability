module Msg

  class Add
    def apply_to(model)
      unless model.new_entry_field.blank?
        new_model = Model.new(entries: model.entries, new_entry_field: "", next_id: model.next_id + 1)
        new_model.entries << Entry.new(
          description: model.new_entry_field,
          id: model.next_id)
        return new_model
      end
      model
    end
  end

  class UpdateNewEntryField
    def initialize(str)
      @str = str
    end

    attr_reader :str 

    def apply_to(model)
        new_model = Model.new(entries: model.entries, new_entry_field: str)
        new_model
    end
  end

  class Check
    def initialize(id, is_completed)
      @id, @is_completed = id, is_completed
    end

    attr_reader :id, :is_completed 

    def apply_to(model)
      model.entries.each do |entry|
        if entry.id == @id
          # print "------", @id, entry.description, @is_completed, "---"
          new_entry = Entry.new(id: @id, description: entry.description, completed: @is_completed)
          print "\n NEW Entry: "
          new_entry.printEntry
          print "\n"
          new_model = Model.new(entries: model.entries - [entry])
          # print " model: \n"
          # new_model.entries.each do |e|
          #  e.printEntry
          # end
          new_model.entries << new_entry
          print " New model: \n"
          new_model.entries.each do |e|
           e.printEntry
          end
          return new_model
        end
      end
      model
    end
  end

  class Delete
    def initialize(id)
      @id = id
    end

    attr_reader :id 

    def apply_to(model)
      new_model = model.entries.reject! { |e| e.id == id }
      new_model
    end
  end

  class DeleteAllCompleted
    def apply_to(model)
      new_model = model.entries.reject!(&:completed)
      new_model
    end
  end

end
