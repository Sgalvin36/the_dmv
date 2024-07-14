require './spec/spec_helper'
require './lib/vehicle_factory'

RSpec.describe VehicleFactory do
    before(:each) do
        @dds = DmvDataService.new
        @vf = VehicleFactory.new
    end

    describe '#initialize' do
        it 'can initialize' do
            expect(@vf).to be_an_instance_of(VehicleFactory)
        end

        it 'starts with an empty lot' do
            expect(@vf.vehicle_lot).to eq []
        end

        it 'creates vehicles from data' do
            cars = []
            cars.push({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice})
            cars.push({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev})
            @vf.create_vehicles(cars)

            expect(@vf.vehicle_lot.count).to eq 2
            expect(@vf.vehicle_lot).to include Vehicle
        end

        it 'can filter data' do
            vehicles = @dds.wa_ev_registrations
            filtered_data = @vf.filter_data(vehicles[12])

            expect(filtered_data).to eq({vin: '1G1FZ6S06P', year: "2023", make: 'CHEVROLET', model: 'Bolt EUV', engine: :ev})
        end

        it 'creates vehicles from external data' do
            vehicles = @dds.wa_ev_registrations
            @vf.create_vehicles(vehicles)

            expect(@vf.vehicle_lot.count).to eq 1000
            expect(@vf.vehicle_lot).to include Vehicle
            # require 'pry';binding.pry
        end
    end


end