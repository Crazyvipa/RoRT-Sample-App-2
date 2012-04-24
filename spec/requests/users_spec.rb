require 'spec_helper'

describe "Users" do
  describe "signup" do
    describe "failure" do
      it "should not create a new user" do
        lambda do
          visit signup_path
          fill_in "Name",                 :with => ""
          fill_in "Email",                :with => ""
          fill_in "Password",             :with => ""
          fill_in "Confirmation",         :with => ""
          click_button

          response.should render_template('users/new')
          response.should have_selector('div#error_explanation')
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      it "should create a new user" do
        lambda do
          visit signup_path
          fill_in "Name",                 :with => "Example"
          fill_in "Email",                :with => "info@infoo.com"
          fill_in "Password",             :with => "foobars"
          fill_in "Confirmation",         :with => "foobars"
          click_button

          response.should render_template('users/show')
          response.should have_selector('div.flash.success')
        end.should change(User, :count).by(1)
      end
    end
  end
end
