# Sequences (Alphabetical order)

Factory.sequence :email do |n|
  "user#{n}@example.com"
end


# Factories (Alphabetical order)

Factory.define :customer, :class => User do |f|
  f.name 'Customer'
  f.email Factory.next :email
  f.access_level {EnumValue.find_by_value('Customer')}
end

Factory.define :developer, :class => User do |f|
  f.name 'Developer'
  f.email Factory.next :email
  f.access_level {EnumValue.find_by_value('Developer')}
end

Factory.define :task do |f|
  f.name 'This is a task'
  f.detail 'Here is some detail about this task'
  f.category {EnumValue.find_by_value('Feature')}
  f.association :author, :factory => :customer
  f.when {EnumValue.find_by_value('Now')}
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
