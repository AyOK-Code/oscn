 module Importers
   module Doc
     class Statute
       attr_accessor :filename

       def initialize
         @filename = 'lib/data/Vendor_Offense_Extract_Text.dat'
       end

       def perform
         fields = [38,40,1]
         field_pattern = "A#{fields.join('A')}"
         bar = ProgressBar.new(File.read(filename).scan(/\n/).length)

         File.foreach(filename) do |line|
           bar.increment!
           row = line.unpack(field_pattern)
           data = row.map { |f| f.squish }

           statute = ::Doc::OffenseCode.find_or_initialize_by(
             statute_code: data[0],
             description: data[1],
             is_violent: data[2] === 'Y' ? true : false
           )
           statute.save!
         end
       end
     end
   end
 end
