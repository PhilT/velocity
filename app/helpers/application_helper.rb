# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include CustomFormHelpers
  def task_class(task)
    if task.new_record?
      'new'
    elsif task.completed?
      'completed'
    else
      task.category.value
    end
  end

  def relateds(task)
    @active_tasks.reject{|t| t == task}
  end

  #used with form_elements
    if type == 'collection'
      haml_tag :li, f.collection_select(name, collection, :id, :value, {:prompt => hint}
    end
  end

=begin
  def complete(f, task)
    li_tag :complete, t_check_box(f, :completed, task.id)
  end

  def id(f, task)
    li_tag :id, task.id, nil, ":"
  end

  def name(f, task, options)
    li_tag :name, options[:edit] ? f.text_field(:name, :title => "what's this about?") : task.name
  end

  def edit_field(field)
    form.send(fields[field]['type'], )
  end

  def show_field(field)

  end

  def detail(f, task)
    li_tag :detail, options[:edit] ? f.text_field(:name, :title => 'would you like to expand on that?') : task.detail
  end

  def author(f, task)
    li_tag :author, task.author.name, "by " unless task.new_record?
  end

  def category(f, task)
    li_tag :category,
    task.completed? ? "type: #{task.category.value}" : f.collection_select(:category_id, @categories, :id, :value, {:prompt => 'Feature, bug?'})
  end

  def when_needed(f, task)

  end

  def effort(f, task)

  end

  def assigned(f, task)

  end

  def started(f, task)
    time_ago_in_words(time).gsub('about', '')
  end

  def completed(f, task)
    haml_tag:li, time_ago_in_words(task.completed_on).gsub('about', ''), :class => "completed" if task.completed?
  end

  def related(f, task)
    if task.related
      Related to #{task.related.name}
    elsif !task.completed?
      f.collection_select(:related, relateds(task), :id, :name, {:prompt => 'Is this related to another task?'}, {:id => "task_related_#{task.id}"})
    end
  end

  def submit(f, task)

  end


  %li.category=
  %li.when= f.collection_select(:when_id, @whens, :id, :value, {:prompt => 'Do this now, later?'}, {}) unless task.completed?
  %li.effort= f.collection_select(:effort_id, @efforts, :id, :value, :prompt => 'Effort required?') unless task.completed?
  %li.assigned
    - if task.completed?
      - if task.assigned_to
        == Assigned to #{task.assigned_to.name}
    - else
      = f.collection_select(:assigned_to_id, @developers, :id, :name, {:prompt => 'Who will do this?'}, {:id => "task_assigned_to_#{task.id}"})
  %li.started= render :partial => 'started', :locals => {:f => f, :task => task}
  %li.completed= time_ago(task.completed_on, 'Completed')
  %li.related= render :partial => 'related', :locals => {:f => f, :task => task}
  %li.save= submit_tag(task.new_record? ? 'Create' : 'Update') unless task.completed?

=end

end

