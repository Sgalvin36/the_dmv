require './spec/spec_helper'
require './lib/DMV_setup'

RSpec.describe DMVSetup do
    before(:each) do
        @dds = DmvDataService.new
        @DMV = DMVSetup.new
    end

    describe '#initialize' do
        it 'can initialize' do
            expect(@DMV).to be_an_instance_of(DMVSetup)
        end
    end
end