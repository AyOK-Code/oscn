require 'httparty'
require 'json'

module Importers
  class CrimeMap < ApplicationService
    def initialize
      zoom_okc_metro
    end

    def zoom_okc_metro
      @east = -95.86508397102726
      @north = 36.42498633282242
      @south = 34.142898155956104
      @west = -99.00717381477726
      @lat = 35.283942244389266
      @lng = -97.43612889290226
      @zoom = 9
    end

    def perform
      get_crimes
    end

    def get_crimes
      url = 'https://communitycrimemap.com/api/v1/search/load-data'
      res = HTTParty.post(url, headers: pins_headers, body: pins_body)
      crimes = JSON.parse(res.body)['data']['data']['pins'].map{|k,v| v['EventRecord']['MOs']['MO']}
      crimes
    end

    def analyis(crimes)
      min_date = crimes.sort_by {|v| v['DateTime']}[0]
      max_date = crimes.sort_by {|v| v['DateTime']}[-1]
    end

    def pins_body
      {
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
    end

    def pins_headers
      {
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