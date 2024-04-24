require 'open-uri'
module Importers
  # Pulls accurate data from the OK Bar Association
  # TODO: Figure out refresh schedule
  class StructureFireLink
    def initialize(jsons)
      @jsons = jsons
    end

    def self.perform
      new(jsons).perform
    end

    def perform
      pdf_date_on = Date.strptime(@jsons[0][:pdf_date_on], '%m/%d/%Y')
      fire_link = ::StructureFireLink.find_or_initialize_by(url: @jsons[0][:url], pdf_date_on: pdf_date_on)
      unless @jsons[0][:filepath].nil?
        fire_link.pdf.attach(io: File.open(@jsons[0][:filepath]), filename: "#{@jsons[0][:filepath]}.pdf")
      end
      fire_link.save!
      fire_link
    end
  end
end
