class StudentsHelperTest < ActionView::TestCase

  test "#link_to_week with a label and date" do
    label = 'FAKELABEL'
    date = 'FAKEDATE'
    assert_match("students?date=#{date}\"", link_to_week(label, date))
  end

  test "#link_to_week with a label, date and letter" do
    label = 'FAKELABEL'
    date = 'FAKEDATE'
    letter = 'Q'
    assert_match(
      "students?date=#{date}&amp;last_name_starting_with=#{letter}\"",
      link_to_week(label, date, {last_name_starting_with: letter})
    )
  end

  test "#link_to_week with a label, date and all" do
    label = 'FAKELABEL'
    date = 'FAKEDATE'
    assert_match(
      "students?all=true&amp;date=#{date}\"",
      link_to_week(label, date, {all: true})
    )
  end

  test "#links_to_student_lists_by_last_name returns an array of hyperlinks" do
    links = links_to_student_lists_by_last_name(Date.today)
    assert(links.count, 26)
    links.each do |link|
      assert_match(/\/students\?.*last_name_starting_with=./, link)
    end
  end

end
