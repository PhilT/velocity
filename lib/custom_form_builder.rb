class CustomFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::UrlHelper

  @@inputs = YAML::load(File.open(RAILS_ROOT + '/config/inputs.yml'))

  def check(name, options = {})
    defaults(name, options)
    if (options[:show] == :input || @value == false) && options[:only].nil?
      wrap check_box(name, :id => @id) + add_label(options), name, options
    elsif !@value.blank?
      wrap decorate(time_ago(@value)), name, options
    end
  end

  def label(name, options = {})
    defaults(name, options)
    wrap decorate(@value, :link => false), name, options unless @value.blank?
  end

  def select(name, options = {})
    defaults(name, options)
    if @object.new_record?
      content = collection_select(name, options[:collection], :id, :name, {:prompt => @defaults['prompt']}, {:id => @id})
    elsif !@value.blank?
      content = decorate(@value)
  else
      content = decorate(@defaults['nil'], :class => 'not_set')
    end
    wrap content, "#{name} #{@value}", options
  end

  def text(name, options = {})
    defaults(name, options)
    value = @object.send(name)
    if value.blank?
      content = text_field(name, :id => @id, :title => @defaults['hint'])
    else
      value = value.gsub(/([.,"\(])/, '\1</strong>')
      value += '</strong>' unless value.include?('</strong>')
      content = decorate("<strong>#{value}")
    end
    wrap content, name, options
  end

  def submit(options = {})
    wrap super('create'), "submit", options if @object.new_record?
  end

private
  def defaults(name, options)
    @defaults = @@inputs[name.to_s]
    @value = options[:value] || @object.send(name.to_s.gsub(/_id$/, ''))
    @value = @value.name if @value.kind_of?(ActiveRecord::Base) unless @value.blank?
    @id = "#{name}_#{@object.id || 'new'}"
  end

  def decorate(input, options = {})
    input = link_to "#{input}", "/tasks/#{@id}/edit", :class => options[:class] unless @object.new_record? || options[:link] == false
    "#{@defaults['prefix']}#{input}#{@defaults['suffix']}"
  end

  def add_label(options)
    options[:label] == false ? "" : label_tag(@id, @defaults['label'])
  end

  def wrap(content, klass, options)
    content_tag(options[:wrap] == false ? :span : :li, content, :class => klass)
  end

  def time_ago(time)
    time_ago_in_words(time).gsub('about', '')
  end

end

