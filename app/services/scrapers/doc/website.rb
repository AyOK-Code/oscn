require 'selenium-webdriver'

module Scrapers
  module Doc
    class Website < ApplicationService
      def initialize
        @driver = Selenium::WebDriver.for :chrome
        super
      end

      def perform
        kick_off_for_all_vowels
      end

      def kick_off_for_all_vowels
        ['a', 'e', 'i', 'o', 'u', 'y'].each do |vowel|
          search_and_scrape("%#{vowel}%")
        end
      end

      def search_and_scrape(last_name_value)
        @driver.navigate.to 'https://okoffender.doc.ok.gov/'
        @driver.find_element(:id, 'cphMain_cmdAcceptDisclaimer').click
        @driver.find_element(:id, 'cphMain_txtLastName').send_keys(last_name_value)

        puts 'Please fill in captcha and click the "Search" button'
        wait = Selenium::WebDriver::Wait.new(timeout: 300)
        wait.until { !@driver.find_element(:css, "input[value='Search']").displayed? }
        puts 'Continuing.'

        page = 1
        while loop_rows
          page += 1
          current_page_pagination = @driver.find_element(:css, '.cssResultsPager td span')
          next_page_pagination = current_page_pagination.find_element(:xpath, './/ancestor::td/following-sibling::td/a')
          next_page_pagination.click
          puts("page: #{page}")
        end
      end

      def loop_rows
        (1..10).each do |i|
          row = @driver.find_elements(:css, 'tbody tr')[i]
          return false unless row

          row.find_element(:css, 'a').click
          name = @driver.find_elements(:xpath, "//h5[contains(text(), 'Offender:')]")[0].attribute('innerHTML')
          puts name
          @driver.navigate.back
        end
        true
      end

      def profile
        ::Doc::Profile.upsert(
           profile_attributes
          , unique_by: :doc_number)
      end

      def profile_attributes
        {
          doc_number: doc_number,
          last_name: find_for_label( 'div', 'Offender: ').split(' ')[-1],
          first_name: find_for_label( 'div', 'Gender:').split(' ')[0],
          middle_name: find_for_label( 'div', 'Gender:').split(' ').delete(0).delete(-1).join(' '),
          suffix: data[4],
          last_move_date: parse_date(data[5]),
          facility: data[6],
          birth_date: parse_date(data[7]),
          sex: parse_sex(data[8]),
          race: data[9],
          hair: data[10],
          height_ft: data[11],
          height_in: data[12],
          weight: data[13],
          eye: data[14],
          status:find_for_label('h5','Status:').downcase
        }
      end

      def name
        full = find_for_label( 'div', 'Offender: ').split(' ')

        {
          first:
          last,
        }
      end

      def doc_number
        find_for_label('h5', 'OK DOC#:')
      end

      def find_for_label(el, text)
        @driver.find_elements(:xpath, "//#{el}[contains(text(), '#{text}')]")[0].attribute('innerHTML')
      end
    end
  end
end
