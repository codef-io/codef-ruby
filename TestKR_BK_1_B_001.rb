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

  authHeader = Base64.encode64(client_id + ':' + client_secret)

  headers = {
    'Acceppt': 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Basic ' + authHeader
  }

  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(url, headers)
  request.body = 'grant_type=client_credentials&scope=read'
  response = http.request(request)

  return response
end
# ========== Toekn 재발급  ==========


response = nil

# CodefURL
codef_url = 'http://192.168.10.126:10001'
token_url = 'http://192.168.10.126:8888/oauth/token'

# 은행 법인 보유계좌
account_list_path = '/v1/kr/bank/b/account/account-list'

# 기 발급된 토큰
token ='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXJ2aWNlX3R5cGUiOiIwIiwic2NvcGUiOlsicmVhZCJdLCJzZXJ2aWNlX25vIjoiOTk5OTk5OTk5OSIsImV4cCI6MTU2MjczNjUyNywiYXV0aG9yaXRpZXMiOlsiSU5TVVJBTkNFIiwiUFVCTElDIiwiQkFOSyIsIkVUQyIsIlNUT0NLIiwiQ0FSRCJdLCJqdGkiOiIyODBhNjVkOS02NjU1LTQ5MzYtODEwNS05MjUyYTk4MGRjMDgiLCJjbGllbnRfaWQiOiJjb2RlZl9tYXN0ZXIifQ.eFCEgxcntsEkjFORAWGSi6949UMOuCxVsm2wnYlDXqrHWXXwG7-XfKugsBNone_qRRGeKD3iv6f_TEcVMWyTz8aS0fRbE514LVz6PnzKbruyPNDA5Pk3ym8up9h4Ba1ix__Bvpu_TB0Y7Fikk9YHWHacJy4F_WOjr8xFP-q2egh763_LqVUzRakGQoLOTukduZ5zH5lfSO1Z9yx2cnDkY4VSM9DTbycSZuA2oQkMVpXJc0slEyWLw7WNX5E-ff3fL6ePfJvu7by_4KmgmmJkOoKBWvJ00DwrwhAa1EZmjqGPYG6RE6wxSwsu3lYeiCX-jSGm_cbKdk7YDnYxm8FKzg'

token = 'a'

# BodyData
body = {
    'connected_id':'9LUm.uhVQbzaangazwI0tr',
    'organization':'0011'
}

# CODEF API 요청
response_codef_api = http_sender(codef_url + account_list_path, token, body)

# token error
if response_codef_api.code == '401'
    dict = JSON.parse(response_codef_api.body)

    # invalid_token
    puts('error = ' + dict['error'])
    # Cannot convert access token to JSON
    puts('error_description = ' + dict['error_description'])

    # reissue token
    response_oauth = request_token(token_url, "codef_master", "codef_master_secret");
    puts('response_oauth.code = ' + response_oauth.code)
    if response_oauth.code == '200'
        dict = JSON.parse(response_oauth.body)

        # reissue_token
        token = dict['access_token']
        puts('access_token = ' + token)

        # request codef_api
        response = http_sender(codef_url + account_list_path, token, body)

        # codef_api 응답 결과
        puts(response.code)
        puts(URI.decode(response.body))
    else
        puts('토큰발급 오류')
    end
else
    puts('정상처리')
end
