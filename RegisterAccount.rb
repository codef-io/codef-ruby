RUBY_DESCRIPTION

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

  authHeader = Base64.encode64(client_id + ':' + client_secret)

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

  puts(response.code)
  puts(URI.decode(response.body))

  return response
end
# ========== Toekn 재발급  ==========


# token URL
token_url = 'https://toauth.codef.io/oauth/token'

# CODEF 연결 아이디
connected_id = ''

# 기 발급된 토큰
token ='eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXJ2aWNlX3R5cGUiOiIwIiwic2NvcGUiOlsicmVhZCJdLCJzZXJ2aWNlX25vIjoiOTk5OTk5OTk5OSIsImV4cCI6MTU2MjczNjUyNywiYXV0aG9yaXRpZXMiOlsiSU5TVVJBTkNFIiwiUFVCTElDIiwiQkFOSyIsIkVUQyIsIlNUT0NLIiwiQ0FSRCJdLCJqdGkiOiIyODBhNjVkOS02NjU1LTQ5MzYtODEwNS05MjUyYTk4MGRjMDgiLCJjbGllbnRfaWQiOiJjb2RlZl9tYXN0ZXIifQ.eFCEgxcntsEkjFORAWGSi6949UMOuCxVsm2wnYlDXqrHWXXwG7-XfKugsBNone_qRRGeKD3iv6f_TEcVMWyTz8aS0fRbE514LVz6PnzKbruyPNDA5Pk3ym8up9h4Ba1ix__Bvpu_TB0Y7Fikk9YHWHacJy4F_WOjr8xFP-q2egh763_LqVUzRakGQoLOTukduZ5zH5lfSO1Z9yx2cnDkY4VSM9DTbycSZuA2oQkMVpXJc0slEyWLw7WNX5E-ff3fL6ePfJvu7by_4KmgmmJkOoKBWvJ00DwrwhAa1EZmjqGPYG6RE6wxSwsu3lYeiCX-jSGm_cbKdk7YDnYxm8FKzg'


##############################################################################
##                               계정 생성 Sample                             ##
##############################################################################
# Input Param
#
# accountList : 계정목록
#   countryCode : 국가코드
#   businessType : 비즈니스 구분
#   clientType : 고객구분(P: 개인, B: 기업)
#   organization : 기관코드
#   loginType : 로그인타입 (0: 인증서, 1: ID/PW)
#   password : 인증서 비밀번호
#   derFile : 인증서 derFile
#   keyFile : 인증서 keyFile
#
##############################################################################
codef_account_create_url = 'https://tapi.codef.io/v1/account/create'
codef_account_create_body = {
            'accountList':[
                {
                  'countryCode':'KR',
                  'businessType':'BK',
                  'clientType':'P',
                  'organization':'0004',
                  'loginType':'0',
                  'password':'1234',      # 인증서 비밀번호 입력
                  'derFile':'MIIF...',    # 인증서 인증서 DerFile
                  'keyFile':'MIIF...'     # 인증서 인증서 KeyFile
                }
            ]
}

response_account_create = http_sender(codef_account_create_url, token, codef_account_create_body)
if response_account_create.code == '200'      # success
    puts("success : " + response_account_create.body)
elsif response_account_create.code == '401'      # token error
    puts('response_account_create.body = ' + response_account_create.body)
    dict = JSON.parse(response_account_create.body)
    # invalid_token
    puts('error = ' + dict['error'])
    # Cannot convert access token to JSON
    puts('error_description = ' + dict['error_description'])

    # reissue token
    response_oauth = request_token(token_url, "CODEF로부터 발급받은 클라이언트 아이디", "CODEF로부터 발급받은 시크릿 키");
    if response_oauth.code == '200'
        dict = JSON.parse(response_oauth.body)
        # reissue_token
        token = dict['access_token']
        puts('access_token = ' + token)

        # request codef_api
        response = http_sender(codef_account_create_url, token, codef_account_create_body)
        dict = json.loads(urllib.unquote_plus(response.body.encode('utf8')))
        connected_id = dict['data']['connectedId']
        puts('connected_id = ' + connected_id)
        puts('계정생성 정상처리')

        # codef_api 응답 결과
        puts(response.code)
        puts(response.body)
    else
        puts('토큰발급 오류')
    end
