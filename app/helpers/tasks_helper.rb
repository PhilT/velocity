module TasksHelper
  def render_hidden_task(task)
    "$('#{escape_javascript(render(task))}').hide()"
  end

  def now_tasks_heading
    "Tasks for the current release (features: #{@current_tasks.features.count}, bugs: #{@current_tasks.bugs.count}, refactorings: #{@current_tasks.refactorings.count})"
  end

  def future_tasks_heading
    "Tasks for a future release (#{@future_tasks.size})"
  end

  def submit_button(f, task)
    disabled = task.release.blank? && ['feature', 'refactoring'].include?(task.category)
    f.submit(task.action, :id => "task_#{task.id}_submit", :disabled => disabled)
  end
end

