require 'rails_helper'

RSpec.describe Roster, type: :model do
  describe 'associations' do
    it { should have_many(:bookings).class_name('OkcBlotter::Booking').with_foreign_key('roster_id').optional}
    it { should have_many(:case_parties).class_name('CaseParty').with_foreign_key('roster_id').optional}
    it { should have_many(:doc_profiles).class_name('Doc::Profile').with_foreign_key('roster_id').optional}
  end
  
end
