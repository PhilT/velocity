module StoriesHelper
  def story_submit_button(f, story)
    f.submit( submit_name(story), :disabled => submit_disabled?(story))
  end

  def submit_disabled?(story)
    story.release ? !story.completed? : false
  end

  def submit_name(story)
    if story.release
      story.completed? ? 'verify' : story.state
    else
      'to current'
    end
  end
end
