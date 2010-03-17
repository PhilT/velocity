require 'spec/spec_helper'

describe Release do
  before do
    @release = Factory(:release)
    Factory(:task, :state => 'verified')
    story = Factory(:story, :name => 'verified story')
    Factory(:task, :story => story).update_attribute :state, 'verified'
    story.state.should == 'verified'

    story = Factory(:story, :name => 'incomplete story')
    Factory(:task, :story => story).update_attribute :state, 'verified'
    Factory(:task, :story => story).update_attribute :state, 'started'
    story.state.should == 'started'

    @developer = Factory(:developer)
  end
  it 'should finish release' do
    ReleaseMailer.should_receive(:deliver_release_notification).and_return(true)

    @release.finish!(@developer).should be_true
    @release.reload
    @release.stories.size.should == 1
    @release.tasks.size.should == 1
  end
  it 'should not finish release if has unverified tasks' do
    Factory(:task).update_attribute :state, 'completed'

    @release.finish!(@developer).should be_false
  end
end
