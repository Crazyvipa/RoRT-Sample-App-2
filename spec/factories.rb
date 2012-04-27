Factory.define :user do |user|
  user.name                   "Steven P."
  user.email                  "steve@mrskin.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@email.com"
end