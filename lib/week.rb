class Week

  DAYS = [:monday, :tuesday, :wedneday, :thursday, :friday]
  # ACTIVITY_DAYS = ...see config/initializers/week.rb

  def self.to_string_array
    ACTIVITY_DAYS.map { |day| day.to_s.capitalize }
  end

  def self.to_sentence(last_word_connector)
    to_string_array.to_sentence(last_word_connector: last_word_connector)
  end

end
