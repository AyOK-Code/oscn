require 'rails_helper'

RSpec.describe EvictionLetter, type: :model do
  describe 'associations' do
    it { should belong_to(:docket_event_link) }
    it { should belong_to(:eviction_file).optional }
  end

  describe 'class_methods' do
    describe '.missing_address_validation' do
      it 'returns letters that have not been validated' do
        eviction_letter = create(:eviction_letter, is_validated: false)
        create(:eviction_letter, is_validated: true)

        expect(described_class.missing_address_validation).to eq([eviction_letter])
      end
    end

    describe '.has_address_validation' do
      it 'returns letters that have been validated' do
        create(:eviction_letter, is_validated: false)
        eviction_letter = create(:eviction_letter, is_validated: true)

        expect(described_class.has_address_validation).to eq([eviction_letter])
      end
    end

    describe '.missing_extraction' do
      it 'returns letters that have not been extracted' do
        eviction_letter = create(:eviction_letter, ocr_plaintiff_address: nil)
        create(:eviction_letter, ocr_plaintiff_address: '123 Main St')

        expect(described_class.missing_extraction).to eq([eviction_letter])
      end
    end

    describe '.has_extraction' do
      it 'returns letters that have been extracted' do
        create(:eviction_letter, ocr_plaintiff_address: nil)
        eviction_letter = create(:eviction_letter, ocr_plaintiff_address: '123 Main St')

        expect(described_class.has_extraction).to eq([eviction_letter])
      end
    end

    describe '.past_thirty_days' do
      it 'returns letters that have been created in the past 30 days' do
        docket_event = create(:docket_event, event_on: 20.days.ago)
        docket_event_link = create(:docket_event_link, docket_event_id: docket_event.id)
        eviction_letter = create(:eviction_letter, docket_event_link_id: docket_event_link.id)

        expect(described_class.past_thirty_days).to eq([eviction_letter])
      end

      it 'does not return letters that have been created more than 30 days ago' do
        docket_event = create(:docket_event, event_on: 40.days.ago)
        docket_event_link = create(:docket_event_link, docket_event_id: docket_event.id)
        create(:eviction_letter, docket_event_link_id: docket_event_link.id)

        expect(described_class.past_thirty_days).to eq([])
      end
    end

    describe '.calculate_dates' do
      context 'when monday' do
        it 'returns the start and finish dates' do
          travel_to Date.new(2024, 2, 19) do
            expected_start = Date.new(2024, 2, 16)
            expected_finish = Date.new(2024, 2, 18)

            result = described_class.calculate_dates(Date.today)

            expect(result[:start]).to eq expected_start
            expect(result[:finish]).to eq expected_finish
          end
        end
      end

      context 'when wednesday' do
        it 'returns the start and finish dates' do
          travel_to Date.new(2024, 2, 21) do
            expected_start = Date.new(2024, 2, 19)
            expected_finish = Date.new(2024, 2, 20)

            result = described_class.calculate_dates(Date.today)

            expect(result[:start]).to eq expected_start
            expect(result[:finish]).to eq expected_finish
          end
        end
      end

      context 'when friday' do
        it 'returns the start and finish dates' do
          travel_to Date.new(2024, 2, 23) do
            expected_start = Date.new(2024, 2, 21)
            expected_finish = Date.new(2024, 2, 22)

            result = described_class.calculate_dates(Date.today)

            expect(result[:start]).to eq expected_start
            expect(result[:finish]).to eq expected_finish
          end
        end
      end

      context 'when tuesday, thursday, saturday, sunday' do
        it 'raises an error' do
          travel_to Date.new(2024, 2, 20) do
            expect do
              described_class.calculate_dates(Date.today)
            end.to raise_error('Invalid date: mailer only happens on M, W, F')
          end
        end
      end
    end

    describe '.file_pull' do
      context 'when has file' do
        it 'returns letters that have not been mailed' do
          travel_to Date.new(2024, 2, 19) do
            days = (1..3).to_a.sample
            court_case = create(:court_case, filed_on: days.days.ago)
            docket_event = create(:docket_event, court_case: court_case)
            docket_event_link = create(:docket_event_link, docket_event: docket_event)
            file = create(:eviction_file)
            create(:eviction_letter, docket_event_link: docket_event_link, eviction_file: file)

            expect(described_class.file_pull(Date.today)).to eq([])
          end
        end
      end

      context 'when has no zip code' do
        it 'returns letters that have not been mailed' do
          travel_to Date.new(2024, 2, 19) do
            days = (1..3).to_a.sample
            court_case = create(:court_case, filed_on: days.days.ago)
            docket_event = create(:docket_event, court_case: court_case)
            docket_event_link = create(:docket_event_link, docket_event: docket_event)
            create(:eviction_letter, docket_event_link: docket_event_link, validation_zip_code: nil)

            expect(described_class.file_pull(Date.today)).to eq([])
          end
        end
      end

      context 'when has incomplete address' do
        it 'does not return short addresses' do
          travel_to Date.new(2024, 2, 19) do
            days = (1..3).to_a.sample
            court_case = create(:court_case, filed_on: days.days.ago)
            docket_event = create(:docket_event, court_case: court_case)
            docket_event_link = create(:docket_event_link, docket_event: docket_event)
            create(:eviction_letter, docket_event_link: docket_event_link, validation_usps_address: '123 Main St')

            expect(described_class.file_pull(Date.today)).to eq([])
          end
        end
      end

      context 'when monday' do
        it 'returns letters from F, Sa, Su on Monday' do
          travel_to Date.new(2024, 2, 19) do
            days = (1..3).to_a.sample
            court_case = create(:court_case, filed_on: days.days.ago)
            docket_event = create(:docket_event, court_case: court_case)
            docket_event_link = create(:docket_event_link, docket_event: docket_event)
            eviction_letter = create(:eviction_letter, :with_zip_code, :with_address, docket_event_link: docket_event_link)

            expect(described_class.file_pull(Date.today)).to eq([eviction_letter])
          end
        end

        it 'does not return letters from other days' do
          travel_to Date.new(2024, 2, 19) do
            days = (4..6).to_a.sample
            create(:court_case, filed_on: days.days.ago)

            expect(described_class.file_pull(Date.today)).to eq([])
          end
        end
      end

      context 'when wednesday' do
        it 'returns letters from M, Tu' do
          travel_to Date.new(2024, 2, 21) do
            days = (1..2).to_a.sample
            court_case = create(:court_case, filed_on: days.days.ago)
            docket_event = create(:docket_event, court_case: court_case)
            docket_event_link = create(:docket_event_link, docket_event: docket_event)
            eviction_letter = create(:eviction_letter, :with_zip_code, :with_address, docket_event_link: docket_event_link)

            expect(described_class.file_pull(Date.today)).to eq([eviction_letter])
          end
        end

        it 'does not return letters from other days' do
          travel_to Date.new(2024, 2, 21) do
            days = (3..6).to_a.sample
            create(:court_case, filed_on: days.days.ago)

            expect(described_class.file_pull(Date.today)).to eq([])
          end
        end
      end

      context 'when friday' do
        it 'returns letters from W, Th' do
          travel_to Date.new(2024, 2, 23) do
            days = (1..2).to_a.sample
            court_case = create(:court_case, filed_on: days.days.ago)
            docket_event = create(:docket_event, court_case: court_case)
            docket_event_link = create(:docket_event_link, docket_event: docket_event)
            eviction_letter = create(:eviction_letter, :with_zip_code, :with_address, docket_event_link: docket_event_link)

            expect(described_class.file_pull(Date.today)).to eq([eviction_letter])
          end
        end

        it 'does not return letters from other days' do
          travel_to Date.new(2024, 2, 23) do
            days = (3..6).to_a.sample
            create(:court_case, filed_on: days.days.ago)

            expect(described_class.file_pull(Date.today)).to eq([])
          end
        end
      end

      context 'when tuesday, thursday, saturday, sunday' do
        it 'raises an error' do
          travel_to Date.new(2024, 2, 20) do
            expect do
              described_class.file_pull(Date.today)
            end.to raise_error('Invalid date: mailer only happens on M, W, F')
          end
        end
      end
    end
  end

  describe '#full_name' do
    it 'returns the defendants full_name' do
      court_case = create(:court_case)
      docket_event = create(:docket_event, court_case: court_case)
      defendant = create(:party, :defendant)
      create(:case_party, court_case: court_case, party: defendant)
      docket_event_link = create(:docket_event_link, docket_event: docket_event)
      eviction_letter = create(:eviction_letter, docket_event_link: docket_event_link)

      expect(eviction_letter.full_name).to eq(defendant.full_name)
    end

    it 'returns multiple defendants full_name seperated by a comma' do
      court_case = create(:court_case)
      docket_event = create(:docket_event, court_case: court_case)
      defendant1 = create(:party, :defendant)
      create(:case_party, court_case: court_case, party: defendant1)
      defendant2 = create(:party, :defendant)
      create(:case_party, court_case: court_case, party: defendant2)
      docket_event_link = create(:docket_event_link, docket_event: docket_event)
      eviction_letter = create(:eviction_letter, docket_event_link: docket_event_link)

      expect(eviction_letter.full_name).to include(defendant1.full_name)
      expect(eviction_letter.full_name).to include(defendant2.full_name)
    end
  end

  describe '#missing_address_validation' do
    it 'returns letters that have not been validated' do
      eviction_letter = create(:eviction_letter, is_validated: false)
      create(:eviction_letter, is_validated: true)

      expect(described_class.missing_address_validation).to eq([eviction_letter])
    end
  end

  describe '#has_address_validation' do
    it 'returns letters that have been validated' do
      create(:eviction_letter, is_validated: false)
      eviction_letter = create(:eviction_letter, is_validated: true)

      expect(described_class.has_address_validation).to eq([eviction_letter])
    end
  end

  describe '#missing_extraction' do
    it 'returns letters that have not been extracted' do
      eviction_letter = create(:eviction_letter, ocr_plaintiff_address: nil)
      create(:eviction_letter, ocr_plaintiff_address: '123 Main St')

      expect(described_class.missing_extraction).to eq([eviction_letter])
    end
  end

  describe '#has_extraction' do
    it 'returns letters that have been extracted' do
      create(:eviction_letter, ocr_plaintiff_address: nil)
      eviction_letter = create(:eviction_letter, ocr_plaintiff_address: '123 Main St')

      expect(described_class.has_extraction).to eq([eviction_letter])
    end
  end

  describe '#past_thirty_days' do
    it 'returns letters that have been created in the past 30 days' do
      docket_event = create(:docket_event, event_on: 20.days.ago)
      docket_event_link = create(:docket_event_link, docket_event_id: docket_event.id)
      eviction_letter = create(:eviction_letter, docket_event_link_id: docket_event_link.id)

      expect(described_class.past_thirty_days).to eq([eviction_letter])
    end

    it 'does not return letters that have been created more than 30 days ago' do
      docket_event = create(:docket_event, event_on: 40.days.ago)
      docket_event_link = create(:docket_event_link, docket_event_id: docket_event.id)
      create(:eviction_letter, docket_event_link_id: docket_event_link.id)

      expect(described_class.past_thirty_days).to eq([])
    end
  end
end
