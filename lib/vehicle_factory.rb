class VehicleFactory
    attr_reader :vehicle_lot
    
    def initialize
        @vehicle_lot = []
    end

    def create_vehicles(vehicle_data)
        vehicle_data.each do |vehicle|
            filtered_data = filter_data(vehicle)
            @vehicle_lot << Vehicle.new(filtered_data)
        end
    end

    def filter_data(data)
        filtered_set = {}
        data.each_pair do |key, value|
          if key.to_s.include?("vin") || key == :vin
            filtered_set[:vin] = value
          elsif key.to_s.include?("model_year") || key == :year
            filtered_set[:year] = value
          elsif key == :make
            filtered_set[:make] = value
          elsif key == :model
            filtered_set[:model] = value
          elsif key.to_s.include?("electric") || key == :engine
            filtered_set[:engine] = :ev
          end
        end
        filtered_set
    end
end