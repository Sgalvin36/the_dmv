require 'spec_helper'

RSpec.describe Dmv do
  before(:each) do
    @dmv = Dmv.new
    @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
    @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})
    @facility_3 = Facility.new({name: 'DMV Northwest Branch', address: '3698 W. 44th Avenue Denver CO 80211', phone: '(720) 865-4600'})
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
  end

  describe '#initialize' do
    it 'can initialize' do
      expect(@dmv).to be_an_instance_of(Dmv)
      expect(@dmv.facilities).to eq([])
    end
  end

  describe '#add facilities' do
    it 'can add available facilities' do
      expect(@dmv.facilities).to eq([])
      @dmv.add_facility(@facility_1)
      expect(@dmv.facilities).to eq([@facility_1])
    end
  end

  describe '#facilities_offering_service' do
    it 'can return list of facilities offering a specified Service' do
      @facility_1.add_service('New Drivers License')
      @facility_1.add_service('Renew Drivers License')
      @facility_2.add_service('New Drivers License')
      @facility_2.add_service('Road Test')
      @facility_2.add_service('Written Test')
      @facility_3.add_service('New Drivers License')
      @facility_3.add_service('Road Test')

      @dmv.add_facility(@facility_1)
      @dmv.add_facility(@facility_2)
      @dmv.add_facility(@facility_3)

      expect(@dmv.facilities_offering_service('Road Test')).to eq([@facility_2, @facility_3])
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
        expect(@facility_1.administer_written_test(@registrant_2)).to eq false
        @facility_1.add_service('Written Test')
        expect(@facility_1.administer_written_test(@registrant_2)).to eq true        
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
    end

    describe '#administer a road test' do
    end

    describe '#renew a drivers license' do
    end
  end
end
