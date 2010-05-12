module StoriesHelper
  def story_submit_button(f, story)
    f.submit( submit_name(story), :disabled => submit_disabled?(story))
  end

  def submit_disabled?(story)
    !story.completed?
  end

  def submit_name(story)
    story.completed? ? 'verify' : story.state
  end
end

