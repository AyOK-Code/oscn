namespace :postgrid do
  desc 'Test postgrid timing by sending postcards to Austin'
  task test: [:environment] do
      current = DateTime.now
      #if current.hour % 4 == 0
      if current.hour % 1 == 0
        date = current.strftime('%m/%d/%Y %H:%M')
        url = 'postcards'
        params = {
          frontHTML: "Hello, Austin <br> Sent at: #{date}",
          backHTML: 'Back of card',
          size: '6x4',
          to: {
            firstName: 'Austin',
            addressLine1: '911 NW 57th Street',
            city: 'Oklahoma City',
            provinceOrState: 'OK'
          }
        }
        response = Postgrid.post(url, params)
        binding.pry
      end
  end
end