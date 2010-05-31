require 'spec_helper'

describe TasksController do

  before(:each) do
    activate_authlogic
    @logged_in_user = Factory(:developer)
    UserSession.create(@logged_in_user)
    @task = Factory(:task)
  end

  describe 'create' do
    it 'should assign task to a story in a current release' do
      story = Factory(:story)
      post :create, :task => {:name => "#{story.name}: New task"}

      response.should be_success
      Task.count.should == 2
      assigns(:task).story.should == story
      assigns(:task).name.should == 'New task'
    end

    it 'should create a task without a story' do
      post :create, :task => {:name => 'Story: New task'}

      response.should be_success
      Task.count.should == 2
      assigns(:task).story.should be_nil
      assigns(:task).name.should == 'Story: New task'
    end
  end

  describe 'update' do
    it 'should remove a group' do
      @task.update_attribute(:story, Factory(:story))
      put :update, :id => @task.id, :group_id => 'group_'
      @task.reload.story_id.should be_nil
    end

    it 'should mark task invalid with current user when state invalid' do
      put :update, :id => @task.id, :state => 'invalid'
      assigns[:task].state.should == 'invalid'
      assigns[:task].assigned.should == @logged_in_user
      assigns[:moved].should == nil
    end

    describe 'current release tasks' do
      it 'should mark a pending task as started when in current release' do
        put :update, :id => @task.id
        assigns[:task].state.should == 'started'
      end

      it 'should assign to current user when starting task' do
        @task.started?.should be_false
        put :update, :id => @task

        @task.reload.started?.should be_true
        @task.assigned.should == @logged_in_user
      end

      it 'should assign to a story' do
        story = Factory(:story)
        put :update, :id => @task, :group_id => "group_#{story.id}"
        assigns[:task].story.should == story
      end
    end

    describe 'future release tasks' do
      it 'should not move invalid tasks into current release when assigned to a story' do
        @task.story = Factory(:story, :release => nil)
        @task.save

        put :update, :id => @task, :state => 'invalid'

        @task.reload.release.should be_nil
        @task.story.release.should be_nil
      end
    end

    describe 'sort' do
      before do
        @task.destroy
      end

      it 'should reorder tasks in current release' do
        @tasks = []
        3.times do
          @tasks << Factory(:task)
        end
        put :sort, :id => @tasks.first.id, :task => [@tasks[1].id, @tasks[2].id, @tasks[0].id]

        Task.all.map(&:release).uniq.should == [nil]
        Task.current.map(&:id).should == [@tasks[1].id, @tasks[2].id, @tasks[0].id]
      end
    end
  end
end