else
    dict = json.loads(urllib.unquote_plus(response_account_create.text.encode('utf8')))
    connected_id = dict['data']['connectedId']
    puts('connected_id = ' + connected_id)
    puts('계정생성 정상처리')
end


##############################################################################
##                               계정 추가 Sample                             ##
##############################################################################
# Input Param
#
# connectedId : CODEF 연결아이디
# accountList : 계정목록
#   countryCode : 국가코드
#   businessType : 비즈니스 구분
#   clientType : 고객구분(P: 개인, B: 기업)
#   organization : 기관코드
#   loginType : 로그인타입 (0: 인증서, 1: ID/PW)
#   password : 인증서 비밀번호
#   derFile : 인증서 derFile
#   keyFile : 인증서 keyFile
#
##############################################################################
codef_account_add_url = 'https://tapi.codef.io/v1/account/add'
codef_account_add_body = {
            'connectedId': '8-cXc.6lk-ib4Whi5zClVt',    # connected_id
            'accountList':[
                {
                  'countryCode':'KR',
                  'businessType':'BK',
                  'clientType':'P',
                  'organization':'0020',
                  'loginType':'0',
                  'password':'1234',      # 인증서 비밀번호 입력
                  'derFile':'MIIF...',    # 인증서 인증서 DerFile
                  'keyFile':'MIIF...'     # 인증서 인증서 KeyFile
                }
            ]
}

response_account_add = http_sender(codef_account_add_url, token, codef_account_add_body)
if response_account_add.code == '200'      # success
    puts("success : " + response_account_add.body)
elsif response_account_add.code == '401'      # token error
    dict = JSON.parse(response_account_add.body)
    # invalid_token
    puts('error = ' + dict['error'])
    # Cannot convert access token to JSON
    puts('error_description = ' + dict['error_description'])

    # reissue token
    response_oauth = request_token(token_url, "CODEF로부터 발급받은 클라이언트 아이디", "CODEF로부터 발급받은 시크릿 키");
    if response_oauth.code == '200'
        dict = JSON.parse(response_oauth.body)
        # reissue_token
        token = dict['access_token']
        puts('access_token = ' + token)

        # request codef_api
        response = http_sender(codef_account_add_url, token, codef_account_add_body)
        puts('계정추가 정상처리')

        # codef_api 응답 결과
        puts(response.code)
        puts(response.body)
    else
        puts('토큰발급 오류')
    end
else
    puts('계정추가 정상처리')
end


##############################################################################
##                               계정 수정 Sample                             ##
##############################################################################
# Input Param
#
# connectedId : CODEF 연결아이디
# accountList : 계정목록
#   countryCode : 국가코드
#   businessType : 비즈니스 구분
#   clientType : 고객구분(P: 개인, B: 기업)
#   organization : 기관코드
#   loginType : 로그인타입 (0: 인증서, 1: ID/PW)
#   password : 인증서 비밀번호
#   derFile : 인증서 derFile
#   keyFile : 인증서 keyFile
#
##############################################################################
codef_account_update_url = 'https://tapi.codef.io/v1/account/update'
codef_account_update_body = {
            'connectedId': '8-cXc.6lk-ib4Whi5zClVt',        # connected_id
            'accountList':[
                {
                  'countryCode':'KR',
                  'businessType':'BK',
                  'clientType':'P',
                  'organization':'0020',
                  'loginType':'0',
                  'password':'1234',      # 인증서 비밀번호 입력
                  'derFile':'MIIF...',    # 인증서 인증서 DerFile
                  'keyFile':'MIIF...'     # 인증서 인증서 KeyFile
                }
            ]
}

