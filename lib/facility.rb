class Facility
  attr_reader :name, :address, :phone, :services

  def initialize(hash_info)
    @name = hash_info[:name]
    @address = hash_info[:address]
    @phone = hash_info[:phone]
    @services = []
  end

  def add_services(service)
    @services << service
  end
end
