require 'spec/spec_helper'

describe Release do
  before do
    task = Factory(:task)
    task.update_attribute(:state, 'verified')
    @developer = Factory(:developer)
  end

  describe 'finish release' do
    it 'should finish release' do
      ReleaseMailer.should_receive(:deliver_release_notification).and_return(true)

      Release.finish!(@developer).should be_true
      release = Release.last
      release.tasks.size.should == 1
    end

    it 'should not finish release if has unverified tasks' do
      Factory(:task).update_attribute :state, 'completed'

      Release.finish!(@developer).should be_false
    end

    it 'should include invalid tasks' do
      task = Factory(:task)
      task.update_attribute :state, 'verified'
      invalid_task = Factory(:task)
      invalid_task.update_attribute :state, 'invalid'

      Release.finish!(@developer).should be_true
      Release.last.tasks.should include(task, invalid_task)
    end
  end

  it 'should calculate velocity' do
    task = Factory(:task)
    task.update_attribute(:state, 'verified')
    Factory(:release, :created_at => Time.now - 2.days)
    Factory(:release, :tasks => [task], :created_at => Time.now - 1.day)

    Release.velocity.should == 7
  end
end

