module Engine
  def self.run(*args)
    run_with_history(*args).last
  end

  def self.run_with_history(model, messages)
  	model_list = [model]
  	new_model = model_list.last
    messages.each do |msg|
      new_model = msg.apply_to(new_model)
      if new_model != model_list.last
      	model_list.append(new_model)
      end
    end
    
    return model_list
  end
end
