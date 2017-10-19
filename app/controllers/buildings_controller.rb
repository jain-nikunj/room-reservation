class BuildingsController < ApplicationController
  
  
  def index
    
  end

  def search
  end
  
  def show
    building_id = params[:id] 
    @building = Building.find_by_id(building_id)
    
    if @building.blank?
      flash[:notice] = "This building does not exist."
      redirect_to buildings_path
    end
    
    @rooms = Room.where(:building_id => building_id)
    @rooms.each do |room|
      if room.misc == nil then room.misc = "N/A" end
      if room.facilities == nil then room.facilities = "N/A" end
    end
  end
  
end
