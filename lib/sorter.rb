class Sorter

  def update task

    if task.state == 'pending'
      last_started = Task.last_started.position
      task.insert_at(last_started) if task.position < last_started
    end

  end

end

