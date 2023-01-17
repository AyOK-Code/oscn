require 'byebug'
require 'json'
module Scrapers
  class TulsaInmates
    attr_reader :inmates_json

    def initialize()
      @inmates = nil
      @inmates_json = []
    end

    def self.perform_inmates
      new().perform_inmates
    end

    def self.perform_offense(dataId)
      new().perform_offense(dataId)
    end

    def perform_inmates
      headers = {'Content-Type' => "application/json", 'charset'=>'UTF-8','Accept'=> '*/*'}
      inmates_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/CompleteInmates.aspx/ServiceReference"
      
      inmates = HTTParty.post(inmates_url,:headers => headers)
      
      inmates_json = JSON.parse(inmates["d"]["ReturnCode"])
      binding.pry
     


    end

    def perform_offense(dataId)
      #30010
      headers = {'Content-Type' => "application/json", 'charset'=>'UTF-8','Accept'=> '*/*'}
      offense_url = "https://www.cityoftulsa.org/apps/InmateInformationCenter/AjaxReference/Incident.aspx/ServiceReference?dataId=#{dataId}"
      
      offenses = HTTParty.post(offense_url,:headers => headers)
      
      offense_json = JSON.parse(offenses["d"]["ReturnCode"])
      binding.pry
     


    end
   end
end