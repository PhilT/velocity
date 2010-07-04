class StatsController < ApplicationController
  def index
  end

  def graph_data
    @releases = Release.all(:order => :created_at)
  end
end
