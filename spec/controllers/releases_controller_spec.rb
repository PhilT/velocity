require 'spec_helper'

describe ReleasesController do
  before(:each) do
    activate_authlogic
    @logged_in_user = Factory(:developer)
    UserSession.create(@logged_in_user)
  end

  it 'lists all releases' do
    get :index
    response.should be_success
  end

  describe 'create' do
    it 'should remove orphaned stories' do
      mock_release = mock_model(Release, :valid? => true)
      Release.stub(:create).and_return(mock_release)
      Story.should_receive :remove_orphans
      post :create
    end

    it 'creates a valid release' do
      Factory(:task, :state => 'verified')

      post :create
      response.should redirect_to tasks_path
      response.flash[:notice].should == 'Released! Velocity is now 0'
    end
  end
end

