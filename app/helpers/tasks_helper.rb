module TasksHelper
  def section
    @task.started? ? 'current' : @task.when.name
  end

  def render_hidden_task
    "$('#{escape_javascript(render(@task))}').hide()"
  end

  def do_when(period)
    {:now => '.tasks_that_need_doing_now', :soon => '.tasks_that_need_doing_next', :later => '.tasks_to_do_later'}[period.to_sym]
  end

  def append_or_replace
    @changed_state || params[:task][:when_id] ? :append : :replace
  end

end

