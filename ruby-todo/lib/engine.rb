module Engine
  def self.run(*args)
    run_with_history(*args).last
  end

  def self.run_with_history(model, messages)
    messages.map do |msg|
      model = msg.apply_to(model)

    end

    # [msg1, msg2, msg3]
    # [model with msg1, model with msg2, model with msg3]
    # [model with msg1, model with msg1, msg2, model with msg1, msg2, msg3]

  end
end
