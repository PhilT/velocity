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

    assigns[:release] = mock_release

    render
    response.body.should include 'New release'
    response.body.should include 'New features'
    response.should have_tag 'li', '[Videos] Integrate videos'
    response.should have_tag 'li', 'Allow login'
    response.body.should include 'Bug fixes'
    response.should have_tag 'li', '[Videos] Fix styling'
    response.should have_tag 'li', 'Correct typos'
  end
end
