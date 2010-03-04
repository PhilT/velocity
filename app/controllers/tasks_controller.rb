class TasksController < ApplicationController
  before_filter :find_stuff

  def index
    @new_tasks = [Task.new]
  end

  def sort
    @task = Task.find(params[:id])
    release = @task.release
    reordered_tasks = params['task']
#    reordered_tasks.each_with_index do |task_id, index|
#      Task.find(task_id).move_to!(index + 1, release, current_user)
#    end
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
    story = extract_story(params[:task][:name])
    @task = Task.create(params[:task].merge(:author => current_user, :story => story, :release => story.try(:release)))
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
        if @task.release.nil? && @task.story.nil? #not in current release
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
      elsif params[:task][:story_id] # story_id was changed
        @task.update_attributes(params[:task].merge({:release_id => Story.find(params[:task][:story_id]).release_id}))
        @moved = true
      else #something other than category and story_id was changed
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
    @updated_tasks = Task.updated.all(:conditions => ['release_id = ? OR release_id IS NULL', Release.current.id])
    @assigned_tasks = Task.assigned_to(current_user)
    @any_updates = Task.other_updates?(current_user)
    @new_release = Release.current.created_at > Task.last_poll && Release.last[0].finished_by != current_user
    respond_to do|format|
      format.js{render :layout => false}
    end
  end

private
  def find_stuff
    @current_stories = Release.current.stories
    @current_tasks = Release.current.tasks.without_story
    @future_stories = Story.future
    @stories = @current_stories + @future_stories
    @future_tasks = Task.future.without_story
    @developers = User.developers
    @non_developers = User.non_developers
  end

  def render_task(editing = false)
    field, id = params[:id].split(/([0-9]+)/)
    @field = field.gsub(/_$/, '') if editing
    @task = Task.find(id)
    respond_to do|format|
      format.js{render :action => :update, :layout => false}
    end
  end

  def extract_story(task_name)
    if task_name =~ /^(.+?):/
      Story.find_by_name($1)
    end
  end
end

