class StoriesController < ApplicationController
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
    if @story.update_attributes(params[:story])
      redirect_to tasks_url
    else
      render :action => 'edit'
    end
  end

  def sort
    @story = Story.find(params[:id])
    release = @story.release
    reordered_stories = params['story']
    reordered_stories.each_with_index do |story_id, index|
      Story.find(story_id.to_i).move_to!(index + 1, release, current_user)
    end
#    render_story
  end
end
