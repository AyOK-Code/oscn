require 'rails_helper'

RSpec.describe TulsaBlotter::Arrest, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:arrest_date) }
    it { should validate_presence_of(:arrested_by) }
    it { should validate_presence_of(:arresting_agency) }
  end

  describe 'associations' do
    it { should belong_to(:inmate).class_name('TulsaBlotter::Inmate') }
    it { should have_many(:offenses).class_name('TulsaBlotter::Offense') }
  end
end
