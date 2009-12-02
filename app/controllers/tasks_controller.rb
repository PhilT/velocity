class TasksController < ApplicationController
  before_filter :find_stuff

  def index
    @tasks = Task.all
    @new_tasks = [Task.new]
    @current_tasks = Release.current.tasks
    @future_tasks = Task.future
  end

  def sort
    tasks = Task.all
    current_release = Release.current
    reordered_tasks = params['task']
    tasks.each do |task|
      i = reordered_tasks.index(task.id.to_s)
      if i
        task.position = i + 1
        task.release = params[:now] == 'true' ? current_release : nil
        task.save
      end
    end unless reordered_tasks.nil?
    render_task
  end

  def edit
    render_task(true)
  end

  def show
    render_task
  end

  def create
    params[:task][:category] = params[:bug] == '1' ? 'bug' : 'feature'
    @task = Task.create(params[:task].merge(:author => current_user))
    respond_to do|format|
      format.js{render :layout => false}
    end
  end

  def update
    @task = Task.find(params[:id])

    if params[:task].nil?
      if @task.release
        @task.next_state
        @task.assign_to!(current_user) if @task.started? && !@task.assigned
        @task.verified_by!(current_user) if @task.verified?
      else
        @task.move_to_current!
        @task.insert_at(Task.current.last.position + 1)
        @task_moved = true
      end
    else
      if params[:task][:category]
        @task.next_category!
      else
        @task.update_attributes(params[:task])
      end
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

  def render_task(editing = false)
    field, id = params[:id].split(/([0-9]+)/)
    @field = field.gsub(/_$/, '') if editing
    @task = Task.find(id)
    respond_to do|format|
      format.js{render :action => :edit, :layout => false}
    end
  end
end

