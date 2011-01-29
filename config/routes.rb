Velocity::Application.routes.draw do
  match ':controller/qunit', :action => 'qunit', :as => 'qunit'

  resources :users do
    resources :tasks, :only => :index
  end
  resources :user_sessions
  resources :tasks do
    collection do
      get 'verified'
      get 'poll'
    end
    put 'sort', :on => :member
  end
  resources :releases, :only => [:index, :create]
  resources :stories do
    put 'sort', :on => :member
  end
  resources :stats, :only => :index do
    get 'graph_data', :on => :collection
  end

  root :to  => 'tasks#index'
end

