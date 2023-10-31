namespace :postgrid do
  desc 'Test postgrid timing by sending postcards every 4 hours'
  task :test, [:first_name, :address] => [:environment] do |_t, args|
    current = DateTime.now.change(:offset => '-0500')
    end_on = Date.new(2023, 11, 8)
    first_name = args[:first_name]
    address = args[:address]
    if (current.hour % 4).zero? && current < end_on
      date = current.strftime('%m/%d/%Y %H:%M')
      url = 'letters'
      params = {
        to: {
          firstName: first_name,
          addressLine1: address,
          city: 'Oklahoma City',
          provinceOrState: 'OK',
          country: 'US'
        },
        html: "Hello, #{first_name} <br> Sent at: #{date}",
        from: {
          firstName: 'Holden',
          addressLine1: '200 S Cincinnati Ave',
          city: 'Tulsa',
          stateOrProvince: 'OK',
          country: 'US'
        }
      }
      Postgrid.post(url, params)
    end
  end
end
