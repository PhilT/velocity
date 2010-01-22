class TasksController < ApplicationController
  before_filter :find_stuff

  def index
    @new_tasks = [Task.new]
  end

  def sort
    tasks = Task.all
    current_release = Release.current
    reordered_tasks = params['task']
    tasks.each do |task|
      i = reordered_tasks.index(task.id.to_s)
      task.move_to!(i + 1, params[:now] == 'true' ? current_release : nil, current_user) if i
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

  #TODO: move into model
  def update
    @task = Task.find(params[:id])
    if params[:task].nil? #state was changed
      @task.update_attribute :updated_field, ""
      if params[:state] == 'invalid' #marked invalid
        @task.invalidate!(current_user)
        if @task.release.nil? #not in current release
          @moved = true
          @task.move_to!((Task.current.last.try(:position) || 0) + 1, Release.current, current_user)
        end
      elsif @task.release #is in current release
        @task.next_state!
        @task.assign_to!(current_user) if @task.started? && !@task.assigned
        @task.verified_by!(current_user) if @task.verified?
      else #not in current release
        @moved = true
        @task.move_to!((Task.current.last.position + 1 rescue 1), Release.current, current_user)
      end
    else #something else was changed (other than state)
      if params[:task][:category] #category was changed
        @task.next_category!
      else #something other than category was changed
        @task.update_attributes(params[:task])
        @task.assign_to!(User.find(params[:task][:assigned_id])) if params[:task][:assigned_id]
      end
    end

    @task.reload

    respond_to do|format|
      format.js{render :layout => false}
    end
  end

  def poll
    @created_tasks = @future_tasks.created(current_user)
    @updated_tasks = @current_tasks.updated + @future_tasks.updated
    @assigned_tasks = Task.assigned_to(current_user)
    @any_updates = Task.other_updates?(current_user)
    @new_release = Release.current.created_at > Task.last_poll && Release.last[0].finished_by != current_user
    respond_to do|format|
      format.js{render :layout => false}
    end
  end

private
  def find_stuff
    @current_tasks = Release.current.tasks
    @future_tasks = Task.future
    @developers = User.developers
  end

  def render_task(editing = false)
    field, id = params[:id].split(/([0-9]+)/)
    @field = field.gsub(/_$/, '') if editing
    @task = Task.find(id)
    respond_to do|format|
      format.js{render :action => :update, :layout => false}
    end
  end
end

