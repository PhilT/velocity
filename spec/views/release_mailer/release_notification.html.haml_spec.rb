require 'spec_helper'

describe 'release_mailer/release_notification.html.haml' do
  it 'renders view' do
    mock_release = mock_model(Release)
    mock_release.stub(:created_at).and_return(Time.now)
    mock_story = mock_model(Story, :name => 'Videos')
    mock_feature = mock_model(Task, :name => 'Integrate videos', :story => mock_story)
    mock_feature_no_story = mock_model(Task, :name => 'Allow login', :story => nil)
    mock_bug = mock_model(Task, :name => 'Fix styling', :story => mock_story)
    mock_bug_no_story = mock_model(Task, :name => 'Correct typos', :story => nil)
    mock_release.stub_chain(:tasks, :features, :verified).and_return([mock_feature, mock_feature_no_story])
    mock_release.stub_chain(:tasks, :bugs, :verified).and_return([mock_bug, mock_bug_no_story])

    assign(:release, mock_release)

    render
    rendered.should contain 'New release'
    rendered.should contain 'New features'
    rendered.should contain '[Videos] Integrate videos'
    rendered.should contain 'Allow login'
    rendered.should contain 'Bug fixes'
    rendered.should contain '[Videos] Fix styling'
    rendered.should contain 'Correct typos'
  end
end
