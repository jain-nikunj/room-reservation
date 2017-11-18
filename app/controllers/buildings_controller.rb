class BuildingsController < ApplicationController
  helper_method :filter_rooms

  def index

  end

  def filter
    filter_rooms
    
    ret = []
    @rooms.select(:building_id).group(:building_id).each do |data|
      building_name = Building.find_by_id(data.building_id).name
      ret << ({id: data.building_id, name: building_name})
    end
    render json: ret 
  end
  
  def search
  end
  
  def session_helper_user_id
      session[:user_id]
  end
  
  def show
    if session_helper_user_id == nil
      flash[:alert] = "Please log in."
      redirect_to buildings_path
      return
    end
    
    filter_rooms
    building_id = params[:id] 
    @building = Building.find_by_id(building_id)
    
    if @building.blank?
      flash[:notice] = "This building does not exist."
      redirect_to buildings_path
    end

    @rooms = @rooms.where(:building_id => building_id).order(:number)
    @rooms.each do |room|
      if room.misc == nil then room.misc = "N/A" end
      if room.facilities == nil then room.facilities = "N/A" end
    end
  end
  
  def filter_rooms
    @rooms = Room.all
    if params[:StudentAccessible]
      @rooms = @rooms.where("UPPER(facilities) LIKE '%ADA-STUDENT%'")
    end
    if params[:Board]
      @rooms = @rooms.where("UPPER(facilities) LIKE '%BOARD%'")
    end
    if params[:AV]
      @rooms = @rooms.where("UPPER(facilities) LIKE '%AV%'")
    end
    if not params[:Classroom]
      @rooms = @rooms.where("UPPER(misc) NOT LIKE '%CLASSROOM%'")
    end
    if not params[:LectureHall]
      @rooms = @rooms.where("UPPER(misc) NOT LIKE '%LECTURE HALL%'")
    end
    if not params[:Auditorium]
      @rooms = @rooms.where("UPPER(misc) NOT LIKE '%AUDITORIUM%'")
    end
    if not params[:SeminarRoom]
      @rooms = @rooms.where("UPPER(misc) NOT LIKE '%SEMINAR ROOM%'")
    end
    if params[:capacityLower]
      @rooms = @rooms.where("capacity >= ?", params[:capacityLower].to_i)
    end
    if params[:capacityUpper]
      @rooms = @rooms.where("capacity <= ?", params[:capacityUpper].to_i)
    end
  end
  
end
