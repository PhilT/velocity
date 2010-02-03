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
end
