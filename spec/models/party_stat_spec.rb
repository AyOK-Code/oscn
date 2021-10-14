require 'rails_helper'

RSpec.describe PartyStat, type: :model do
  context 'associations' do
    it { should belong_to(:party) }
  end

  describe 'view data' do
    it 'counts the number of court cases for a party' do
      skip
    end

    it 'counts the number of cf cases for a party' do
      skip
    end

    it 'counts the number of cm cases for a party' do
      skip
    end

    it 'counts the number of warrants issued for a party' do
      skip
    end

    it 'calculates the total amount fined' do
      skip
    end

    it 'calculates the total amount paid' do
      skip
    end

    it 'calculates the total amount adjusted' do
      skip
    end

    it 'calculates the account_balance' do
      skip
    end
  end
end
