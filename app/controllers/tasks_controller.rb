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

  def edit
    @field, id = params[:id].split(/([0-9]+)/)
    @field.gsub!(/_$/, '')
    @task = Task.find(id)
    respond_to do|format|
      format.js{render :layout => false}
    end
  end

  def create
    @task = Task.create(params[:task].merge(:author => current_user))
    respond_to do|format|
      format.js{render :layout => false}
    end
  end

  def update
    @task = Task.find(params[:id])
    if !@task.started_on && params[:task][:when_id] && @task.when != @whens.find(params[:task][:when_id].to_i)
      @append_or_replace = :append
    else
      @append_or_replace = :replace
    end

    @task.update_attributes(params[:task])
    @task.assign_to!(current_user) if params[:task][:started].to_i == 1
    @task.reload
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

