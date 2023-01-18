require 'holiday_api'

class Holiday
    attr_reader :name, :date

    def initialize(data)
        @name = data[:localName]
        @date = data[:date]
    end

    def self.next_three
        next_three = HolidayAPI.get_response.first(3)
        next_three.map{|data| self.new(data)}
    end
end