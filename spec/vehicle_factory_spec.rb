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

    describe '#work through different registration data' do
        before(:each) do
            @data_2 = @dds.ny_registrations
        end

        it 'can filter data' do
            filtered_data = @vf.filter_data(@data_2[0])

            expect(filtered_data).to eq({vin: '999999999999', year: "1975", make: 'STARC', model: 'BOAT', engine: "GAS"})
        end

        it 'creates vehicles from external data' do
            @vf.create_vehicles(@data_2)

            expect(@vf.vehicle_lot.count).to eq 1000
            expect(@vf.vehicle_lot).to include Vehicle
            # require 'pry';binding.pry
        end

        it 'has valid data for each iteration of vehicle' do
            @vf.create_vehicles(@data_2)
            @vf.vehicle_lot.each do |vehicle|
                expect(vehicle.vin).to be_truthy
                expect(vehicle.year).to be_truthy
                expect(vehicle.make).to be_truthy
                expect(vehicle.model).to be_truthy
                expect(vehicle.engine).to be_truthy
            end
        end
    end

end