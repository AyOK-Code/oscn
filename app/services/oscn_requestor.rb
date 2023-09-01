class OscnRequestor
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def self.perform(url)
    new(url).perform
  end

  def perform
    user_agent = get_agent
    accept = get_accept
    HTTParty.get(url, headers: {
                              'User-Agent': user_agent,
                              'Accept-Encoding': 'gzip, deflate, br',
                              'Accept-Language': 'en-US,en;q=0.9,es;q=0.8',
                              Accept: accept
                            })
  end

  private

  def get_agent
    # rubocop:disable Layout/LineLength
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36'
    ENV.fetch('USER_AGENT', user_agent)
    # rubocop:enable Layout/LineLength
  end

  def get_accept
    # rubocop:disable Layout/LineLength
    accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9'
    # rubocop:enable Layout/LineLength
  end
end
