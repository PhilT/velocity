use Sass::Plugin::Rack
Sass::Plugin.options[:template_location] = 'app/assets/stylesheets'

run Renee {
  path('projects') do
    get do
      @projects = Project.all
      render! "projects/index", :layout => 'layout'
    end

    post do
      Project.create(request.params)
      redirect! "/projects"
    end

    path('new') do
      get { render! 'projects/new', :layout => 'layout' }
    end
  end
}

