require "node-runner"

namespace :okc_blotter do
  desc 'Scape and parse'
  task scrape_and_parse: [:environment] do
    rails_root = Rails.root.join("tmp/storage")
    okc_blotter = NodeRunner.new(
      <<~JAVASCRIPT % rails_root
        const rails_root = "%s"
        const fs = require('fs');
        const okcb = require('okcjb')
        const fetchAndParseAllPdfs = async () => {
          const output = console.log
          const log = []
          console.log = (message) => { log.push(message) };
          console.log(rails_root);
          const jsons = await okcb.fetchAndParseAllPdfs();
          fs.writeFile(rails_root + '/findme.json', JSON.stringify(jsons), function (err) {
            if (err) return console.log(err);
          })
          output(JSON.stringify({"log": log, "results": jsons}))
        }
    JAVASCRIPT
    )
    results = okc_blotter.fetchAndParseAllPdfs();
    puts results
  end
end