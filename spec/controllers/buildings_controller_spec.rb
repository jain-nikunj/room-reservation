require 'rails_helper'

RSpec.describe BuildingsController, type: :controller do
  
  describe "shows the details page for the building" do
    before :each do 
      @id = "42"
      @user_id = "512"
      @fake_building = double('Fake Building')
      @room1  = double('Room1')
      @unordered_fake = double('Fake')
      @fake_rooms = [@room1]
      
      allow_any_instance_of(BuildingsController).to receive(:session_helper_user_id).and_return(@user_id)
      allow(Building).to receive(:find_by_id).with(@id).and_return(@fake_building)
      allow(@fake_building).to receive(:blank?).and_return(false)
      allow(@unordered_fake).to receive(:order).and_return(@fake_rooms)
      allow(@room1).to receive(:misc).and_return("Misc")
      allow(@room1).to receive(:facilities).and_return("Facilities")
    end
    
    it 'searches the database for the building id' do
        expect(Building).to receive(:find_by_id).with(@id).and_return(@fake_building)
        get :show, {:id => @id}
    end
    
    it 'selects the Show Details page template' do
      get :show, {:id => @id}
      expect(response).to render_template('show')
    end
    
    it 'flashes an error message on the homepage if building does not exist' do
      allow(Building).to receive(:find_by_id).with(@id).and_return(nil)
      get :show, {:id => @id}
      expect(flash[:notice]).to be_present
      expect(response).to redirect_to(buildings_path)
    end
    
    it 'searches the database for rooms when valid search' do
      allow_any_instance_of(BuildingsController).to receive(:filter_rooms)
      controller.instance_variable_set(:@rooms, Room.all)
      expect_any_instance_of(Room::ActiveRecord_Relation).to receive(:where).with(:building_id => @id).and_return(@unordered_fake)
      get :show, {:id => @id}
    end  
    
    it 'sets the instance of rooms after a valid search' do
      allow_any_instance_of(BuildingsController).to receive(:filter_rooms)
      controller.instance_variable_set(:@rooms, Room.all)
      allow_any_instance_of(Room::ActiveRecord_Relation).to receive(:where).with(:building_id => @id).and_return(@unordered_fake)
      get :show, {:id => @id}
      expect(assigns[:rooms]).to eq(@fake_rooms)
    end
    
    it 'assigns correct text when missing attributes of rooms' do
      allow_any_instance_of(BuildingsController).to receive(:filter_rooms)
      controller.instance_variable_set(:@rooms, Room.all)
      allow_any_instance_of(Room::ActiveRecord_Relation).to receive(:where).with(:building_id => @id).and_return(@unordered_fake)
      allow(@room1).to receive(:misc).and_return(nil)
      allow(@room1).to receive(:facilities).and_return(nil)
      expect(@room1).to receive(:misc=)
      expect(@room1).to receive(:facilities=)
      get :show, {:id => @id}
    end
  end
  
  describe "checks for user login status" do
    before :each do
      @id = "42"
    end  
      
    it 'uses the helper function to check login status' do
      expect_any_instance_of(BuildingsController).to receive(:session_helper_user_id).and_return(@id)
      get :show, {:id => @id}
    end
    
    it 'redirects to home page with error message when not logged in' do
      get :show, {:id => @id}
      expect(flash[:alert]).to be_present
      expect(response).to redirect_to(buildings_path)
    end  
      
  end
  
  describe 'filters as needed' do
    before :each do 
      @room1 = double('Room1')
      @id = "42"
      @fake_rooms = [@room1]
      @placeholder_for_where = double('Fake rooms')
      
      allow(Room).to receive(:all).and_return(@placeholder_for_where)
      allow(@placeholder_for_where).to receive(:where).and_return(@placeholder_for_where)
      allow(@placeholder_for_where).to receive(:select).and_return(@placeholder_for_where)
      allow(@placeholder_for_where).to receive(:group).and_return(@fake_rooms)
      allow(@room1).to receive(:building_id).and_return(@id)
    end
    
    it 'calls out to Building for name' do
      @fake_building = double("Building")
      @fake_name = "Hearst Memorial Mining Building"
      allow(@fake_building).to receive(:name).and_return(@fake_name)
      expect(Building).to receive(:find_by_id).with(@id).and_return(@fake_building)
      get :filter, {:StudentAccessible => true, :Board => true, :AV => true,
                    :Classroom => false, :LectureHall => false, :Auditorium => false,
                    :SeminarRoom => false, :capacityLower => "0", :capacityUpper => "100"}
      
    end
  end

end
