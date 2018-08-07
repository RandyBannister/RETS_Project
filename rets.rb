require 'net/http'
require 'uri'

class RetsDataProcessor

  attr_accessor :url
  attr_accessor :username
  attr_accessor :password

  def initialize(url, username, password)
    self.url = url
    self.username = username
    self.password = password
  end

  def login
    response = net_http(nil, 'login')
    if response.body == "<RETS ReplyCode=\"20050\" ReplyText=\"Server Temporarily Disabled. RETS is unavailable.\" />\r\n"
      raise 'RETS is unavailble'
    end

    response.to_hash
  end

  def search(jesession_id, params)
    search = net_http(jesession_id, params)
    hash = Hash.from_xml(Nokogiri::XML(search.body).to_s)
    hash
  end

  private

  def net_http(jesession_id = nil, params)
    uri = URI.parse("#{url}#{params}")
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(username, password)
    request["Rets-Version"] = "RETS/1.7.2"
    request["Cookie"] = "JSESSIONID=#{jesession_id}"

    req_options = {
        use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response
  end

end
