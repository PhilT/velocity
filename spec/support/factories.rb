# Sequences (Alphabetical order)

Factory.sequence :email do |n|
  "user#{n}@example.com"
end


# Factories (Alphabetical order)

Factory.define :customer, :class => User do |u|
  u.name 'Customer'
  u.email Factory.next :email
  u.access_level {EnumValue.find_by_value('Customer')}
end

Factory.define :developer, :class => User do |u|
  u.name 'Developer'
  u.email Factory.next :email
  u.access_level {EnumValue.find_by_value('Developer')}
end

## This will copy the attributes from the parent factory to the current one with an ability to override them.
#Factory.define :super_user, :parent => :user do |u|
#  u.super_user true
#end

## Associations
#Factory.define :post do |p|
#  p.author {|author| author.association(:user, :last_name => 'Writely') }
#end

## Or in short form
#Factory.define :post do |p|
#  p.association :author, :factory => :user
#end
