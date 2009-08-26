# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def duplicates(task)
    @active_tasks.reject{|t| t == task}
  end
  
  def time_ago(time, prefix)
    "#{prefix} #{time_ago_in_words(time).gsub('about', '')} ago" unless time.nil?
  end
end
