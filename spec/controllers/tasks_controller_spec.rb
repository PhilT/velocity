require 'spec_helper'

describe TasksController do

  before(:each) do
    activate_authlogic
    @logged_in_user = Factory(:developer)
    UserSession.create(@logged_in_user)
    Factory(:release)
    @task = Factory(:task)
  end

  describe 'update' do
    it 'should mark task invalid with current user when state invalid' do
      put :update, :id => @task.id, :state => 'invalid'
      assigns[:task].state.should == 'invalid'
      assigns[:task].assigned.should == @logged_in_user
      assigns[:moved].should == nil
    end

    it 'should move invalid task to current release' do
      task = Factory(:future_task)
      put :update, :id => task.id, :state => 'invalid'
      assigns[:task].release.should == Release.current
      assigns[:moved].should == true
    end

    it 'should move a task to the current release when not in it' do
      task = Factory(:future_task)
      put :update, :id => task.id
      assigns[:task].release.should == Release.current
      assigns[:moved].should == true
    end

    describe 'current release' do
      it 'should mark a pending task as started when in current release' do
        put :update, :id => @task.id
        assigns[:task].state.should == 'started'
        assigns[:moved].should == nil
      end
      
      it 'should assign to current user when starting task' do
        @task.started?.should be_false
        put :update, :id => @task

        @task.reload.started?.should be_true
        @task.assigned.should == @logged_in_user
      end
      it 'should assign to a story' do
        story = Factory(:story)
        put :update, :id => @task, :task => {:story_id => story}
        assigns[:task].story.should == story
      end
    end

    describe 'future releases' do
      it 'should move bugs into current release without a story'
      it 'should move features and refactorings into current release with a story'
      it 'should not move features or refactorings into current release without a story'
      it 'should not move invalid tasks into current release when assigned to a story'
    end
  end

end

