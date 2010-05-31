ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :user_sessions
  map.resources :tasks, :collection => {:verified => :get, :poll => :get}, :member => {:sort => :put}
  map.resources :releases, :only => [:index, :create]
  map.resources :stories, :member => {:sort => :put}

  map.redirect '/', :controller => 'tasks'
end

