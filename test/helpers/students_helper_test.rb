class StudentsHelperTest < ActionView::TestCase

  test "#links_to_student_lists_by_last_name returns an array of hyperlinks" do
    links = links_to_student_lists_by_last_name(Date.today)
    assert(links.count, 26)
    links.each do |link|
      assert_match(/\/students\?.*last_name_starting_with=./, link)
    end
  end

end
