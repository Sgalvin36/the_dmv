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

        it 'has all correct data for each facility' do
            data_set = @dds.co_dmv_office_locations
            @DMV.create_facilities(data_set)
            facility_1 = @DMV.facilities[0]
            expect(facility_1).to be_an_instance_of Facility
            expect(facility_1.name).to eq "DMV Tremont Branch"
            expect(facility_1.phone).to eq "(720) 865-4600"
            expect(facility_1.address).to eq "2855 Tremont Place Suite 118 Denver CO 80205"
            expect(facility_1.services).to eq []
        end

        it 'can filter data from multiple sets' do
            data_set = @dds.co_dmv_office_locations
            @DMV.create_facilities(data_set)
            expect(@DMV.facilities).to include Facility
            expect(@DMV.facilities.count).to eq 5

            data_set_2 = @dds.ny_dmv_office_locations
            @DMV.create_facilities(data_set_2)
            expect(@DMV.facilities.count).to eq 175
        end

        it 'has all correct data for New York facility' do
            data_set = @dds.co_dmv_office_locations
            @DMV.create_facilities(data_set)
            data_set_2 = @dds.ny_dmv_office_locations
            @DMV.create_facilities(data_set_2)

            facility_6 = @DMV.facilities[5]
            expect(facility_6).to be_an_instance_of Facility
            expect(facility_6.name).to eq "HUNTINGTON"
            expect(facility_6.phone).to eq "7184774820"
            expect(facility_6.address).to eq "1815 E JERICHO TURNPIKE  HUNTINGTON NY 11743"
            expect(facility_6.services).to eq []
        end
    end
end