class BuildingsController < ApplicationController
  
  
  def index
  end

  def search
  end
  
  def show
    building_id = params[:id] 
    @building = Building.find_by_id(building_id)
    @rooms = Room.where(:building_id => building_id)
  end
  
end
