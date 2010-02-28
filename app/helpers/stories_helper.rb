module StoriesHelper
  def current_stories_heading
    "Stories for the current release"
  end

  def story_submit_button(f, story)
    f.submit( story.release ? story.state : 'to current', :disabled => story.release)
  end
end
