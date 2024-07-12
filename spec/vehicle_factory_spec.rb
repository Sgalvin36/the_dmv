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
    end
end