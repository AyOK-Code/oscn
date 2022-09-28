namespace :import do
    desc 'Import Tulsa Bookings'
    task tulsa_import: :environment do
      file = File.read('lib/tulsa_county_jail_bookings.csv')
      data = CSV.parse(file, headers: true)
      #data[636] OK
      #data[114] 2,1
      #data[46] 2 offenses 1 case number
      #Inmates: Last Name	First Name	Middle Name	Booking ID Gender	Inmate ID	Race	Address	City/State/Zip
      #Height	Weight	Hair Color	Eye Color
      #Arrests: Booking Date Arrest Date	Arrest Time	Arresting Agency	Arresting Officer
      #	Booking Time	Release Date	Release Time
      #Offenses:(description) 	Case Numbers	Court Dates	Bond Types	Bond Amounts	Dispositions
      data.each  do |row| 
       
        inmate =  TulsaBlotter::Inmate.create(dlm:row["Inmate ID"])
        inmate.first = row["First Name"]
        inmate.middle = row["Middle Name"]
        inmate.last = row["Last Name"]
        inmate.booking_id = row["Booking ID"]
        inmate.gender = row["Gender"]
        inmate.race = row["Race"]
        inmate.address = row["Address"]
        inmate.zip = row["City/State/Zip"]
        inmate.height = row["Height"]
        inmate.weight = row["Weight"]
        inmate.hair = row["Hair Color"]
        inmate.eyes = row["Eye Color"]
        inmate.last_scraped_at =  Date.strptime(row["Updated"], "%m/%d/%Y")
        inmate.mugshot = row["Mugshot"]
        
       # binding.pry

        arrest = TulsaBlotter::Arrest.create(arrested_by:row["Arresting Officer"])
        arrest.tulsa_blotter_inmates_id = inmate
        date =  Date.strptime(row["Arrest Date"], "%m/%d/%Y")
        time = row["Arrest Time"].to_time(:cst)
        dt = DateTime.new(date.year,date.month,date.day,time.hour,time.min)
        arrest.arrest_date = dt
        arrest.arresting_agency = row["Arresting Agency"]
        bdate =  Date.strptime(row["Booking Date"], "%m/%d/%Y")
        btime = row["Booking Time"].to_time(:cst)
        bdt = DateTime.new(bdate.year,bdate.month,bdate.day,btime.hour,btime.min)
        arrest.booking_date = bdt
        rdate =  Date.strptime(row["Release Date"], "%m/%d/%Y")
        rtime = row["Release Time"].to_time(:cst)
        rdt = DateTime.new(rdate.year,rdate.month,rdate.day,rtime.hour,rtime.min)
        arrest.release_date = rdt
        arrest.freedom_date =  Date.strptime(row["Freedom Date"], "%m/%d/%Y")
        

#Offenses:(description) 	Case Numbers	Court Dates	Bond Types	Bond Amounts	Dispositions
        row["Offenses"].sub! ', OK', ' OK'
        row["Offenses"].sub! ', TENNESSEE', ' TENNESSEE'
        descriptions= row["Offenses"].split(',')
        case_numbers = row["Case Numbers"].split(',')
        court_dates = row["Court Dates"].split(',')
        bond_types = row["Bond Types"].split(',')
        bond_amounts = row["Bond Amounts"].split(' ')
        dispositions = row["Dispositions"].split(',')
        
        descriptions.each_with_index do | desc, index |
            offense = TulsaBlotter::Offense.create(tulsa_blotter_arrests_id: arrest.id,description: desc,case_number:case_numbers[index],
                court_date: court_dates[index],bond_type: bond_types[index],bound_amount:bond_amounts[index],disposition: dispositions[index])
                binding.pry

        end

       


        
      end

    end
end