class UsersHelperTest < ActionView::TestCase

  test "#link_to_users with ..." do
    skip
  end

  test "#pagination_links_by_last_name returns an array of hyperlinks" do
    links = pagination_links_by_last_name()
    assert(links.count, 26)
    links.each do |link|
      assert_match(/\/users\?.*last_name_starting_with=./, link)
    end
  end

  test "#pagination_links_by_last_name with added filter params" do
    links = pagination_links_by_last_name( {fake: 'FAKE'} )
    assert(links.count, 26)
    links.each do |link|
      assert_match(/\/users\?.*fake=FAKE&amp;last_name_starting_with=./, link)
    end
  end

end
