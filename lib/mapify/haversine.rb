class Haversine

  def initialize
  end

  def distance_between( lat1, lon1, lat2, lon2 )
    # given two lat/lon points, compute the distance between the two points using the haversine formula
    # the result will be a Hash of distances which are key'd by 'mi','km','ft', and 'm'

    # pi = 3.1415926535
    rad_per_deg = 0.017453293  #  PI/180

    # the great circle distance d will be in whatever units R is in
    rmiles = 3956           # radius of the great circle in miles
    rkm = 6371              # radius in kilometers...some algorithms use 6367
    rfeet = rmiles * 5282   # radius in feet
    rmeters = rkm * 1000    # radius in meters

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    dlon_rad = dlon * rad_per_deg 
    dlat_rad = dlat * rad_per_deg

    lat1_rad = lat1 * rad_per_deg
    lon1_rad = lon1 * rad_per_deg

    lat2_rad = lat2 * rad_per_deg
    lon2_rad = lon2 * rad_per_deg

    # puts "dlon: #{dlon}, dlon_rad: #{dlon_rad}, dlat: #{dlat}, dlat_rad: #{dlat_rad}"

    a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

    return distance = {
  	  :mi => (rmiles * c),  # delta between the two points in miles
  	  :km => (rkm * c),      # delta in kilometers
  	  :ft => (rfeet * c),    # delta in feet
  	  :m => (rmeters * c)   # delta in meters
    }
  end

end