require 'spec_helper'

describe Task do
  before(:each) do
    @valid_attributes = {
      :name => 'a task',
      :author => Factory(:customer),
    }
  end

  it "should create a new instance given valid attributes" do
    Task.create!(@valid_attributes)
  end


  describe 'form helper methods' do
    it "should handle started" do
      task = Factory :task
      task.started?.should == false
      task.start
      task.started?.should == true
      task.started_on.should_not be_nil
    end

    it "should handle completed" do
      task = Factory(:task)
      task.update_attribute :state, 'started'
      task.completed?.should == false
      task.complete
      task.completed?.should == true
      task.completed_on.should_not be_nil
    end

    it "should handle restarting" do
      task = Factory(:task)
      task.start
      task.complete
      task.merge
      task.verify

      first_started_on = task.started_on

      task.restart
      task.started?.should == true
      task.completed_on.should be_nil
      task.started_on.to_s.should == first_started_on.to_s
    end
  end

  it 'should return created tasks' do
    user = Factory(:developer)
    task = Factory(:task)

    created_tasks = Task.created(user)
    created_tasks.size.should == 1
    created_tasks.should include(task)
  end
  it 'should return updated tasks' do
    time = Time.now - 1.day
    task = Factory(:task, :created_at => time)
    task.created_at.should == time

    updated_tasks = Task.updated
    updated_tasks.size.should == 1
    updated_tasks.should include(task)
  end
  it 'should return tasks assigned to user' do
    user = Factory(:developer)
    task = Factory(:task)
    task.assign_to!(user)

    assigned_tasks = Task.assigned_to(user)
    assigned_tasks.size.should == 1
    assigned_tasks.should include(task)
  end

  it 'should cleanup when restarting a task' do
    task = Factory(:task)
    user = Factory(:developer)

    5.times {task.advance!(user)}

    task.reload
    task.verified_by.should be_nil
    task.completed_on.should be_nil
  end
end

