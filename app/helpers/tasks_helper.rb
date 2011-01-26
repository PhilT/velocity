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

  def time_ago time
    (distance_of_time_in_words_to_now(time).gsub('about ', '') + ' ago').gsub('less than a minute ago', 'just now')
  end

  def description_for(task)
    story_name = task.story ? "[#{task.story.name}] " : ''
    "#{story_name}#{task.name}"
  end
end

