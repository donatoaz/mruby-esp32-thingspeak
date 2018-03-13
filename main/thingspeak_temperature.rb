#include ESP32::DS18B20

class ThingSpeak
  attr_reader :channel, :api_key
  def initialize(chn, key)
    @channel = chn
    @api_key = key
  end

  def post_value(value)
    body = "field1=#{value}"

    soc = TCPSocket.open("api.thingspeak.com", 80)
    msg =  "POST /update HTTP/1.1\r\n"
    msg += "Host: api.thingspeak.com\r\n"
    msg += "User-agent: ESP32 (donatoaz/1.0)\r\n"
    msg += "Connection: close\r\n"
    msg += "X-THINGSPEAKAPIKEY: #{self.api_key}\r\n"
    msg += "Content-Type: application/x-www-form-urlencoded\r\n"
    msg += "Content-Length: #{body.length}\r\n\r\n"
    msg += "#{body}"
    msg.split("\r\n").each do |e|
      puts ">>> #{e}"
    end
    soc.send(msg, 0)
    puts "- response ---------------------------------------------------------------------"
    loop do
        buf = soc.recv(128, 0)
        break if buf.length == 0
        print buf
    end
    puts ""
    puts "--------------------------------------------------------------------------------"
  end
end

ts = ThingSpeak.new('refrigerator', ENV['THINGSPEAK_API_KEY'])

sen = ESP32::DS18B20::Sensor.new(14)
sen.init

# delay 5 seconds before taking temperatures -- avoids brownout error on ESP32
ESP32::System.delay(5000)

temperature = sen.get_temp
puts "Current temperature is #{temperature}"

wifi = ESP32::WiFi.new

wifi.on_connected do |ip|
  ts.post_value( sen.get_temp )
end

wifi.on_disconnected do
  puts "Wi-Fi Disconnected"
end

puts "Connecting to Wi-Fi"
wifi.connect('Facta', 'facta2018')

# Sleep for a while, then reboot to prevent out of memory problems
while true do
  puts "waiting for temperature to be posted"
  if temperature_posted
    puts "System rebooting..."
    ESP32::System.delay(10 * 1000)
  end
end
