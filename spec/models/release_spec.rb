require 'spec/spec_helper'

describe Release do
  before do
    @developer = Factory(:developer)
  end

  def create_release
    Release.create(:finished_by => @developer)
  end

  it 'should not be created when finished_by not specified' do
    Factory(:task, :state => 'verified')
    Release.create.errors.full_messages.should == ["Finished by can't be blank"]
  end

  it 'should not be created when no tasks verified' do
    Task.all.should be_empty
    create_release.should_not be_valid
  end

  it 'should not be created even when tasks exist in other releases' do
    Factory(:release, :tasks => [Factory(:task, :state => 'verified')])
    create_release.should_not be_valid
  end

  it 'should not be created with merged tasks' do
    %w(merged verified).each {|state| Factory(:task, :state => state)}
    create_release.should_not be_valid
  end

  it 'should move all verified and invalid tasks into release' do
    %w(pending started completed verified invalid).each {|state| Factory(:task, :state => state)}
    release = create_release
    release.should be_valid
    release.tasks.size.should == 2
  end

  it 'should send email' do
    %w(verified).each {|state| Factory(:task, :state => state)}
    ReleaseMailer.should_receive(:deliver_release_notification).and_return(true)
    create_release
  end

  it 'should calculate velocity' do
    task = Factory(:task, :state => 'verified')
    Factory(:release, :created_at => Time.now - 2.days)
    task = Factory(:task, :state => 'verified')
    Factory(:release, :tasks => [task], :created_at => Time.now - 1.day)

    Release.velocity.should == 7
  end
end

