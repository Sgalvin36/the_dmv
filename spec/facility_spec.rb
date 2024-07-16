require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
    @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
    @facility_3 = Facility.new({name: 'DMV Northwest Branch', address: '3698 W. 44th Avenue Denver CO 80211', phone: '(720) 865-4600'})
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility_1).to be_an_instance_of(Facility)
      expect(@facility_1.name).to eq('DMV Tremont Branch')
      expect(@facility_1.address).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
      expect(@facility_1.phone).to eq('(720) 865-4600')
      expect(@facility_1.services).to eq([])
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility_1.services).to eq([])
      @facility_1.add_service('New Drivers License')
      @facility_1.add_service('Renew Drivers License')
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

  describe '#register a vehicle' do
    it 'can register vehicles' do
      expect(@facility_1.services).to eq []
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.services).to include 'Vehicle Registration'
    end

    it 'adds registration info for the vehicle' do
      @facility_1.add_service('Vehicle Registration')
      expect(@cruz.registration_date).to be nil
      
      @facility_1.register_vehicle(@cruz)
      expect(@cruz.registration_date).to be_an_instance_of Time
    end

    it 'adds vehicle to registered vehicles list' do
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.registered_vehicles).to eq []

      @facility_1.register_vehicle(@cruz)
      expect(@facility_1.registered_vehicles).to include(Vehicle)
      expect(@facility_1.registered_vehicles.count).to eq 1

      @facility_1.register_vehicle(@bolt)
      @facility_1.register_vehicle(@camaro)
      expect(@facility_1.registered_vehicles.count).to eq 3
      
    end

    it 'collects fees based off vehicle type and age' do
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.collected_fees).to eq 0

      @facility_1.register_vehicle(@cruz)
      expect(@facility_1.collected_fees).to eq 100

      @facility_1.register_vehicle(@bolt)
      expect(@facility_1.collected_fees).to eq 300

      @facility_1.register_vehicle(@camaro)
      expect(@facility_1.collected_fees).to eq 325
    end

    it 'assigns a plate_type to the registered vehicle' do
      @facility_1.add_service('Vehicle Registration')
      expect(@cruz.plate_type).to eq :temp

      @facility_1.register_vehicle(@cruz)
      expect(@cruz.plate_type).to eq :regular

      @facility_1.register_vehicle(@bolt)
      expect(@bolt.plate_type).to eq :ev

      @facility_1.register_vehicle(@camaro)
      expect(@camaro.plate_type).to eq :antique
    end
      

    it 'only registers each vehicle once regardless of facility' do
      @facility_1.add_service('Vehicle Registration')
      @facility_2.add_service('Vehicle Registration')
      expect(@cruz.registration_date).to be nil

      @facility_1.register_vehicle(@cruz)
      expect(@facility_1.registered_vehicles).to include @cruz

      @facility_2.register_vehicle(@cruz)
      expect(@facility_2.registered_vehicles).to eq []
    end

    it 'cannot register vehicles if it doesnot have the service' do
      @facility_1.register_vehicle(@cruz)
      expect(@facility_1.services).to eq []
      expect(@facility_1.registered_vehicles).to eq []
      expect(@facility_1.collected_fees).to eq 0
      expect(@cruz.registration_date).to be nil
    end 
  end

  describe 'getting a drivers license' do
    before (:each) do
      @registrant_1 = Registrant.new('Bruce', 18, true )
      @registrant_2 = Registrant.new('Penny', 16 )
      @registrant_3 = Registrant.new('Tucker', 15 )
    end

    describe '#administer a written test' do
      it 'can administer written test' do
        expect(@facility_1.services).to eq []
        @facility_1.add_service('Written Test')
        expect(@facility_1.services).to include 'Written Test'
      end

      it 'only administers written test for registrants with permit && facility has the service' do
        expect(@registrant_2.permit?).to eq false
        expect(@facility_1.administer_written_test(@registrant_2)).to eq false

        expect(@registrant_1.permit?).to eq true
        expect(@facility_1.administer_written_test(@registrant_1)).to eq false
        @facility_1.add_service('Written Test')
        expect(@facility_1.administer_written_test(@registrant_1)).to eq true        
      end

      it 'administers written test for registrants of age with permit' do
        @facility_1.add_service('Written Test')
        expect(@registrant_2.age).to eq 16
        expect(@registrant_2.permit?).to eq false
        expect(@facility_1.administer_written_test(@registrant_2)).to eq false
        
        @registrant_2.earn_permit
        expect(@registrant_2.permit?).to eq true
        expect(@facility_1.administer_written_test(@registrant_2)).to eq true
      end

      it ' does not administers written test for registrants not of age with permit' do
        @facility_1.add_service('Written Test')
        expect(@registrant_3.age).to eq 15
        expect(@registrant_3.permit?).to eq false
        expect(@facility_1.administer_written_test(@registrant_3)).to eq false
        
        @registrant_3.earn_permit
        expect(@registrant_3.permit?).to eq true
        expect(@facility_1.administer_written_test(@registrant_3)).to eq false
      end

      it 'updates the registrants license info if they pass the test' do
        @facility_1.add_service('Written Test')
        @facility_1.administer_written_test(@registrant_1)
        
        expect(@registrant_1.license_data[:written]).to eq true
      end
    end

    describe '#administer a road test' do
      before (:each) do
        @facility_1.add_service('Written Test')
      end

      it 'can administer road test' do
        expect(@facility_1.services).to eq ['Written Test']
        @facility_1.add_service('Road Test')
        expect(@facility_1.services).to include 'Road Test'
      end

      it 'only administers written test for registrants with written test && facility has the service' do
        expect(@registrant_1.license_data[:written]).to eq false
        expect(@facility_1.administer_road_test(@registrant_1)).to eq false

        @facility_1.administer_written_test(@registrant_1)
        expect(@registrant_1.license_data[:written]).to eq true
        expect(@facility_1.administer_road_test(@registrant_1)).to eq false
        @facility_1.add_service('Road Test')
        expect(@facility_1.administer_road_test(@registrant_1)).to eq true        
      end

      it 'updates the registrants license info if they pass the test' do
        @facility_1.add_service('Road Test')
        @facility_1.administer_written_test(@registrant_1)
        @facility_1.administer_road_test(@registrant_1)
        
        expect(@registrant_1.license_data[:license]).to eq true
      end
    end

    describe '#renew a drivers license' do
      before (:each) do
        @facility_1.add_service('Written Test')
        @facility_1.add_service('Road Test')
      end

      it 'can renew license' do
        expect(@facility_1.services).to eq ['Written Test', 'Road Test']
        @facility_1.add_service('Renew License')
        expect(@facility_1.services).to include 'Renew License'
        expect(@facility_1.services.count).to eq 3

      end

      it 'only renew if written and license are true in registrant data' do
        expect(@registrant_1.license_data[:renewed]).to eq false
        expect(@facility_1.renew_drivers_license(@registrant_1)).to eq false

        @facility_1.administer_written_test(@registrant_1)
        @facility_1.administer_road_test(@registrant_1)
        expect(@registrant_1.license_data[:written]).to eq true
        expect(@registrant_1.license_data[:license]).to eq true

        expect(@facility_1.renew_drivers_license(@registrant_1)).to eq false
        @facility_1.add_service('Renew License')
        expect(@facility_1.renew_drivers_license(@registrant_1)).to eq true        
      end

      it 'updates the registrants license info if they renew' do
        @facility_1.add_service('Renew License')
        @facility_1.administer_written_test(@registrant_1)
        @facility_1.administer_road_test(@registrant_1)
        @facility_1.renew_drivers_license(@registrant_1)
        expect(@registrant_1.license_data[:renewed]).to eq true
      end
    end
  end

  describe 'analysing registration data' do
    before(:each) do
      @vehicle_collection = DmvDataService.new.wa_ev_registrations
      @factory = VehicleFactory.new
      @factory.create_vehicles(@vehicle_collection)
      @vehicles_to_be_registered = @factory.vehicle_lot
      @facility_1.add_service('Vehicle Registration')
      @vehicles_to_be_registered.each do |vehicle|
        @facility_1.register_vehicle(vehicle)
      end
      
    end

    it 'registeres all vehicles from data set' do
      expect(@facility_1.registered_vehicles.count).to eq 1000
      expect(@facility_1.registered_vehicles). to include Vehicle
    end

    it 'can generate an array of all values matching a specific attribute' do
      expect(@facility_1.all_of_one_attribute('year')).to be_an_instance_of Array
      expect(@facility_1.all_of_one_attribute('year').count).to eq 1000
    end

    it 'can show list of unique values per key' do
      # require 'pry';binding.pry
      expect(@facility_1.unique_types('year')).to be_an_instance_of Array
      expect(@facility_1.unique_types('year').count).to eq 14
      p @facility_1.unique_types('year').sort
    end

    it 'can reveal how many instances of a specific value there are' do
      expect(@facility_1.quantity_unique_types('year')).to be_an_instance_of Hash
      expect(@facility_1.quantity_unique_types('year').count).to eq 14
      p @facility_1.quantity_unique_types('year')
    end

    it 'can reveal other information for vehicle registration' do
      expect(@facility_1.quantity_unique_types('model')).to be_an_instance_of Hash
      expect(@facility_1.quantity_unique_types('model').count).to eq 67
      expect(@facility_1.quantity_unique_types('make')).to be_an_instance_of Hash
      expect(@facility_1.quantity_unique_types('make').count).to eq 27
    end
  end
end
