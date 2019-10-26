class TeachersHelperTest < ActionView::TestCase

  test "#day_name_table_headers returns th tags with capitalized days of week" do
    assert_equal "<th>Fake</th>", day_name_table_headers(['fake'])
    assert_equal "<th>Fake</th>\n<th>Fake 2</th>\n<th>Fake 3</th>", day_name_table_headers(['fake', 'fake 2', 'fake 3'])
  end
end
