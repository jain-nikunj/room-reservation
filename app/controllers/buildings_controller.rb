class BuildingsController < ApplicationController
  helper_method :filter_rooms

  def index

  end

  def filter
    ret = []
    Building.all.includes(:room).each do |b|
      rooms = filter_rooms(b.room)
      unless rooms.empty?
        ret << ({id: b.id, name: b.name, 
                 count: rooms.count, 
                 max: rooms.maximum(:capacity)
        })
      end
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
    
    @rooms = filter_rooms
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
  
  def filter_rooms(rooms = Room.all)
    if params[:StudentAccessible]
      rooms = rooms.where("UPPER(facilities) LIKE '%ADA-STUDENT%'")
    end
    if params[:Board]
      rooms = rooms.where("UPPER(facilities) LIKE '%BOARD%'")
    end
    if params[:AV]
      rooms = rooms.where("UPPER(facilities) LIKE '%AV%'")
    end
    
    unless params[:Classroom]
      rooms = rooms.where("UPPER(misc) NOT LIKE '%CLASSROOM%'")
    end
    
    unless params[:LectureHall]
      rooms = rooms.where("UPPER(misc) NOT LIKE '%LECTURE HALL%'")
    end
    
    unless params[:Auditorium]
      rooms = rooms.where("UPPER(misc) NOT LIKE '%AUDITORIUM%'")
    end
    
    unless params[:SeminarRoom]
      rooms = rooms.where("UPPER(misc) NOT LIKE '%SEMINAR ROOM%'") 
    end
    
    if params[:capacityLower]
      rooms = rooms.where("capacity >= ?", params[:capacityLower].to_i)
    end
    if params[:capacityUpper]
      rooms = rooms.where("capacity <= ?", params[:capacityUpper].to_i)
    end
    rooms
  end
  
end
