require 'spec_helper'

describe User do
  before(:each) do
    @attr = { :name => "Example", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" }
  end
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
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
  
  describe "passwords" do
    before(:each) do
      @user = User.new(@attr)
    end
    
    it "should have a password attribute" do
      @user.should respond_to(:password)
    end
    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
    
    it "should have a salt" do
      @user.should respond_to(:salt)
    end
    describe "has_password? method" do
      it "should exist" do
        @user.should respond_to(:has_password?)
      end
      
      it "should return true if the password match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should return false if the password does not match" do
        @user.has_password?("false").should be_false
      end
    end
    describe "authenticate method" do
      it "should exist" do
        User.should respond_to(:authenticate)
      end
      it "should return nil on email/pass mismatch" do
        User.authenticate(@attr[:email], "wrongpass").should be_nil
      end
      it "should return nil for an email address with no user" do
        User.authenticate("bar@foo.com", @attr[:password]).should be_nil
      end
      it "should return the user on email/password match" do
        User.authenticate(@attr[:email],@attr[:password]).should == @user
      end
    end
  end
  describe "admin attribute" do
    before(:each) do
      @user = User.create!(@attr)
    end
    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  describe "micropost associates" do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end
    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end
    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end
    it "should destroy associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |m|
        Micropost.find_by_id(m.id).should be_nil
      end
    end
    describe "status feed" do
      it "should have a feed" do
        @user.should respond_to(:feed)
      end
      it "should include the user's microposts" do
        @user.feed.should include(@mp1)
        @user.feed.should include(@mp2)
      end
      it "should not include other user's microposts" do
        mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.should_not include(@mp3)
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

