class CustomFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def check(name, options = {})
    defaults(name, options)
    wrap check_box(name, :id => @id) + add_label(options), name
  end

  def label(name, options = {})
    defaults(name, options)
    wrap decorate(@value, options.merge({:link => false})), name unless @value.blank?
  end

  def select(name, options = {})
    defaults(name, options)
    if @object.new_record? || currently_editing?(name)
      content = collection_select(name, options[:collection], :id, :name, {:prompt => options[:prompt]}, {:id => @id})
    elsif !@value.blank?
      content = decorate(include_id(options) + truncate(@value, :length => 30), options)
    else
      content = decorate(options[:nil], options.merge({:class => 'not_set'}))
    end
    wrap content, "#{name} #{@value unless @value.nil? || @value.include?(' ')} " + (options[:ajaxSelect] == false ? '' : 'ajaxSelect')
  end

  def text(name, options = {})
    defaults(name, options)
    value = @object.send(name)
    if value.blank? || currently_editing?(name)
      content = text_field(name, :id => @id, :title => options[:hint]) + link_to('', "/tasks/#{@id}", :class => 'get cancel')
    else
      value = value.gsub(/(http:\/\/\S+[a-z0-9\/])/i, '<a href="\1" class="link" title="visit page">\1</a>')
      content = decorate(value)
    end
    wrap content, name
  end

private
  def defaults(name, options)
    @value = options[:value] || @object.send(name.to_s.gsub(/_id$/, ''))
    @value = @value.name if @value.kind_of?(ActiveRecord::Base) unless @value.blank?
    @id = "#{name}_#{@object.id || 'new'}"
  end

  def include_id(options)
    options[:include_id] ? "#{@object.id}:" : ""
  end

  def currently_editing?(name)
    selected_field = @options[:edit].to_sym if @options[:edit]
    (!selected_field.blank? && selected_field == name)
  end

  def decorate(input, options = {})
    input = time_ago(input) if input.is_a?(ActiveSupport::TimeWithZone)
    input = make_link(input, options)
    "#{options[:prefix]}#{input}#{options[:suffix]}"
  end

  def make_link(input, options)
    unless @object.new_record? || options[:link] == false
      input = link_to "#{input}", "/tasks/#{@id}/edit", :class => [options[:class], :get].join(' ')
    end
    input
  end

  def add_label(options)
    options[:label] == false ? "" : label_tag(@id, options[:label])
  end

  def wrap(content, klass)
    content_tag(:li, content, :class => klass)
  end

  def time_ago(time)
    time_ago_in_words(time).gsub('about', '')
  end

end

