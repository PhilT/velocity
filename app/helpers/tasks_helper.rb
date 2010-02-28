module TasksHelper
  def render_hidden_task(task)
    "$('#{escape_javascript(render(task))}').hide()"
  end

  def current_tasks_heading
    "Tasks for the current release (features: #{Release.current.features.count}, bugs: #{Release.current.bugs.count}, refactorings: #{Release.current.refactorings.count})"
  end

  def future_tasks_heading
    "Tasks for a future release (#{@future_tasks.size})"
  end

  def task_submit_button(f, task)
    disabled = task.release.blank? && (['feature', 'refactor'].include?(task.category) || task.story.present?)
    f.submit(task.action, :id => "task_#{task.id}_submit", :disabled => disabled)
  end
end

