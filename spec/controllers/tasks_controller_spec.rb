require 'spec_helper'

describe TasksController do

  before(:each) do
    activate_authlogic
    @logged_in_user = Factory(:developer)
    UserSession.create(@logged_in_user)
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

    it 'should mark a pending task as started when in current release' do
      put :update, :id => @task.id
      assigns[:task].state.should == 'started'
      assigns[:moved].should == nil
    end

    it 'should move a task to the current release when not in it' do
      task = Factory(:future_task)
      put :update, :id => task.id
      assigns[:task].release.should == Release.current
      assigns[:moved].should == true
    end
  end

end

