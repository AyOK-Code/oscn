require 'httparty'
require 'json'

module Importers
  class CrimeMap < ApplicationService
    def initialize
      @west = -97.674058
      @south = 35.37686
      @east = -97.140761
      @north = 35.72598

      @zoom = 9

      @center_lat = 35.54464873256638
      @center_lng = -97.49826954680444
    end

    def perform
      # pins
      require 'open-uri'
      url = 'https://nacok.org/wp-content/uploads/2024/10/NA-Crime-Report-9-1-2024-to-9-30-2024.pdf'

      io = URI.open(url)
      reader = PDF::Reader.new(io)
      puts reader.info
      reader.pages.each do |page|
        page_to_dict(page)
      end
    end

    def page_to_dict(page)
      header_index = 4

      lines = page.text.split("\n\n")
      header_row = lines[header_index]
      table_rows = lines[(header_index+1)...]
                     .reject { |row| excluded_row?(row) }
                     .compact_blank

      return if table_rows.empty?

      cols = columns(header_row)
      page_dict = []
      table_rows.each do |row|
        page_dict << row_to_dict(cols, row)
      end
      page_dict
    end

    def excluded_row?(row)
      exclude_rows_with_text = [
        'Total incidents',
        'Reporting Dates:'
      ]
      exclude_rows_with_text.any? { |text| row.include?(text) }
    end

    def columns(header_row)
      cols = {}
      column_names = ['Address', 'Date', 'Time', 'Offense', 'Description', 'Division', 'Case Number']
      column_names.each_with_index do |column, i|
        next_column = column_names[i + 1]
        cols[column] = {
          start: header_row.split(column)[0].length,
          end: header_row.split(next_column)[0].length
        }
      end
      cols
    end

    def row_to_dict(cols, row)
      row_dict = {}
      cols.each do |column, indexes|
        row_dict[column] = (row[indexes[:start]...indexes[:end]]).strip!
      end
      row_dict
    end

    def pins
      url = 'https://communitycrimemap.com/api/v1/search/load-data'
      headers = {
        'accept': 'application/json, text/plain, */*',
        'accept-language': 'en-US,en;q=0.9,es;q=0.8,he;q=0.7',
        'authorization': "Bearer #{token}",
        'cache-control': 'no-cache',
        'content-type': 'application/json',
        'cookie': "ai_user=zPXLlny6Trh2li4D8X3aMv|2024-10-15T21:50:37.649Z; Authorization=Bearer%#{token}; ai_session=dgZ+KN34zuWTPY/g6EAPNV|1729693055912|1729693055912",
        'origin': 'https://communitycrimemap.com',
        'pragma': 'no-cache',
        'priority': 'u=1, i',
        'referer': 'https://communitycrimemap.com/map',
        'request-id': '|baeb098886174d57ab8a31f3268d4ca3.f4da0b07c76247dc',
        'sec-ch-ua': '"Google Chrome";v="129", "Not=A?Brand";v="8", "Chromium";v="129"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"macOS"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'traceparent': '00-baeb098886174d57ab8a31f3268d4ca3-f4da0b07c76247dc-01',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36',
      }
      body = {
        'buffer' => {
          'enabled' => false,
          'restrictArea' => false,
          'value' => []
        },
        'date' => {
          'start' => '09/23/2024',
          'end' => '10/23/2024'
        },
        'agencies' => [],
        'layers' => {
          'selection' => selection
        },
        'location' => {
          'bounds' => {
            'east' => @east,
            'north' => @north,
            'south' => @south,
            'west' => @west
          },
          'lat' => @center_lat,
          'lng' => @center_lng,
          'zoom' => @zoom
        },
        'analyticLayers' => {
          'density' => {
            'selected' => false,
            'transparency' => 60
          }
        }
      }.to_json
      res = HTTParty.post(url, headers: headers, body: body)
      pins = JSON.parse(res.body)['data']['data']['pins']
      pins
    end

    def token
      return @token if @token

      url = 'https://communitycrimemap.com/api/v1/auth/newToken'
      headers = {
        'accept': 'application/json, text/plain, */*',
        'accept-language': 'en-US,en;q=0.9',
        'cache-control': 'no-cache',
        'pragma': 'no-cache',
        'priority': 'u=1, i',
        'referer': 'https://communitycrimemap.com/map',
        'sec-ch-ua': '"Google Chrome";v="129", "Not=A?Brand";v="8", "Chromium";v="129"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"macOS"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36',
      }
      res = HTTParty.get(url, headers: headers)
      @token = JSON.parse(res.body)['data']['jwt']
      @token
    end

    def selection
      [
        nil,
        nil,
        {
          'selected' => true
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => true
        },
        {
          'selected' => false
        },
        {
          'selected' => true
        },
        {
          'selected' => true
        },
        {
          'selected' => true
        },
        {
          'selected' => false
        },
        {
          'selected' => true
        },
        {
          'selected' => true
        },
        {
          'selected' => true
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => true
        },
        {
          'selected' => false
        },
        {
          'selected' => true
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        {
          'selected' => false
        },
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        },
        {
          'selected' => false
        }
      ]
    end
  end
end