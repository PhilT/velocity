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
    @task = Task.create(params[:task].merge(:author => current_user))
    respond_to do|format|
      format.js{render :layout => false}
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.started = params[:started]
    form = CustomFormBuilder.new('task', @task, template)
    c = form.check :started, @task, :value => @task.started_on, :edit => false
    render :text => "$('#edit_task_#{@task} .started').replaceHTML(#{c})"
  end
end

