class StoriesController < ApplicationController
  def create
    @group = Story.new(params[:story])
    if @group.save
      respond_to do|format|
        format.js{render :layout => false}
      end
    end
  end
end

