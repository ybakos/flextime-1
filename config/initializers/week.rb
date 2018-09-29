raise "ACTIVITY_DAYS not set." if ENV['ACTIVITY_DAYS'].nil?

Week.const_set('ACTIVITY_DAYS', ENV['ACTIVITY_DAYS'].split.map(&:to_sym))

Week::ACTIVITY_DAYS.each do |day|
  unless [:monday, :tuesday, :wednesday, :thursday, :friday].include?(day)
    raise "ACTIVITY_DAYS contains invalid day"
  end
end
