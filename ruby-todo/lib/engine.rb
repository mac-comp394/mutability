module Engine
  def self.run(*args)
    run_with_history(*args).last
  end

  def self.run_with_history(model, messages)
  	model_history = []
    new_model = model
    messages.map do |msg|
      new_model = msg.apply_to(new_model)
      model_history << new_model
    end
    model_history
  end
end
