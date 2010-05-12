class StoriesController < ApplicationController
  def new
    @story = Story.new
  end

  def create
    @group = Story.new(params[:story])
    if @group.save
      respond_to do|format|
        format.js{render :layout => false}
      end
    end
  end

private
  def render_story
    respond_to do|format|
      format.js{render :action => :update, :layout => false}
    end
  end
end

