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
    @verified_tasks = Task.verified
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

    if params[:task][:state]
      @task.next_state
      @changed_state = true
      params[:task].delete(:state)
      @task.assign_to!(current_user) if @task.started?
    end

    @task.update_attributes(params[:task])

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

