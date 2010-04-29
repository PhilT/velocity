module TasksHelper
  def current_tasks_heading
    "Tasks for the current release"
  end

  def future_tasks_heading
    "Tasks for a future release (#{@future_tasks.size})"
  end

  def task_submit_button(f, task)
    f.submit task.action, :id => "task_#{task.id}_submit"
  end

  def select_list_for(task)
    task.story ? "#story_#{task.story_id} .tasks" : "#{task.bug? ? '#bugs' : '#future'} .tasks"
  end

  def release_full?(count)
    if !@release_full && Release.velocity == (count + 1)
      @release_full = true
    else
      false
    end
  end
end

