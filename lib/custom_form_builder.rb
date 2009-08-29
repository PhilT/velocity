module CustomFormBuilder < ActionView::Helpers::FormBuilder
  def input(name, model, options = {})
    defaults = YAML::Load(File.open(Rails.root + '/config/inputs.yml'))[name]
    type = defaults['type']
    id = "#{name}_#{model.id}"

    if type == 'check_box'

    if type == 'collection_select'
      collection_select(name, options[:collection], :id, :name, {:prompt => defaults['hint']}, {:id => id})

      collection_select name, :prompt => defaults['hint'], :id => id
  end
end

