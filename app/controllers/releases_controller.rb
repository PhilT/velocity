class ReleasesController < ApplicationController

  def index
    @releases = Release.previous
  end

  def finish
    release = Release.find(params[:id])
    if !release.finish!
      flash[:error] = 'Cannot finish release. Some tasks have not been verified.'
    end
    redirect_to tasks_path
  end
end

