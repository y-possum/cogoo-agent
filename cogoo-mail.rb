#!/usr/bin/ruby
#encoding: utf-8

require 'mail'
require 'kconv'
require 'json'
require 'yaml'
require 'logger'
require '/home/possum/cogoo/cogoo-agent.rb'

LOG_FILE = "/home/possum/cogoo/log/log"
CONFIG_FILE = "/home/possum/cogoo/config.yaml"

logger = Logger.new(LOG_FILE)

config = YAML.load(File.open(CONFIG_FILE).read)

message = STDIN.read
req_mail = Mail.read_from_string(message)
from_address = req_mail.from.first
subject = req_mail.subject.strip

logger.debug "from: #{from_address}"
logger.debug "subject: #{subject}"

if config['mail'] == from_address
  if /^\d+$/.match(subject)
    bike_name = subject
    cogoo = CogooAgent.new
    rent_msg = ""
    begin
      cogoo.login(config['mail'], config['password'])
      logger.debug "logged in COGOO."

      bike = cogoo.get_bike(bike_name, 10002)
      logger.debug "bike name: #{bike_name}, is_rented: #{bike['is_rented']}"
      rent_data = cogoo.rent(bike)
      logger.debug "start: #{rent_data['start_time']}, password: #{rent_data['password']}"
      start_time = DateTime.strptime(rent_data['start_time'].to_s+"JST", "%Y%m%d%H%M%S%Z")
      rent_msg = <<-EOS
Bike name:  #{rent_data['bicycle_name']}
Rent start: #{start_time.strftime("%F %T")}
Passcode:   #{rent_data['password']}

      EOS
    rescue =>err
      rent_msg = err.message
      logger.error err.message
    ensure
      cogoo.logout
      logger.debug "logged out COGOO."
    end

    Mail.deliver do
      from 'possum@kmc.gr.jp'
      to   from_address
      subject "cogoo agent"
      body rent_msg
    end
    logger.debug "sent mail."

  end
end

