class DMVSetup
    attr_reader :facilities

    def initialize
        @facilities = []
    end

    def create_facilities(facility_data)
        facility_data.each do |facility|
            filtered_data = filter_data(facility)
            @facilities << Facility.new(filtered_data)
        end
    end

    def filter_data(data)
        filtered_set = {}
        address_pair = {}
        data.each_pair do |key, value|
          if key.to_s.include?("office") || key == :name
            filtered_set[:name] = value
          elsif key.to_s.include?("phone") || key == :phone
            filtered_set[:phone] = value
          elsif key.to_s.include?("address") || key.to_s.include?("city") || key.to_s.include?("state") || key.to_s.include?("zip") 
            address_pair[(key.to_s)] = value
          end
        end
        address = address_config(address_pair)
        filtered_set[:address] = address
        filtered_set
    end

    def address_config(data)
        address_string = []
        data.each_pair do |key, value|
            if key.include?("city")
                address_string[2] = value
            elsif key.include?("state") 
                address_string[3] = value
            elsif key.include?("zip")
                address_string[4] = value
            elsif key.include?("address") && value.include?("Suite")
                address_string[1] = value
            elsif key.include?("address") && !(value.include?("Suite"))
                address_string[0] = value
            end
        end
        address_string.join(" ")
    end
end