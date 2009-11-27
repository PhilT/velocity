class ReleasesController < ApplicationController

  def index
    @releases = Release.previous
  end

  def finish
    release = Release.find(params[:id])
    release.finish!
    redirect_to tasks_path
  end
end

