namespace :postgrid do
  desc 'Test postgrid timing by sending postcards every 4 hours'
  task :test, [:firstName, :address] => [:environment] do |_t, args|
    current = DateTime.now
    endOn = Date.new(2023, 11, 8)
    firstName = args[:firstName]
    address = args[:address]
    if (current.hour % 4).zero? && current < endOn
      date = current.strftime('%m/%d/%Y %H:%M')
      url = 'letters'
      params = {
        to: {
          firstName: firstName,
          addressLine1: address,
          city: 'Oklahoma City',
          provinceOrState: 'OK',
          country: 'US',
          skipVerification: true
        },
        html: "Hello, #{firstName} <br> Sent at: #{date}",
        from: {
          firstName: 'Holden',
          addressLine1: '200 S Cincinnati Ave',
          city: 'Tulsa',
          stateOrProvince: 'OK',
          country: 'US',
          skipVerification: true
        }
      }
      Postgrid.post(url, params)
    end
  end
end
