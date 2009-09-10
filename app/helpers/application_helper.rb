# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def task_class(task)
    if task.new_record?
      'new'
    elsif task.completed?
      'completed'
    else
      task.category.name
    end
  end

  def relateds(task)
    @active_tasks.reject{|t| t == task}
    [Task.new(:name => '(not related)')] + @active_tasks
  end

end

