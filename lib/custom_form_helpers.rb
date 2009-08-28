module CustomFormHelpers
  def css(name, id)
    "task_#{name}_#{id || 'new'}"
  end

  def t_check_box(f, name, id)
    f.check_box(name, :id => css(name, id))
  end
end