response_account_update = http_sender(codef_account_update_url, token, codef_account_update_body)
if response_account_update.code == '200'      # success
    puts("success : " + response_account_update.body)
elsif response_account_update.code == '401'      # token error
    dict = JSON.parse(response_account_update.body)
    # invalid_token
    puts('error = ' + dict['error'])
    # Cannot convert access token to JSON
    puts('error_description = ' + dict['error_description'])

    # reissue token
    response_oauth = request_token(token_url, "CODEF로부터 발급받은 클라이언트 아이디", "CODEF로부터 발급받은 시크릿 키");
    if response_oauth.code == '200'
        dict = JSON.parse(response_oauth.body)
        # reissue_token
        token = dict['access_token']
        puts('access_token = ' + token)

        # request codef_api
        response = http_sender(codef_account_update_url, token, codef_account_update_body)
        dict = JSON.parse(urllib.unquote_plus(response.body.encode('utf8')))
        connected_id = dict['data']['connectedId']
        puts('connected_id = ' + connected_id)
        puts('계정수정 정상처리')

        # codef_api 응답 결과
        puts(response.code)
        puts(response.body)
    else
        puts('토큰발급 오류')
    end
else
    dict = JSON.parse(urllib.unquote_plus(response_account_update.body.encode('utf8')))
    connected_id = dict['data']['connectedId']
    puts('connected_id = ' + connected_id)
    puts('계정수정 정상처리')
end


##############################################################################
##                               계정 삭제 Sample                             ##
##############################################################################
# Input Param
#
# connectedId : CODEF 연결아이디
# accountList : 계정목록
#   organization : 기관코드
#   loginType : 로그인타입 (0: 인증서, 1: ID/PW)
#   password : 인증서 비밀번호
#   derFile : 인증서 derFile
#   keyFile : 인증서 keyFile
#
##############################################################################
codef_account_delete_url = 'https://tapi.codef.io/v1/account/delete'
codef_account_delete_body = {
            'connectedId': '8-cXc.6lk-ib4Whi5zClVt',        # connected_id
            'accountList':[
                {
                  'countryCode':'KR',
                  'businessType':'BK',
                  'clientType':'P',
                  'organization':'0020',
                  'loginType':'0',
                  'password':'1234',      # 인증서 비밀번호 입력
                  'derFile':'MIIF...',    # 인증서 인증서 DerFile
                  'keyFile':'MIIF...'     # 인증서 인증서 KeyFile
                }
            ]
}

response_account_delete = http_sender(codef_account_delete_url, token, codef_account_delete_body)
if response_account_delete.code == '200'      # success
    puts("success : " + response_account_delete.body)
elsif response_account_delete.code == '401'      # token error
    dict = JSON.parse(response_account_delete.body)
    # invalid_token
    puts('error = ' + dict['error'])
    # Cannot convert access token to JSON
    puts('error_description = ' + dict['error_description'])

    # reissue token
    response_oauth = request_token(token_url, "CODEF로부터 발급받은 클라이언트 아이디", "CODEF로부터 발급받은 시크릿 키");
    if response_oauth.code == '200'
        dict = JSON.parse(response_oauth.body)
        # reissue_token
        token = dict['access_token']
        puts('access_token = ' + token)

        # request codef_api
        response = http_sender(codef_account_delete_url, token, codef_account_delete_body)
        dict = JSON.parse(urllib.unquote_plus(response.body.encode('utf8')))
        connected_id = dict['data']['connectedId']
        puts('connected_id = ' + connected_id)
        puts('계정삭제 정상처리')

        # codef_api 응답 결과
        puts(response.code)
        puts(response.body)
    else
        puts('토큰발급 오류')
    end
else
    dict = JSON.parse(urllib.unquote_plus(response_account_delete.body.encode('utf8')))
    connected_id = dict['data']['connectedId']
    puts('connected_id = ' + connected_id)
    puts('계정삭제 정상처리')
end
