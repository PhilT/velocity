class ReleasesController < ApplicationController

  def index
    @releases = Release.previous
  end

  def finish
    release = Release.create!
    if !release.finish!(current_user)
      flash[:error] = 'Cannot finish release. Some tasks have not been verified.'
    end
    redirect_to tasks_path
  end
end

