class StoriesController < ApplicationController
  before_filter :find_stuff, :only => :update

  def new
    @story = Story.new
  end

  def create
    @story = Story.new(params[:story])
    if @story.save
      redirect_to tasks_url
    else
      render :action => 'new'
    end
  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    @story = Story.find(params[:id])
    if params[:story].nil?
      @moved = true
      @story.move_to!((Story.current.last.position + 1 rescue 1), current_user)
      render_story
    else
      if @story.update_attributes(params[:story])
        redirect_to tasks_url
      else
        render :action => 'edit'
      end
    end
  end

  def sort
    @story = Story.find(params[:id])
    release = @story.release
    reordered_stories = params['story']
    reordered_stories.each_with_index do |story_id, index|
      Story.find(story_id.to_i).move_to!(index + 1, current_user)
    end
    render :nothing => true
  end

private
  def render_story
    respond_to do|format|
      format.js{render :action => :update, :layout => false}
    end
  end
end
