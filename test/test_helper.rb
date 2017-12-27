require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all

  def defines_before_filter?(controller_class, method_symbol)
    controller_class._process_action_callbacks.map {|c| c.filter if c.kind == :before}.compact.include? method_symbol
  end

end
