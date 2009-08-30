class CustomFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::DateHelper
  @@inputs = YAML::load(File.open(RAILS_ROOT + '/config/inputs.yml'))

  def check(name, model, options = {})
    defaults(name, model)
    if (options[:show] == :input || @value.nil?) && !options[:only]
      wrap check_box(name, :id => @id) + add_label(options), name, options
    elsif !@value.blank?
      wrap decorate(time_ago(@value)), name, options
    end
  end

  def label(name, model, options = {})
    defaults(name, model)
    wrap decorate(@value), name, options
  end

  def select(name, model, options = {})
    defaults(name, model)
    if @value.blank? && !model.completed?
      content = collection_select(name, options[:collection], :id, :name, {:prompt => @defaults['prompt']}, {:id => @id})
    elsif !@value.blank?
      content = decorate(@value)
    end
    wrap content, "#{name} #{@value}", options
  end

  def text(name, model, options = {})
    defaults(name, model)
    value = model.send(name)
    content = value.blank? ? text_field(name, :id => @id) : decorate(value)
    wrap content, name, options
  end

  def submit(model, options = {})
    wrap super(model.new_record? ? 'create' : 'save'), "submit", options unless model.completed?
  end

private
  def defaults(name, model)
    @defaults = @@inputs[name.to_s]
    @model = model
    @value = model.send(name)
    @value = @value.name if @value.kind_of?(ActiveRecord::Base) unless @value.blank?
    @id = "#{name}_#{model.id || 'new'}"
  end

  def decorate(input)
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

