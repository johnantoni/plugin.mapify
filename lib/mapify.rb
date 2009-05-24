require 'mapify/haversine'

class Mapify
  
  def initialize
  end
  
  def radius_around_point(lat,lng,distance)
    radius = distance.to_f
    latR = radius / ((6076 / 5280) * 60)
    lonR = radius / (((Math.cos(lat * Math::PI / 180) * 6076) / 5280) * 60)

    return area = {
  	  :min_latitude => lat - latR,
  	  :min_longitude => lng - lonR,
  	  :max_latitude => lat + latR,
  	  :max_longitude => lng + lonR
    }
  end
  
  def deg2rad(deg)
  	(deg * Math::PI / 180)
  end

  def rad2deg(rad)
  	(rad * 180 / Math::PI)
  end

  def acos(rad)
  	Math.atan2(Math.sqrt(1 - rad**2), rad)
  end

  def distance_in_miles(loc1, loc2)
  	lat1 = loc1.latitude
  	lon1 = loc1.longitude
  	lat2 = loc2.latitude
  	lon2 = loc2.longitude
  	theta = lon1 - lon2

  	dist = Math.sin(self.deg2rad(lat1)) * Math.sin(deg2rad(lat2)) 
  		+ Math.cos(self.deg2rad(lat1)) * Math.cos(self.deg2rad(lat2)) * Math.cos(deg2rad(theta))

  	dist = self.rad2deg(self.acos(dist))

  	(dist * 60 * 1.1515).round #distance in miles
  end

  def miles_to(location)
  	Location.distance_in_miles(self, location)
  end

  def locationArea(location, miles)
  	radius = miles.to_f
  	latR = radius / ((6076 / 5280) * 60)
  	lonR = radius / (((Math.cos(location.latitude * Math::PI / 180) * 6076) / 5280) * 60)

  	{
  		:min_latitude => location.latitude - latR,
  		:min_longitude => location.longitude - lonR,
  		:max_latitude => location.latitude + latR,
  		:max_longitude => location.longitude + lonR
  	}
  end

  def location_ids_in_range(location, miles)
  	la = Location.locationArea(location, miles)
  	Location.find(:all,
  		:select => "locations.id",
  		:conditions => ["locations.latitude <= ? and locations.latitude >= ? " + \
  			" AND locations.longitude >= ? and locations.longitude <= ?",
  			la[:max_latitude], la[:min_latitude], la[:min_longitude], la[:max_longitude]
  		]
  	).collect { |l| l.id }
  end

  def locations_in_range(location, miles)
  	la = Location.locationArea(location, miles)
  	Location.find(:all,
  		:conditions => ["locations.latitude <= ? and locations.latitude >= ? " + \
  			" AND locations.longitude >= ? and locations.longitude <= ?",
  			la[:max_latitude], la[:min_latitude], la[:min_longitude], la[:max_longitude]
  		]
  	)
  end
  
end
