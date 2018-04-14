module Engine
  def self.run(*args)
    run_with_history(*args).last
  end

  def self.run_with_history(model, messages)
    messages.map do |msg|
      model_copy = model.clone
      msg.apply_to(model_copy)
      model_copy
    end
  end
end
