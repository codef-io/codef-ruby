###
 # connectedId 목록조회
 #
 # @author 	: codef
 # @date 	: 2019-07-29 09:00:00
 # @version : 1.0.0
###
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
  request.body = body.to_json
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

# CodefURL
codef_url = 'https://tapi.codef.io'
token_url = 'https://toauth.codef.io/oauth/token'

# connectedId 목록조회
connected_id_list_path = '/v1/account/connectedId-list'

# 기 발급된 토큰
token =''

# BodyData
body = {
  'connectedId':'엔드유저의 은행/카드사 계정 등록 후 발급받은 커넥티드아이디'
}

# CODEF API 요청
response_codef_api = http_sender(codef_url + connected_id_list_path, token, body)

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
    response_oauth = request_token(token_url, 'CODEF로부터 발급받은 클라이언트 아이디', 'CODEF로부터 발급받은 시크릿 키')
    puts('response_oauth.code = ' + response_oauth.code)
    puts('response_oauth.code = ' + response_oauth.body)
    if response_oauth.code == '200'
        dict = JSON.parse(response_oauth.body)

        # reissue_token
        token = dict['access_token']
        puts('access_token = ' + token)

        # request codef_api
        response = http_sender(codef_url + connected_id_list_path, token, body)
    else
        puts('토큰발급 오류')
    end
else
    puts('API 요청 오류')
end
