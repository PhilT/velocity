module TasksHelper
  def render_hidden_task
    "$('#{escape_javascript(render(@task))}').hide()"
  end

end

