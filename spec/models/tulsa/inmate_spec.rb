require 'rails_helper'

RSpec.describe TulsaBlotter::Inmate, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first) }
    it { should validate_presence_of(:middle) }
    it { should validate_presence_of(:last) }
    it { should validate_presence_of(:gender) }
  end

  describe 'associations' do
    it { should belong_to(:roster).class_name('Roster').optional }
    it { should have_many(:arrests).class_name('TulsaBlotter::Arrest') }
    it { should have_and_belong_to_many(:page_htmls).class_name('TulsaBlotter::PageHtml') }
    it { should have_one(:inmate_details_html).class_name('TulsaBlotter::InmateDetailsHtml') }
  end
end
