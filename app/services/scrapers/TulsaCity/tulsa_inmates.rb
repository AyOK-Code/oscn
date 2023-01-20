require 'byebug'
require 'json'
module Scrapers
module TulsaCity
  class TulsaInmates
    attr_reader :inmates_json

    def initialize()
      @inmates =[]
      
      @inmates_json = []
    end
    def self.perform
      new().perform
    end


    def self.perform_inmates
      new().perform_inmates
    end

    def self.perform_offense(dataId)
      new().perform_offense(dataId)
    end

    def self.perform_inmate(dataId)
      new().perform_inmate(dataId)
    end

    def perform
      
      
      inmate_json = perform_inmates
      bar = ProgressBar.new(inmate_json.count)
      inmate_json.each do |inmate|
        TulsaCityWorker
        .set(queue: :high)
        .perform_async(inmate['IncidentRecordID'],inmate['active'])
        bar.increment!
        
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
    def perform_inmates
      headers = {'Content-Type' => "application/json", 'charset'=>'UTF-8','Accept'=> '*/*'}
      inmates_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/CompleteInmates.aspx/ServiceReference"
      
      inmates = HTTParty.post(inmates_url,:headers => headers)
      
      inmates_json = JSON.parse(inmates["d"]["ReturnCode"])
  
      
     


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
end
end