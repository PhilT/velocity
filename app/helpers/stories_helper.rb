module StoriesHelper
  def story_submit_button(f, story)
    f.submit( story.release ? story.state : 'to current', :disabled => story.release)
  end
end
