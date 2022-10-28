class OkcBlotter::Offense < ApplicationRecord
  belongs_to :booking, class_name: 'OkcBlotter::Booking'

  class ::ActiveRecord::Base
    # disable STI to allow columns named "type"
    self.inheritance_column = :_type_disabled
  end
end
