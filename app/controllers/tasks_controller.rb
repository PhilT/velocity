class TasksController < ApplicationController
  before_filter :find_stuff

  def index
    @tasks = Task.all
    @new_tasks = [Task.new]
    @started_tasks = Task.started
    @now_tasks = Task.now
    @soon_tasks = Task.soon
    @later_tasks = Task.later
    @completed_tasks = Task.completed
  end

  def create
    @task = Task.create(params[:task].merge(:author => current_user))
    respond_to do|format|
      format.js{render :layout => false}
    end
  end

  def update
    @task = Task.find(params[:id])
    logger.info params.inspect
    @task.update_attributes(params[:task])
    respond_to do|format|
      format.js{render :layout => false}
    end
  end

  private
  def find_stuff
    @active_tasks = Task.active
    @developers = User.developers
    @categories = Enum.find_by_name('Category').enum_values
    @whens = Enum.find_by_name('When').enum_values
    @efforts = Enum.find_by_name('Effort').enum_values
  end
end

