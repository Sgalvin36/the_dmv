class Facility
  attr_reader :name, :address, :phone, :services, :registered_vehicles

  def initialize(hash_info)
    @name = hash_info[:name]
    @address = hash_info[:address]
    @phone = hash_info[:phone]
    @services = []
    @registered_vehicles = []
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle)
    if @services.include?("Vehicle Registration")
      vehicle.registration_date = Time.new
      @registered_vehicles << vehicle
    end
  end
end
