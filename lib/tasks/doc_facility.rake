require 'open-uri'
require 'csv'

namespace :doc do
  desc 'fill out doc_facility table and link records to status and profile'
  task :doc_facilities do 
    csv_path = 'lib/Prison.Facilities-Table.1.csv'
    csv = []
    facil=Doc::Status.distinct.pluck(:facility)

    CSV.foreach('lib/Prison.Facilities-Table.1.csv') do |row|
        
        next if row[0] == 'FACILITY'
        name= row[0]
        
        csv << name
      end
    

    facil.each_with_index do |fac,index| 
        prison = false
         prison = csv.include? fac
         
        unless fac.blank? || fac.nil?
         facility = DocFacility.find_or_initialize_by(name:fac, is_prison: prison)
         facility.save!
         
        else
         next
        end
         status = Doc::Status.find_by  facility: fac
         unless status.nil?
            status.update(doc_facility_id: facility.id)
         else
           
         end

         binding.pry
         profile = Doc::Profile.find_by  facility: fac
         unless status.nil?
            status.update(doc_facility_id: facility.id)
         else
            
         end

        
    end
  end
end