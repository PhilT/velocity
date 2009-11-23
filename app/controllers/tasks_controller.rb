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

  def sort
    tasks = Task.all
    tasks.each do |task|
      i = params['task'].index(task.id.to_s)
      if i
        task.position = i + 1
        task.now = params['now']
        task.save
      end
    end
    render :nothing => true
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

    if params[:task].nil?
      if !@task.now?
        @task.update_attribute(:now, true)
        @task.insert_at(Task.now.last.position + 1)
        @task_moved = true
      else
        @task.next_state
        @task.assign_to!(current_user) if @task.started? && !@task.assigned
        @task.verified_by!(current_user) if @task.verified?
      end
    else
      @task.update_attributes(params[:task])
    end

    @task.reload

    respond_to do|format|
      format.js{render :layout => false}
    end
  end

  private
  def find_stuff
    @developers = User.developers
  end
end

