class Model
  def initialize(entries: [], new_entry_field: "", next_id: nil)
    @entries, @new_entry_field = entries, new_entry_field
    @next_id = next_id ||
      (entries.lazy.map(&:id).max || -1) + 1
  end

  attr_reader :entries, :new_entry_field, :next_id

  def ==(other)
    !other.nil? &&
      self.new_entry_field == other.new_entry_field &&
      self.next_id == other.next_id &&
      self.entries == other.entries
  end

  def with(entries: nil, new_entry_field: nil, next_id: nil)
    entries = entries || self.entries
    new_entry_field = new_entry_field || self.new_entry_field
    next_id = next_id || self.next_id
    Model.new(entries: entries, new_entry_field: new_entry_field, next_id: next_id)
  end

end

class Entry
  def initialize(id:, description:, completed: false)
    @description, @id, @completed = description, id, completed
  end

  attr_reader :description, :completed, :id

  def ==(other)
    !other.nil? &&
      self.id == other.id &&
      self.description == other.description &&
      self.completed == other.completed
  end

  def with(id: nil, description: nil, completed: nil)
    id = id || self.id
    description = description || self.description
    if completed.nil? 
        completed = self.completed
    end
    Entry.new(id: id, description: description, completed: completed)
  end
end
