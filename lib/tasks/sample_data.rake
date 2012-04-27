require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => 'Steven P.', :email => "example@rails.com", :password => "foobar", :password_confirmation => "foobar")
    99.times do |n|
      name = Faker::Name.name
      email = "echo-#{n+1}@echo.org"
      password = "password"
      User.create!(:name => name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password)
    end
  end
end