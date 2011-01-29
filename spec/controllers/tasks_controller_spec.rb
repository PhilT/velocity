require 'spec_helper'

describe TasksController do

  before(:each) do
    activate_authlogic
    @logged_in_user = Factory(:developer)
    UserSession.create(@logged_in_user)
    @task = Factory(:task)
  end

  it 'lists tasks' do
    get :index
    response.should be_success
  end
  it 'edits a task' do
    get :edit, :id => "name_#{@task.id}", :format => 'js'
    response.should be_success
  end
  it 'shows a task' do
    get :show, :id => "name_#{@task.id}", :format => 'js'
    response.should be_success
  end

  describe 'create' do
    it 'should assign task to a story in a current release' do
      story = Factory(:story)
      post :create, :task => {:name => "#{story.name}: New task"}, :format => 'js'

      response.should be_success
      Task.count.should == 2
      assigns(:task).story.should == story
      assigns(:task).name.should == 'New task'
    end

    it 'should create a task without a story' do
      post :create, :task => {:name => 'Story: New task'}, :format => 'js'

      response.should be_success
      Task.count.should == 2
      assigns(:task).story.should be_nil
      assigns(:task).name.should == 'Story: New task'
    end
  end

  describe 'update' do
    it 'should remove a group' do
      @task.update_attribute(:story, Factory(:story))
      put :update, :id => @task.id, :group_id => 'remove', :format => 'js'
      @task.reload.story_id.should be_nil
    end

    it 'should mark task invalid with current user when state invalid' do
      put :update, :id => @task.id, :state => 'invalid', :format => 'js'
      assigns[:task].state.should == 'invalid'
      assigns[:task].assigned.should == @logged_in_user
      assigns[:moved].should == nil
    end

    it 'changes category' do
      put :update, :id => @task.id, :task => {:category => 'true'}, :format => 'js'
      assigns[:task].category.should == 'bug'
    end

    it 'changes task name' do
      put :update, :id => @task.id, :task => {:name => 'My task'}, :format => 'js'
      response.should be_success
      assigns[:task].name.should == 'My task'
    end

    describe 'current release tasks' do
      it 'should mark a pending task as started when in current release' do
        put :update, :id => @task.id, :format => 'js'
        assigns[:task].state.should == 'started'
      end

      it 'should assign to current user when starting task' do
        @task.started?.should be_false
        put :update, :id => @task, :format => 'js'

        @task.reload.started?.should be_true
        @task.assigned.should == @logged_in_user
      end

      it 'should assign to a story' do
        story = Factory(:story)
        put :update, :id => @task, :group_id => "group_#{story.id}", :format => 'js'
        assigns[:task].story.should == story
      end
    end

    describe 'future release tasks' do
      it 'should not move invalid tasks into current release when assigned to a story' do
        @task.story = Factory(:story, :release => nil)
        @task.save

        put :update, :id => @task, :state => 'invalid', :format => 'js'

        @task.reload.release.should be_nil
        @task.story.release.should be_nil
      end
    end
  end

  describe 'poll' do
    it 'polls for updates' do
      get :poll, :format => 'js'
      response.should be_success
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
      put :sort, :id => @tasks.first.id.to_s, :task => [@tasks[1].id, @tasks[2].id, @tasks[0].id].map(&:to_s), :format => 'js'

      Task.all.map(&:release).uniq.should == [nil]
      Task.current.map(&:id).should == [@tasks[1].id, @tasks[2].id, @tasks[0].id]
    end
  end
end

