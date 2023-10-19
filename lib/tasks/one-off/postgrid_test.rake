namespace :postgrid do
  desc 'Test postgrid timing by sending postcards to Austin'
  task test: [:environment] do
      current_hour = DateTime.now
      if current_hour.hour % 4 === 0
        # Send postcard
        puts "Sending postcard"
        Postgrid.post()
      end
  end
end
