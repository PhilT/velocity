require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task do
  before(:each) do
    @valid_attributes = {
      :name => 'a task',
      :category => Enum.find_by_name('Category').enum_values.first,
      :author => Factory(:customer),
      :when => Enum.find_by_name('When').enum_values.first
    }
  end

  it "should create a new instance given valid attributes" do
    Task.create!(@valid_attributes)
  end

  describe 'form helper methods' do
    it "should handle started" do
      task = Factory :task
      task.started?.should == false
      task.started = true
      task.started?.should == true
      task.started_on.should_not be_nil
    end

    it "should handle completed" do
      task = Factory :task
      task.completed?.should == false
      task.completed = true
      task.completed?.should == true
      task.completed_on.should_not be_nil
    end
  end
end

