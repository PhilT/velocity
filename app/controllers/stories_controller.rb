class StoriesController < ApplicationController
  def create
    @group = Story.find_or_initialize_by_name(params[:story][:name])
    @group.activate
    if @group.save
      respond_to do|format|
        format.js{render :layout => false}
      end
    end
  end
end

