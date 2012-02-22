require 'spec_helper'

describe User do
  it "should create a new instance given a valid attribute" do
    User.create!(:name => 'Example User', :email => 'asdf@asdf.com')
  end
  before(:each) do
    @attr = { :name => "Example", :email => "user@example.com" }
  end
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  it "should require an email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  it "should accept valid e-mail addresses" do
    addresses = %w[a@b.org asdf@kf.com asdf@sdaf.com]
    addresses.each do |address|
      valid_email_user = User.new( @attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid e-mail addresses" do
    addresses = %w[a@b,org as,df@kfcom asdf@sdaf.com.]
    addresses.each do |address|
      invalid_email_user = User.new( @attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duped e-mail addresses" do
    User.create!(@attr)
    user_dupe_email = User.new(@attr)
    user_dupe_email.should_not be_valid
  end
  
  it "should reject identical emails up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_dupe = User.new(@attr);
    user_with_dupe.should_not be_valid
  end
end
