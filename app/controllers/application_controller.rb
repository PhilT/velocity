# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :login_required

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  helper_method :current_user

  def find_stuff
    @current_stories = Release.current.stories
    @current_tasks = Release.current.tasks.without_story
    @future_stories = Story.future.all(:order => :position)
    @stories = @current_stories + @future_stories
    @future_tasks = Task.future.without_story
    @developers = User.developers
    @non_developers = User.non_developers
  end

  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    @current_user = current_user_session && current_user_session.user
  end

  def login_required
    redirect_to new_user_session_url unless current_user
  end
end

