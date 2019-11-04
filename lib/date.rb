class Date

  def day_name
    strftime("%A")
  end

  def tuesday
    monday + 1
  end

  def wednesday
    monday + 2
  end

  def thursday
    monday + 3
  end

  def friday
    monday + 4
  end

  def current_week?
    cweek == Date.today.cweek
  end

  def less_than_a_week_away?
    (self - Date.today).to_i <= 7
  end

  def registration_cutoff_datetime(hour_of_day)
    t = Time.parse(hour_of_day)
    DateTime.new(year, month, day, t.hour, t.min, t.sec).utc
  end

end
