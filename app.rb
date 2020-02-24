require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "ca4d3ae98d02f415fdf7793794f0f224"

get "/" do
  view "ask"
end

get "/news" do
results = Geocoder.search(params["q"])
    @lat_long = results.first.coordinates # => [lat, long]
    @location = results.first.city
# Define the lat and long
@lat = "#{@lat_long [0]}"
@long = "#{@lat_long [1]}"
# Results from Geocoder
@forecast = ForecastIO.forecast("#{@lat}" , "#{@long}").to_hash
@current_temperature = @forecast["currently"]["temperature"]
@current_conditions = @forecast["currently"]["summary"]
# high_temperature = forecast["daily"]["data"][0]["temperatureHigh"]
# puts high_temperature
# puts forecast["daily"]["data"][1]["temperatureHigh"]
# puts forecast["daily"]["data"][2]["temperatureHigh"]
@list = @daily_temperature, @daily_conditions, @daily_wind, @daily_humidity
# News API
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=afae5fdd78924eccb0923605a9ec71e9"
@news = HTTParty.get(url).parsed_response.to_hash
view "news"
end