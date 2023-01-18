require 'httparty'
require 'json'

class HolidayAPI
    def self.get_response
        @response = HTTParty.get 'https://date.nager.at/api/v3/NextPublicHolidays/US'
        JSON.parse(@response.body, symbolize_names: true)
    end
end