ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def assert_presence(model, field)
    model.valid?
    assert_not_nil model.errors[field], "#{field} can't be blank"
  end
end
