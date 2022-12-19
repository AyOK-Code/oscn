class Parcel < ApplicationRecord
    validates :geoid20,:zip,:tract,:block, presence: true
end
