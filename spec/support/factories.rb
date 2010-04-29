# Sequences (Alphabetical order)

Factory.sequence :email do |n|
  "user#{n}@example.com"
end


# Factories (Alphabetical order)

Factory.define :customer, :class => User do |f|
  f.name 'Customer'
  f.email {Factory.next :email}
  f.password 'password'
  f.password_confirmation 'password'
  f.developer false
end

Factory.define :developer, :class => User do |f|
  f.name 'Developer'
  f.email {Factory.next :email}
  f.password 'password'
  f.password_confirmation 'password'
  f.developer true
end

Factory.define :release do |f|
end

Factory.define :story do |f|
 f.name 'Story'
end

Factory.define :task do |f|
  f.name 'This is a task'
  f.association :author, :factory => :customer
  f.state 'pending'
  f.category 'feature'
end

Factory.define :future_task, :class => Task do |f|
  f.name 'This is a task'
  f.association :author, :factory => :customer
  f.release nil
  f.state 'pending'
end

