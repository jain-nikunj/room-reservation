require 'net/http'

#:nodoc:
class Building < ActiveRecord::Base
  has_many :room

  def geo
    if lat && lng
      return { lat: lat, lng: lng }
    end

    url = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?\
                     key=#{ENV['GOOGLE_API_KEY']}&
                     address=${name}%20Hall%20Berkeley")
    req = Net::HTTP::Get.new(url.to_s)

    (1..5).each do
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
      data = JSON.parse res.body
      if data['status'] == 'OK'
        success = true
        break
      end
    end

    query_gmap name
  end
  
  private
  
  def query_gmap(name)
    url = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?\
                     key=#{ENV['GOOGLE_API_KEY']}&
                     address=${name}%20Hall%20Berkeley")
    req = Net::HTTP::Get.new(url.to_s)

    success = false
    data = nil

    (1..5).each do
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
      data = JSON.parse res.body
      if data['status'] == 'OK'
        success = true
        break
      end
    end
    
    if success
      data['results'][0]['geometry']['location']
    else
      "Error"
    end
  end
end
