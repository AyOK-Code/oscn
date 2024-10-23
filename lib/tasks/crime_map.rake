namespace :crime_map do
  desc 'Import data from the Lexis Nexis crime map'
  task import: [:environment] do
    left = -97.674058
    bottom = 35.37686
    top = -97.140761
    right = 35.72598

    require 'httparty'
    require 'json'

    url = 'https://communitycrimemap.com/api/v1/search/load-data'
    headers = {
      'accept': 'application/json, text/plain, */*',
      'accept-language': 'en-US,en;q=0.9,es;q=0.8,he;q=0.7',
      'authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImp0aSI6IlFcLzA5Z2xPZE1qaUp4RStFK1c1Nm9Ja0RabW9COHJFMkpDdGp0dDdTVlRZMVdnZGxKNTB3WXUzOTVtMGhBbmhmOEMyRlwvMjBvQjdLYWdKXC9ack9BaUlBPT0ifQ.eyJpc3MiOiIxOWNhNWM1ZDhlODFkOWM0N2VhYjRiNzI2Njg2NmIzOSIsImF1ZCI6IjNjNzc0YTgxYWM2MTlkMjQzNjFkZWFmNDNjYjFkZDdiIiwic3ViIjoiNDI2OTIyNzU4YWRhNjYwYzVhNDE4ZTlkMWI1ZDUzOGUiLCJqdGkiOiJRXC8wOWdsT2RNamlKeEUrRStXNTZvSWtEWm1vQjhyRTJKQ3RqdHQ3U1ZUWTFXZ2RsSjUwd1l1Mzk1bTBoQW5oZjhDMkZcLzIwb0I3S2FnSlwvWnJPQWlJQT09IiwiaWF0IjowLCJuYmYiOjAsImV4cCI6MTcyOTcwMzg1NSwidWlkIjoiTlozckxlMitqS3VIemRZZ3FmYjE1NWJWTlpxa1JCZGRob3cxeU1wVk5SWmFvdExRUnY1YVU1UlwvMFpJcmpvQ00zOVZUd2FxNDcwNjYydCt1SUZXendRPT0ifQ.hzNsP1Mm9Td71zYLPkUGu3ZXl_faVf8-ndGbKAa4f6s',
      'cache-control': 'no-cache',
      'content-type': 'application/json',
      'cookie': 'ai_user=zPXLlny6Trh2li4D8X3aMv|2024-10-15T21:50:37.649Z; Authorization=Bearer%20eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImp0aSI6IlFcLzA5Z2xPZE1qaUp4RStFK1c1Nm9Ja0RabW9COHJFMkpDdGp0dDdTVlRZMVdnZGxKNTB3WXUzOTVtMGhBbmhmOEMyRlwvMjBvQjdLYWdKXC9ack9BaUlBPT0ifQ.eyJpc3MiOiIxOWNhNWM1ZDhlODFkOWM0N2VhYjRiNzI2Njg2NmIzOSIsImF1ZCI6IjNjNzc0YTgxYWM2MTlkMjQzNjFkZWFmNDNjYjFkZDdiIiwic3ViIjoiNDI2OTIyNzU4YWRhNjYwYzVhNDE4ZTlkMWI1ZDUzOGUiLCJqdGkiOiJRXC8wOWdsT2RNamlKeEUrRStXNTZvSWtEWm1vQjhyRTJKQ3RqdHQ3U1ZUWTFXZ2RsSjUwd1l1Mzk1bTBoQW5oZjhDMkZcLzIwb0I3S2FnSlwvWnJPQWlJQT09IiwiaWF0IjowLCJuYmYiOjAsImV4cCI6MTcyOTcwMzg1NSwidWlkIjoiTlozckxlMitqS3VIemRZZ3FmYjE1NWJWTlpxa1JCZGRob3cxeU1wVk5SWmFvdExRUnY1YVU1UlwvMFpJcmpvQ00zOVZUd2FxNDcwNjYydCt1SUZXendRPT0ifQ.hzNsP1Mm9Td71zYLPkUGu3ZXl_faVf8-ndGbKAa4f6s; ai_session=dgZ+KN34zuWTPY/g6EAPNV|1729693055912|1729693055912',
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
        'selection' => [
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
      },
      'location' => {
        'bounds' => {
          'east' => -96.34607838469506,
          'north' => 35.68990986454246,
          'south' => 35.3993876005903,
          'west' => -98.65046070891381
        },
        'lat' => 35.54464873256638,
        'lng' => -97.49826954680444,
        'zoom' => 10
      },
      'analyticLayers' => {
        'density' => {
          'selected' => false,
          'transparency' => 60
        }
      }
    }.to_json
    res = HTTParty.post(url, headers: headers, body: body)
    pins = JSON.parse(res.body)['data']['data']
  end
end

