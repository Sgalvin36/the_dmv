require 'spec_helper'

RSpec.describe Registrant do
    before(:each) do
        @registrant_1 = Registrant.new('Bruce', 18, true )
        @registrant_2 = Registrant.new('Penny', 15 )
        @license_data = {:written=>false, :license=>false, :renewed=>false}
    end

    describe Registrant do
        it 'can initialize' do
            expect(@registrant_1).to be_an_instance_of Registrant
            expect(@registrant_2).to be_an_instance_of Registrant
        end
        
        it 'has a name' do
            expect(@registrant_1.name).to eq 'Bruce'
            expect(@registrant_2.name).to eq 'Penny'
        end

        it 'has an age' do
            expect(@registrant_1.age).to eq 18
            expect(@registrant_2.age).to eq 15
        end

        it 'has a permit' do
            expect(@registrant_1.permit?).to eq true
        end

        it 'defaults the permit to false' do
            expect(@registrant_2.permit?).to eq false
        end

        it 'can earn a permit' do
            expect(@registrant_2.permit?).to eq false

            @registrant_2.earn_permit
            expect(@registrant_2.permit?).to eq true
        end

        it 'does not change permit status if already earned' do
            expect(@registrant_1.permit?).to eq true

            @registrant_1.earn_permit
            expect(@registrant_1.permit?).to eq true
        end

        it 'has license data' do
            expect(@registrant_1.license_data).to eq @license_data
            expect(@registrant_1.license_data).to eq @license_data
        end
    end
end