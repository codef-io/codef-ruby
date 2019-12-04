######################################
##      은행 법인 보유계좌
######################################

require 'net/http'
require 'uri'
require 'json'
require 'base64'
require 'uri'

# ========== HTTP 기본 함수 ==========
def http_sender(url, token, body)
  uri = URI.parse(url)

  puts('url = ' + url)
  puts('uri.request_uri = ' + uri.request_uri)

  headers = {
    'Content-Type'=>'application/json',
    'Authorization'=>'Bearer ' + token
  }

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Post.new(url, headers)
  request.body = URI::encode(body.to_json)
  response = http.request(request)

  puts(response.code)
  puts(URI.decode(response.body))

  return response
end
# ========== HTTP 함수  ==========

# ========== Toekn 재발급  ==========
def request_token(url, client_id, client_secret)
  uri = URI.parse(url)

  authHeader = Base64.strict_encode64(client_id + ':' + client_secret)

  headers = {
    'Accept'=> 'application/json',
    'Content-Type'=> 'application/x-www-form-urlencoded',
    'Authorization'=> 'Basic ' + authHeader
  }

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Post.new(url, headers)
  request.body = 'grant_type=client_credentials&scope=read'
  response = http.request(request)

  return response
end
# ========== Toekn 재발급  ==========


response = nil

# API서버 샌드박스 도메인
CODEF_URL = 'https://tsandbox.codef.io';
TOKEN_URL = 'https://oauth.codef.io/oauth/token';
SANDBOX_CLIENT_ID 	= 'ef27cfaa-10c1-4470-adac-60ba476273f9';      # CODEF 샌드박스 클라이언트 아이디
SANDBOX_SECERET_KEY 	= '83160c33-9045-4915-86d8-809473cdf5c3';    # CODEF 샌드박스 클라이언트 시크릿

# 은행 법인 보유계좌
account_list_path = '/v1/kr/bank/b/account/account-list'

# 기 발급된 토큰
token =''

# BodyData
body = {
  'connectedId':'sandbox_connectedId',
  'organization':'0004'
}

# CODEF API 요청
response_codef_api = http_sender(CODEF_URL + account_list_path, token, body)

if response_codef_api.code == '200'
  puts('정상처리')
# token error
elsif response_codef_api.code == '401'
    dict = JSON.parse(response_codef_api.body)

    # invalid_token
    puts('error = ' + dict['error'])
    # Cannot convert access token to JSON
    puts('error_description = ' + dict['error_description'])

    # reissue token
    response_oauth = request_token(TOKEN_URL, SANDBOX_CLIENT_ID, SANDBOX_SECERET_KEY);
    puts('response_oauth.code = ' + response_oauth.code)
    puts('response_oauth.code = ' + response_oauth.body)
    if response_oauth.code == '200'
        dict = JSON.parse(response_oauth.body)

        # reissue_token
        token = dict['access_token']
        puts('access_token = ' + token)

        # request codef_api
        response = http_sender(CODEF_URL + account_list_path, token, body)
    else
        puts('토큰발급 오류')
    end
else
    puts('API 요청 오류')
end
