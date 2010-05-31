require 'spec_helper'

describe ReleasesController do
  before(:each) do
    activate_authlogic
    @logged_in_user = Factory(:developer)
    UserSession.create(@logged_in_user)
  end

  describe 'create' do
    it 'should remove orphaned stories' do
      Story.should_receive :remove_orphans
      post :create
    end
  end
end

