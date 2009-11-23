require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
      task.verify

      first_started_on = task.started_on

      task.restart
      task.started?.should == true
      task.completed_on.should be_nil
      task.started_on.should == first_started_on
    end
  end
end

