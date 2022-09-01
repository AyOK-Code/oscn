require "node-runner"

module Importers
  module OkcBlotter
    class Pdf
      def initialize(date)
        @pdf = Bucket.new.get_object("#{self.class.s3_path}/#{date}.pdf")
        @json = self.class.js_runner.parsePdf(@pdf.data.body, date)
        # @json = self.class.js_runner.downloadAllPdfs('2022-08-30')
        test = true
      end

      def self.download_all_available(from_date = nil)
        js_runner.downloadAllPdfs(from_date)
        Dir.foreach(pdf_directory) do |filename|
          next if filename == '.' or filename == '..'
          pdf = File.open("#{pdf_directory}/#{filename}")
          Bucket.new.put_object("#{s3_path}/#{filename}", pdf)
          File.delete("#{pdf_directory}/#{filename}")
        end
        # File.delete(pdf_directory) #todo: this doesn't work
      end

      def self.s3_path
        'okc_blotter'
      end

      def self.pdf_directory
        @@pdf_directory ||= Rails.root.join("tmp/storage/okc_blotter_pdfs/#{Time.now}")
        Dir.mkdir(@@pdf_directory, 0777) unless Dir.exist?(@@pdf_directory)
        @@pdf_directory
      end

      def self.js_runner
        @@js_runner ||= NodeRunner.new(
          <<~JAVASCRIPT % self.pdf_directory
            const pdf_directory = "%s" 
            const fs = require('fs');
            const okcb = require('okcjb')
            let log = []
            console.log = (message) => { log.push(message) };
            const downloadAllPdfs = async (date) => {
              log = []
              const pdfsWithPostedDate = await okcb.fetchAllPdfs(date);
              for (let i = 0; i < pdfsWithPostedDate.length; i++) {     
                let fileName = `${pdf_directory}/${pdfsWithPostedDate[i].postedOn}.pdf`        
                fs.writeFileSync(fileName, pdfsWithPostedDate[i].buf, 'binary');
                fs.chmod(fileName, 0777, () => {});
              }
            }
            const parsePdf = async (pdf, date) => {
              // log = []
              // const json = {}
              // const json = await okcb.parseJailblotter(pdf);
              // let fileName = `${pdf_directory}/${date}.json`        
              // fs.writefilesync(filename, json);
              // fs.chmod(fileName, 0777, () => {});
            }
        JAVASCRIPT
        )
      end
    end
  end
end
