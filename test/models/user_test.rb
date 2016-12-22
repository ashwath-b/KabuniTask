require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = User.new(name: 'John', email: '')
  end

  should validate_presence_of(:email)
  should validate_presence_of(:password)
  should validate_presence_of(:password_salt)
  should validate_presence_of(:password_hash)

  test "should not save user without email, password, password_salt, password_hash, auth_token" do
    assert_not @user.valid?
    assert_presence(@user, :auth_token)
  end

  test "should not save duplicate email" do
    user = users(:one)
    u = User.new(:email => user.email)
    assert_not u.valid?
    assert_match /has already been taken/, u.errors[:email].join
  end

  test "should authenticate user with email and password" do
    @user = users(:one)
    assert_equal @user, User.authenticate(@user.email, 12345678)
  end

end
