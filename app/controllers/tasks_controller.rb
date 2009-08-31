class TasksController < ApplicationController
  def index
    @tasks = Task.all
    @active_tasks = Task.active
    @new_tasks = [Task.new]
    @started_tasks = Task.started
    @now_tasks = Task.now
    @soon_tasks = Task.soon
    @later_tasks = Task.later
    @completed_tasks = Task.completed
    @developers = User.developers
    @categories = Enum.find_by_name('Category').enum_values
    @whens = Enum.find_by_name('When').enum_values
    @efforts = Enum.find_by_name('Effort').enum_values
  end

  def create
    @task = Task.create!(params[:task])
    respond_to do|format|
      format.js{render :layout => false}
    end
  end
end

