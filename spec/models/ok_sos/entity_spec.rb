require 'rails_helper'

RSpec.describe OkSos::Entity, type: :model do
  it { should belong_to(:corp_type).class_name('OkSos::CorpType') }
  it { should belong_to(:entity_address).class_name('OkSos::EntityAddress').optional }
end
