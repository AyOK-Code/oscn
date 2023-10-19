namespace :postgrid do
  desc 'Test postgrid timing by sending postcards to Austin'
  task test: [:environment] do
      current = DateTime.now
      #if current.hour % 4 == 0
      if current.hour % 1 == 0
        date = current.strftime('%m/%d/%Y %H:%M')
        url = 'letters'
        params = {
          to: {
            firstName: 'Austin',
            addressLine1: '911 NW 57th Street',
            city: 'Oklahoma City',
            provinceOrState: 'OK',
            country: 'US',
            skipVerification: true
          },
          html: "Hello, Austin <br> Sent at: #{date}",
          from: {
            firstName: 'Holden',
            addressLine1: '200 S Cincinnati Ave',
            city: 'Tulsa',
            stateOrProvince: 'OK',
            country: 'US',
            skipVerification: true
          } 
        }
        response = Postgrid.post(url, params)
        binding.pry
      end
  end
end