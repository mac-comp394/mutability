module Engine
  def self.run(*args)
    run_with_history(*args).last
  end

  def self.run_with_history(model, messages)
    # Messages are things like update, add, delete, check, delete all completed etc
    # But model is composed of previous entries, an empty entry, and the next entry ID. While entires are ID, Description, Checked
    messages.map do |msg|
      model = msg.apply_to(model)
    end
  end
end
