require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(
                          :name => 'Steven P.',
                          :email => "example@rails.com",
                          :password => "foobar",
                          :password_confirmation => "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "echo-#{n+1}@echo.org"
      password = "password"
      User.create!(:name => name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password)
    end
    
    User.all(:limit => 6).each do |u|
      50.times do
        u.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
end