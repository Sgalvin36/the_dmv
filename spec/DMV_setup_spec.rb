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

        it 'starts with no facilities' do
            expect(@DMV.facilities).to eq []
        end

        it 'can filter data' do
            facility_1 = {name: 'DMV Northwest Branch', address: '3698 W. 44th Avenue', address_2: 'Suite 315', city: 'Denver', state: 'CO', zip: '80211', phone: '(720) 865-4600'}
            expect(@DMV.filter_data(facility_1)).to be_an_instance_of Hash
        end

        it 'arranges all address info into single string' do
            facility_1 = {name: 'DMV Northwest Branch', address: '3698 W. 44th Avenue', address_2: 'Suite 315', city: 'Denver', state: 'CO', zip: '80211', phone: '(720) 865-4600'}
            sorted_data = @DMV.filter_data(facility_1)

            expect(sorted_data[:address]).to eq("3698 W. 44th Avenue Suite 315 Denver CO 80211")
        end

        it 'creates facilities from data set' do
            data_set = @dds.co_dmv_office_locations
            @DMV.create_facilities(data_set)
            expect(@DMV.facilities).to include Facility
            expect(@DMV.facilities.count).to eq 5
        end
    end
end