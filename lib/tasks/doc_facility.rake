require 'open-uri'
require 'csv'

namespace :doc do
  desc 'fill out doc_facility table and link records to status and profile'
  task :doc_facilities do 
    csv_path = 'lib/Prison.Facilities-Table.1.csv'
    csv = []
    facil=Doc::Status.distinct.pluck(:facility)
    facil_prof=Doc::Profile.distinct.pluck(:facility)
    status_profile_facil = facil + facil_prof
    status_profile_facil = status_profile_facil.uniq

    
binding.pry

    CSV.foreach('lib/Prison.Facilities-Table.1.csv') do |row|
        
        next if row[0] == 'FACILITY'
        name= row[0]
        
        csv << name
      end
    

      status_profile_facil.each_with_index do |fac,index| 
        prison = false
         prison = csv.include? fac
         
         next  if  fac.blank? || fac.nil? 
          
         
        
         
         facility = DocFacility.find_or_initialize_by(name:fac, is_prison: prison)
         facility.save!
        
         status = Doc::Status.where(facility: fac).in_batches 
         
           status.update_all(doc_facility_id: facility.id)

        
         

         #includes(:doc_profiles) ?? status can only access doc_profiles_id, it belongs, doesnt have profiles. not sure how including them will help either, may be optional?
         profile = Doc::Profile.where(facility: fac).in_batches
        
    profile.update_all(doc_facility_id: facility.id)
          
            
         

        
    end
  end
end