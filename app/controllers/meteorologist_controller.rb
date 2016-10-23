require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    @street_address_without_spaces = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the variable @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the variable @street_address_without_spaces.
    # ==========================================================================

    maps_url = "http://maps.googleapis.com/maps/api/geocode/json?address=" + @street_address_without_spaces
    maps_raw_data = open(maps_url).read
    maps_parsed_data = JSON.parse(maps_raw_data)

    latitude = maps_parsed_data["results"][0]["geometry"]["location"]["lat"]

    longitude = maps_parsed_data["results"][0]["geometry"]["location"]["lng"]

    @lat = latitude

    @lng = longitude

    weather_url = "https://api.darksky.net/forecast/fead32a0f3274e78b0ab1bc85669d994/" + @lat.to_s + "," + @lng.to_s
    weather_raw_data = open(weather_url).read
    weather_parsed_data = JSON.parse(weather_raw_data)

    @current_temperature = weather_parsed_data["currently"]["temperature"]

    @current_summary = weather_parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = weather_parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = weather_parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = weather_parsed_data["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
