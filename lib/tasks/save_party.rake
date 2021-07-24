namespace :save do
  desc 'Save party information'
  task :parties do
    Importers::Parties.perform
  end

  desc 'Update name information'
  task :split_names do
    defendants = Party.defendant
    bar = ProgressBar.new(defendants.count)

    defendants.each do |d|
      split_name = d.full_name.split(/\p{Space}\p{Space}/)
      # TODO: Refactor split name
      if split_name.count > 4
        d.update(first_name: split_name[1].gsub(',', '').squish,
                 middle_name: "#{split_name[2].gsub(',', '').squish} #{split_name[3].gsub(',', '').squish}",
                 last_name: split_name[0].gsub(',', '').squish,
                 suffix: split_name[4].gsub(',', '').squish)
        byebug
      elsif split_name.count > 3
        d.update(first_name: split_name[1].gsub(',', '').squish,
                 middle_name: split_name[2].gsub(',', '').squish,
                 last_name: split_name[0].gsub(',', '').squish,
                 suffix: split_name[3].gsub(',', '').squish)
      elsif split_name.count > 2
        d.update(first_name: split_name[1].gsub(',', '').squish,
                 middle_name: split_name[2].gsub(',', '').squish,
                 last_name: split_name[0].gsub(',', '').squish,
                 )
      elsif split_name.count == 1
        puts split_name
      elsif split_name.count == 0
        next
      else
        begin
          d.update(first_name: split_name[1].gsub(',', '').squish,
                   last_name: split_name[0].gsub(',', '').squish,
                   )
        rescue
          byebug
        end
      end
      bar.increment!
    end
  end
end
