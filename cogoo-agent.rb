#encoding: utf-8
require 'mechanize'
require 'json'
require 'uri'
require 'date'

class CogooAgent
  API_URL  = "https://cogoo.jp/api/"
  AUTH_URL = URI.join(API_URL, "user_authes/")
  BIKE_URL = URI.join(API_URL, "bicycle/by_name/")
  RENT_URL = URI.join(API_URL, "rentals/")

  def initialize
    @agent = Mechanize.new
  end

  def login(mail, password)
    req_auth_data = JSON.generate({"mobile_mail"=>mail.strip,"password"=>password.strip})
    @agent.post AUTH_URL, req_auth_data
  end

  def get_bike(bike_name, spot_id)
    req_url = URI.join(BIKE_URL, "#{spot_id.to_s.strip}/#{bike_name.to_s.strip}")
    res = @agent.get(req_url) 
    bike = JSON.parse(res.body)
    return bike
  end

  def rent(bike)
    if bike['is_rented']
      puts "The bicycle #{bike_name} is unavailable now."
    else
      req_bike_data = JSON.generate({"bicycle_id"=>bike['id']})
      res = @agent.post(RENT_URL, req_bike_data)
      rent_data = JSON.parse(res.body)
      start_time = DateTime.strptime(rent_data['start_time'].to_s+"JST", "%Y%m%d%H%M%S%Z")
      puts "Bike name: #{rent_data['name']}"
      puts start_time.strftime("Rent start: %F %T")
      puts "Password: #{rent_data['password']}"
    end
  end

  def logout
    @agent.delete(AUTH_URL)
  end

end

if __FILE__ == $0
  require 'io/console'
  require 'optparse'

  confirm = true
  opt = OptionParser.new
  opt.on('-y', "no confirmation in rental start.") {|v| confirm = false}
  cogoo = CogooAgent.new

  opt.parse!(ARGV)

  print "Mail: "
  mail = gets
  print "Password: "
  pass = STDIN.noecho(&:gets)
  print "\n"
  cogoo.login(mail, pass)

  print "Bike name: "
  bike_name = gets
  bike = cogoo.get_bike(bike_name, 10002) #spot_id is 10002 in Kyoto Univ.
  
  rent_ok = false
  if confirm
    print 'Rent bike "#{bike['name']}"? (y/n): '
    rent_ok = true if /^y/.match(gets.strip)
  end
  cogoo.rent(bike) if !confirm || rent_ok

  cogoo.logout

end

