require 'rails_helper'

RSpec.describe Case, type: :model do
  context 'validations' do
    it { should validate_presence_of(:oscn_id) }
    it { should validate_presence_of(:case_number) }
    it { should validate_presence_of(:filed_on) }
  end

  context 'associations' do
    it { should belong_to(:county) }
    it { should belong_to(:case_type) }
  end

  context 'scopes' do
    describe '#with_html' do
      it 'only returns cases that have html' do
        with_html = create(:case, :with_html)
        without_html = create(:case)
        expect(described_class.with_html).to include with_html
        expect(described_class.with_html).to_not include without_html
      end
    end

    describe '#without_html' do
      it 'only returns cases that do not have html saved' do
        with_html = create(:case, :with_html)
        without_html = create(:case)
        expect(described_class.without_html).to include without_html
        expect(described_class.without_html).to_not include with_html
      end
    end
  end
end
