ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :user_sessions
  map.resources :tasks, :collection => {:verified => :get, :sort => :put}

  map.root :controller => 'tasks'
end

