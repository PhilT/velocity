# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def related_input(f)
    f.collection_select(:related, relateds(task), :id, :name, {:prompt => 'Is this related to another task?'}, {:id => "task_related_#{task.id}"})
  end

  def relateds(task)
    @active_tasks.reject{|t| t == task}
  end

  def time_ago(time, prefix)
    "#{prefix} #{time_ago_in_words(time).gsub('about', '')} ago" unless time.nil?
  end

  def task_class(task)
    if task.new_record?
      'new'
    elsif task.completed?
      'completed'
    else
      task.category.value
    end
  end
end

