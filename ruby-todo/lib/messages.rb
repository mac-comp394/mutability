module Msg
  
class Add
  def apply_to(model)
    entries = model.entries.clone
    next_id = model.next_id
    new_entry_field = model.new_entry_field
    
    unless model.new_entry_field.blank?
      entries << Entry.new(
        description: new_entry_field,
        id: next_id)
    end
    next_id += 1
    new_entry_field = ""
    Model.new(entries: entries, new_entry_field: new_entry_field, next_id: next_id)
  end
end
    
    class UpdateNewEntryField
      def initialize(str)
        @str = str
      end
      
      attr_reader :str 
      
      def apply_to(model)
        model.with(new_entry_field: str)
      end
    end
    
    class Check
      def initialize(id, is_completed)
        @id, @is_completed = id, is_completed
      end
      
      attr_reader :id, :is_completed 
      
      def apply_to(model)
        entries = model.entries.clone
        entries = entries.map do |entry|
          if entry.id == id
            entry = entry.with(completed: is_completed)
            
          end
          entry
        end
        model.with(entries: entries)
      end
    end
    
    class Delete
      def initialize(id)
        @id = id
      end
      
      attr_reader :id 
      
      def apply_to(model)
        entries = model.entries.clone
        entries.reject! { |e| e.id == id }
        model.with(entries: entries)
      end
    end
    
    class DeleteAllCompleted
      def apply_to(model)
        entries = model.entries.clone
        entries.reject!(&:completed)
        model.with(entries:entries)
      end
    end
    
  end
  