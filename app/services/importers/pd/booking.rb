module Importers
  module Pd
    class Booking < ApplicationService
      def initialize(booking_json)
        @booking_json = booking_json
        @arrest_dt = "#{@booking_json['arrestDate'].split('T')[0]}T#{@booking_json['arrestTime'].split('T')[-1]}"
        @booking_dt = "#{@booking_json['bookingDate'].split('T')[0]}T#{@booking_json['bookingTime'].split('T')[-1]}"
        @release_dt = "#{@booking_json['releaseDate'].split('T')[0]}T#{@booking_json['releaseTime'].split('T')[-1]}"
        super()
      end

      def self.perform(booking_json)
        new(booking_json).perform
      end

      def perform
        trustees = @booking_json['bookingTrustees']
        notes = @booking_json['bookingNotes']
        alerts = @booking_json['bookingAlerts']
        level = @booking_json['custodyLevel']
        server = @booking_json['weekendServer']
        cell = @booking_json['assignedCellId']
        loc = @booking_json['currentLocation']

        extra_params = [trustees, notes, alerts, level, server, cell, loc]
        booking = ::Pd::Booking.find_or_initialize_by(id: @booking_json['bookingId'])
        booking.assign_attributes(get_attributes(@booking_json, extra_params))

        booking.save!
      end

      def get_attributes(booking_json, exp)
        {
          jailnet_inmate_id: booking_json['inmateId'], initial_docket_id: booking_json['initialDocketId'],
          inmate_name: booking_json['inmateName'], inmate_aka: booking_json['inmateAka'],
          birth_date: booking_json['birthDate'], city_of_birth: booking_json['cityOfBirth'],
          state_of_birth: booking_json['stateOfBirth'], current_age: booking_json['currentAge'],
          race: booking_json['race'], gender: booking_json['gender'], height: booking_json['height'],
          weight: booking_json['weight'], hair_color: booking_json['hairColor'],
          eye_color: booking_json['eyeColor'], build: booking_json['build'],
          complexion: booking_json['complexion'], facial_hair: booking_json['facialHair'],
          martial_status: booking_json['maritalStatus'], emergency_contact: booking_json['emergencyContact'],
          emergency_phone: booking_json['emergencyPhone'], drivers_state: booking_json['driversState'],
          drivers_license: booking_json['driversLicense'], address1: booking_json['address1'],
          address2: booking_json['address2'], city: booking_json['city'],
          state: booking_json['state'], zip_code: booking_json['zipCode'],
          home_phone: booking_json['homePhone'], fbi_nbr: booking_json['fbiNbr'],
          osbi_nbr: booking_json['osbiNbr'], tpd_nbr: booking_json['tpdNbr'],
          age_at_booking: booking_json['ageAtBooking'], age_at_release: booking_json['ageAtRelease'],
          arrest_date: @arrest_dt, arrest_by: booking_json['arrestBy'],
          agency: booking_json['agency'], booking_date: @booking_dt,
          booking_by: booking_json['bookingBy'], otn_nbr: booking_json['otnNbr'],
          estimated_release_date: booking_json['estimatedReleaseDate'], release_date: @release_DT,
          release_by: booking_json['releaseBy'], release_reason: booking_json['releaseReason'],
          weekend_server: exp[4], custody_level: exp[3], assigned_cell_id: exp[5], current_location: exp[6],
          booking_notes: exp[1], booking_alerts: exp[2], booking_trustees: exp[0]
        }
      end
    end
  end
end
