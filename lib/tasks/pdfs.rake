namespace :save do
  desc 'Update cases for data request'
  task :pdfs, [:count] => [:environment] do |_t, args|
    count = args[:count].to_i

    # Query the view for the next 100 cases without attachment
  end
end
