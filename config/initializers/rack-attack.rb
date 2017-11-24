Rack::Attack.blocklist('block 1.2.3.4') do |req|
  ["121.58.244.186", "216.250.102.8"].include?(req.ip)
end


# class Rack::Attack
  # your custom configuration...
# end
