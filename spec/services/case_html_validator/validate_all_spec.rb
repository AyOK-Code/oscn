require 'rails_helper'

RSpec.describe CaseHtmlValidator::ValidateAll do
  it 'successfully validates html' do
    described_class.perform(from_fixture: true)
  end
end
