module ApplicationHelper

  def sign_in_or_out_link
    if signed_in?
      link_to 'Sign Out', destroy_user_session_path, method: :delete, class: 'nav-link'
    else
      link_to 'Sign In', user_google_oauth2_omniauth_authorize_path, method: :post, class: 'nav-link'
    end
  end

end
