class Facility
  attr_reader :name, :address, :phone, :services, :registered_vehicles, :collected_fees

  def initialize(hash_info)
    @name = hash_info[:name]
    @address = hash_info[:address]
    @phone = hash_info[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  def add_service(service)
    @services << service
  end

  def register_vehicle(vehicle)
    if @services.include?("Vehicle Registration") && vehicle.registration_date == nil
      @collected_fees += collect_fees(vehicle)
      @registered_vehicles << vehicle
      vehicle.registration_date = Time.new
    end
  end

  def collect_fees(vehicle)
    if vehicle.antique?
      vehicle.plate_type = :antique
      25
    elsif vehicle.electric_vehicle?
      vehicle.plate_type = :ev
      200
    else
      vehicle.plate_type = :regular
      100
    end
  end

  def administer_written_test(registrant)
    if @services.include?("Written Test") && registrant.permit? && registrant.age >= 16
      registrant.license_data[:written] = true
    else
      false
    end
  end

  def administer_road_test(registrant)
    if @services.include?("Road Test") && registrant.license_data[:written] == true
      registrant.license_data[:license] = true
    else
      false
    end
  end

  def renew_drivers_license(registrant)
    if @services.include?("Renew License") && registrant.license_data[:written] == true && registrant.license_data[:license] == true
      registrant.license_data[:renewed] = true
    else
      false
    end
  end

  
  def all_of_one_attribute(attribute)
    @all_types = []
    @registered_vehicles.each do |vehicle|
      @all_types << (vehicle.instance_variable_get("@#{attribute}"))
    end
    @all_types
  end
  def unique_types(attribute)
    @unique_types = all_of_one_attribute(attribute)
    @unique_types.uniq
  end

  # def quantity_unique_types(attribute)
  #   types = unique_types(attribute)
  #   types.each do |type|
  #     @registered_vehicles.find_all {|}
  #   end
  # end
end
