module StoriesHelper
  def render_hidden_story(story)
    "$('#{escape_javascript(render(story))}').hide()"
  end

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
