class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :restrict_from_students


  def home; end
end
