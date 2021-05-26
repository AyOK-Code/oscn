require 'uri'
require 'oscn_scraper'
require 'oscn_scraper/parsers/base_parser'

namespace :parse do
  desc 'Scrape cases data'
  task :case do
    case_id = Case.with_html.where("case_number LIKE '%CF%'").pluck(:id).sample
    c = Case.find(case_id)

    # c = Case.find_by(case_number: 'CF-2018-1016')

    puts "Parsing data for: #{c.case_number}"
    parsed_html = Nokogiri::HTML(c.html)
    parser = OscnScraper::Parsers::BaseParser.new(parsed_html)
    data = parser.build_object
    ap data[:counts]
  end

  desc 'Run x cases to check for error'
  task :dry_run do
    verdicts = []
    cases = Case.valid.with_html.first(10000)
    bar = ProgressBar.new(cases.count)

    cases.each do |c|
      parsed_html = Nokogiri::HTML(c.html)
      data = OscnScraper::Parsers::BaseParser.new(parsed_html).build_object
      verdicts = verdicts.uniq + data[:counts].map { |c| c[:verdict] }.uniq
      bar.increment!
    end
    ap verdicts.uniq
  end

  # PLEAS
  # [ 0] "Guilty Plea",
  # [ 1] "Deferred/Accelerated Guilty",
  # [ 2] "Dismissed- Request of the State",
  # [ 3] "Dismissed with Costs",
  # [ 4] nil,
  # [ 5] "Nolo Contendere Plea",
  # [ 6] "Other",
  # [ 7] "Bond Forfeited",
  # [ 8] "Dismissed by Court",
  # [ 9] "State Declined to File Charges",
  # [10] "Judge",
  # [11] "Jury Trial",
  # [12] "Transferred/ Case Filed",
  # [13] "Dismissed- Prosecution Witness Failed to Appear",
  # [14] "Deferred/ Expunge Denied",
  # [15] "Alford Plea"

  # VERDICTS
  # [
  #     [ 0] "DEFERRED",
  #     [ 1] "CONVICTION",
  #     [ 2] "DISMISSED",
  #     [ 3] nil,
  #     [ 4] "DISMISSED WITH COSTS",
  #     [ 5] "BOND FORFEITURE",
  #     [ 6] "",
  #     [ 7] "Program Successful",
  #     [ 8] "Program Unsuccessful",
  #     [ 9] "TRANSFER",
  #     [10] "ACQUITTED",
  #     [11] "DEFERRED DELINQUENT",
  #     [12] "CLOSED JUVENILE DUE TO NEW FILING"
  # ]


end
