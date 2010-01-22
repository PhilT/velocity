require 'spec_helper'

describe TasksController do

  before(:each) do
    activate_authlogic
    UserSession.create(Factory(:developer))
  end

  describe 'update' do
    it 'should mark task invalid with current user when state invalid' do
      task = Factory(:task)
      put :update, :id => task.id, :state => 'invalid'
      assigns[:task].state.should == 'invalid'
    end
  end

end

