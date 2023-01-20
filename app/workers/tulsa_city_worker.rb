require 'byebug'
require 'json'

class TulsaCityWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5, queue: :high
  sidekiq_throttle_as :tulsa_city
  def self.perform(recordid, active)
    new.perform(recordid, active)
  end

  def perform(incidentrecordid, active)
    inmate = perform_inmate(incidentrecordid)

    inmate = inmate.transform_values(&:strip)
    tulsa_inmate = save_inmate(inmate, incidentrecordid, active)

    offense_json = perform_offense(tulsa_inmate.incident_record_id)
    offense_json.each do |offense|
      offense = offense.transform_values(&:strip)
      save_offense(offense, tulsa_inmate)
    end
  end

  def save_inmate(inmate_json, incidentrecordid, active)
    inmate = ::TulsaCity::Inmate.find_or_create_by(incident_record_id: incidentrecordid)
    inmate.inmate_id = inmate_json['inmateId']
    inmate.first_name = inmate_json['firstName']
    inmate.middle_name = inmate_json['middleName']
    inmate.last_name = inmate_json['lastName']
    inmate.height = inmate_json['height']
    inmate.weight = inmate_json['weight']
    inmate.hair_color = inmate_json['hairColor']
    inmate.eye_color = inmate_json['eyeColor']
    inmate.race = inmate_json['race']
    inmate.gender = inmate_json['gender']
    inmate.arrest_date = inmate_json['arrestDate']
    inmate.arresting_officer = inmate_json['arrestingOfficer']
    inmate.arresting_agency = inmate_json['arrestingAgency']
    inmate.booking_date_time = inmate_json['bookingDateTime']
    inmate.court_date = inmate_json['CourtDate']
    inmate.released_date_time = inmate_json['releasedDateTime']
    inmate.court_division = inmate_json['courtDivision']
    inmate.incident_record_id = incidentrecordid
    inmate.dob = inmate_json['DOB']
    inmate.active = active
    inmate.save!
    inmate
  end

  def save_offense(offense_json, inmate)
    offense = ::TulsaCity::Offense.find_or_create_by(docket_id: offense_json['docketId'])
    offense.bond = offense_json['bond']
    offense.court_date = offense_json['courtDate']
    offense.case_number = offense_json['caseNumber']
    offense.court_division = offense_json['courtDivision']
    offense.hold = offense_json['hold']
    offense.docket_id = offense_json['docketId']
    offense.title = offense_json['title']
    offense.section = offense_json['section']
    offense.paragraph = offense_json['paragraph']
    offense.crime = offense_json['crime']

    offense.inmate_id = inmate.id
    offense.save!
    offense
  end

  def perform_offense(dataid)
    # 30010
    headers = { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'Accept' => '*/*' }
    offense_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/Incident.aspx/ServiceReference?dataId=#{dataid}"

    offenses = HTTParty.post(offense_url, headers: headers)

    JSON.parse(offenses['d']['ReturnCode'])
  end

  def perform_inmate(dataid)
    headers = { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'Accept' => '*/*' }
    inmate_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/InmateInfo.aspx/ServiceReference?dataId=#{dataid}"

    inmate = HTTParty.post(inmate_url, headers: headers)

    JSON.parse(inmate['d']['ReturnCode'])
  end
end
