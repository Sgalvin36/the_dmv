require 'spec_helper'

RSpec.describe Registrant do
    before(:each) do
        @registrant_1 = Registrant.new('Bruce', 18, true )
        @registrant_2 = Registrant.new('Penny', 15 )
    end

    describe Registrant do
        it 'exists' do
            expect(@registrant_1).to be_an_instance_of Registrant
            expect(@registrant_2).to be_an_instance_of Registrant
        end
        
        it 'can initialize' do
        end

        it 'has a name' do
        end

        it 'has an age' do
        end

        it 'has a permit' do
        end

        it 'has license data' do
        end
    end
end