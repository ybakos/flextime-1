module UsersHelper

  def link_to_users(label, param, filter_params = {}, excludes: [], css_class: '')
    filter_params = filter_params.clone.delete_if { |k, v| excludes.include? k }
    link_to label, users_path(filter_params.merge(param)), class: css_class
  end

  def pagination_links_by_last_name(filter_params = {})
    ('A'..'Z').map do |letter|
      link_to_users(letter, {last_name_starting_with: letter}, filter_params,
        css_class: 'btn btn-sm' << (letter == filter_params[:last_name_starting_with] ? ' btn-secondary' : ' btn-outline-secondary'))
    end
  end

end