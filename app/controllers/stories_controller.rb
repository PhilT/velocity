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
    stories = Story.all
    current_release = Release.current
    reordered_stories = params['story']
    stories.each do |story|
      i = reordered_stories.index(story.id.to_s)
      story.move_to!(i + 1, params[:now] == 'true' ? current_release : nil, current_user) if i
    end unless reordered_stories.nil?
#    render_story
  end
end
