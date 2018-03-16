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

end
