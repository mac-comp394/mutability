module Engine
  def self.run(*args)
    run_with_history(*args).last
  end

  def self.run_with_history(model, messages)
    model0 = model
    messages.map do |msg|
      model0 = msg.apply_to(model0)
      model0
    end
  end
end
