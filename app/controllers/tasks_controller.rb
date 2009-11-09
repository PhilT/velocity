class TasksController < ApplicationController
  before_filter :find_stuff

  def index
    @tasks = Task.all
    @new_tasks = [Task.new]
    @now_tasks = Task.now
    @other_tasks = Task.other
  end

  def verified
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
      @task.verified_by!(current_user) if @task.verified?
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
    @efforts = Enum.find_by_name('Effort').enum_values
  end
end

