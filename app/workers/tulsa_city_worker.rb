require 'byebug'
require 'json'

class TulsaCityWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5, queue: :high
  sidekiq_throttle_as :tulsa_city 
  def self.perform(recordId,active)
    new().perform(recordId,active)
  end

  def perform(incidentRecordID,active)
     inmate = perform_inmate(incidentRecordID)

    inmate = inmate.map{|k,v| [k,v.strip]}.to_h
    tulsa_inmate =save_inmate(inmate,incidentRecordID,active)
    
     offense_json = perform_offense(tulsa_inmate.incidentRecordID)
     offense_json.each do |offense|
       offense = offense.map{|k,v| [k,v.strip]}.to_h
         tulsa_offense = save_offense(offense,tulsa_inmate)
         
        #inmate_record= ::TulsaCity::Inmate.new(inmate)
       
     end
  end

  def save_inmate(inmate_json,incidentRecordID,active)
    inmate = ::TulsaCity::Inmate.find_or_create_by(incidentRecordID:incidentRecordID )
    inmate.inmateId = inmate_json["inmateId"]
    inmate.firstName = inmate_json["firstName"]
    inmate.middleName = inmate_json["middleName"]
    inmate.lastName = inmate_json["lastName"]
    inmate.height = inmate_json["height"]
    inmate.weight = inmate_json["weight"]
    inmate.hairColor = inmate_json["hairColor"]
    inmate.eyeColor = inmate_json["eyeColor"]
    inmate.race = inmate_json["race"]
    inmate.gender = inmate_json["gender"]
    inmate.arrestDate = inmate_json["arrestDate"]
    inmate.arrestingOfficer = inmate_json["arrestingOfficer"]
    inmate.arrestingAgency = inmate_json["arrestingAgency"]
    inmate.bookingDateTime = inmate_json["bookingDateTime"]
    inmate.releasedDateTime = inmate_json["releasedDateTime"]
    inmate.courtDivision = inmate_json["courtDivision"]
    inmate.incidentRecordID = incidentRecordID
    inmate.dob = inmate_json["DOB"]
    inmate.active = active
    inmate.save!
    inmate

  end

  def save_offense(offense_json,inmate)
    offense = ::TulsaCity::Offense.find_or_create_by(docketId: offense_json["docketId"])
    offense.assign_attributes(offense_json)
    offense.inmate_id = inmate.id
    offense.save!
    offense


  end

  def perform_offense(dataId)
    #30010
    headers = {'Content-Type' => "application/json", 'charset'=>'UTF-8','Accept'=> '*/*'}
    offense_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/Incident.aspx/ServiceReference?dataId=#{dataId}"
    
    offenses = HTTParty.post(offense_url,:headers => headers)
    
    offense_json = JSON.parse(offenses["d"]["ReturnCode"])
    
    
   


  end

  def perform_inmate(dataId)
    headers = {'Content-Type' => "application/json", 'charset'=>'UTF-8','Accept'=> '*/*'}
    inmate_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/InmateInfo.aspx/ServiceReference?dataId=#{dataId}"
    
    inmate = HTTParty.post(inmate_url,:headers => headers)
    
    inmate_json = JSON.parse(inmate["d"]["ReturnCode"])
    
   


  end
end





