require 'importers/court_case'
# Worker that scrapes the Case information and updates the database
# Ex: https://www.oscn.net/dockets/GetCaseInformation.aspx?db=tulsa&number=CF-2018-1016
class TulsaCityWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options retry: 5, queue: :high
  sidekiq_throttle_as :tulsa_city 

  def perform(IncidentRecordID)
     inmate = perform_inmate(IncidentRecordID)

    inmate = inmate.map{|k,v| [k,v.strip]}.to_h
    tulsa_inmate =save_inmate(inmate)
    
     offense_json = perform_offense(tulsa_inmate.IncidentRecordID)
     offense_json.each do |offense|
       offense = offense.map{|k,v| [k,v.strip]}.to_h
         tulsa_offense = save_offense(offense,tulsa_inmate)
         
        #inmate_record= ::TulsaCity::Inmate.new(inmate)
       
     end
  end

  def save_inmate(inmate_json)
    inmate = ::TulsaCity::Inmate.find_or_create_by(prisonerID: inmate_json["prisonerID"])
    inmate.assign_attributes(inmate_json)
    inmate.save!
    inmate

  end

  def save_offense(offense_json,inmate)
    offense = ::TulsaCity::Offense.find_or_create_by(docketId: offense_json["docketId"])
    offense.assign_attributes(offense_json)
    offense.tulsa_city_inmates_id = inmate.id
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
    #30010
    headers = {'Content-Type' => "application/json", 'charset'=>'UTF-8','Accept'=> '*/*'}
    inmate_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/InmateInfo.aspx/ServiceReference?dataId=#{dataId}"
    
    inmate = HTTParty.post(inmate_url,:headers => headers)
    
    inmate_json = JSON.parse(inmate["d"]["ReturnCode"])
    
   


  end
end





