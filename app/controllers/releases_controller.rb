class ReleasesController < ApplicationController

  def index
    @releases = Release.previous
  end

  def create
    Story.remove_orphans
    release = Release.create(:finished_by => current_user)
    if release.valid?
      flash[:notice] = "Released! Velocity is now #{Release.velocity}"
    else
      flash[:error] = 'Cannot finish release. ' + release.errors.full_messages.join('. ')
    end
    redirect_to tasks_path
  end
end

