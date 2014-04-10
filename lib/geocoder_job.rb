require 'rubygems'
require 'geocoder'
require 'data_mapper'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, "sqlite://#{ROOT_PATH}/db/database.sqlite3")

class Location
  include DataMapper::Resource

  property :id,       Serial
  property :address,  String
  property :latitude, String
  property :longitude,String
end

DataMapper.auto_migrate!

class GeocoderJob
  @queue = :geocoder


  def self.perform(address,file_name)
    f = File.open(file_name, 'a')

    if address.empty? || address == ','
      f.puts address
    else
      location = Location.first(:address => address)
      if location.nil?
        sleep(5)
        begin
          result = Geocoder.search(address).first
          location = Location.create(:address => address, :latitude => result.coordinates[0], :longitude => result.coordinates[1])
        rescue
          location = Location.create(:address => address, :latitude => '', longitude => '')
        end
      end
      f.puts "#{location.address};#{location.latitude};#{location.longitude}"
    end
    f.close
  end

end
