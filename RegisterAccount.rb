###
 # 계정등록
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
require 'openssl'
require 'cgi'

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
  request.body = CGI::escape(body.to_json)
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

# ========== Toekn 재발급  ==========
def publicEncRSA(publicKey, data)
  rsa_public_key = OpenSSL::PKey::RSA.new(Base64.decode64(publicKey))
  encryptedData = Base64.encode64(rsa_public_key.public_encrypt(data))

  print("\n" + 'encryptedData = ' + encryptedData.gsub("\n", ""))

  return encryptedData.gsub("\n", "")
end
# ========== Toekn 재발급  ==========


response = nil

# CodefURL
codef_url = 'https://tapi.codef.io'
token_url = 'https://toauth.codef.io/oauth/token'

# 기 발급된 토큰
token =''

# 기 발급된 PublicKey
pubKey = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqfaFcUivfb/Y2/miAccmnARokQ3FJZAyJA1+25CNlHTd3wjIJugIdPjUxepzX+6DKFfR30jeL3uziz6k9ECMJV/UfZ+ev35EDmkjQFBgdY/teb2qPRA5kGwHIRzbMquQfQZ8Dh5v3e/viQKeERpn/ajblzblIgZ+5Fe7DQzzlhqJ0DWy5koGSQ2gTQynOqlbaVLSsbQsDPuE6cZOa+AbLbOAetTf2NtaMWMC2LUm6LDbN5OEdDNqQ7BE2ngUFiapr+ztQvlaMj/8NCDucEMHSVMQrhyTeuMVSPotq1VcUN7VTvLj7+P3qHEjRpmg5/q505Xpl8svoQ7uJcbM222bOwIDAQAB';
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
print('=============================== 계정생성 ===============================')
codef_account_create_url = 'https://tapi.codef.io/v1/account/create'
codef_account_create_body = {
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

# CODEF API 요청
response_account_create = http_sender(codef_account_create_url, token, codef_account_create_body)
if response_account_create.code == '200'
  puts('정상처리')
# token error
elsif response_account_create.code == '401'
    dict = JSON.parse(response_account_create.body)

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
        response = http_sender(codef_account_create_url, token, codef_account_create_body)
        puts('계정추가 정상처리')
    else
        puts('토큰발급 오류')
    end
else
    puts('계정생성 오류')
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

# CODEF API 요청
response_account_add = http_sender(codef_account_add_url, token, codef_account_add_body)
if response_account_add.code == '200'
  puts('정상처리')
# token error
elsif response_account_add.code == '401'
    dict = JSON.parse(response_account_add.body)

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
        response = http_sender(codef_account_add_url, token, codef_account_add_body)
        puts('계정추가 정상처리')
    else
        puts('토큰발급 오류')
    end
else
    puts('계정추가 오류')
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

# CODEF API 요청
response_account_update = http_sender(codef_account_update_url, token, codef_account_update_body)
if response_account_update.code == '200'
  puts('정상처리')
# token error
elsif response_account_update.code == '401'
    dict = JSON.parse(response_account_add.body)

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
        response = http_sender(codef_account_update_url, token, codef_account_update_body)
        puts('계정수정 정상처리')
    else
        puts('토큰발급 오류')
    end
else
    puts('계정수정 오류')
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

# CODEF API 요청
response_account_delete = http_sender(codef_account_delete_url, token, codef_account_delete_body)
if response_account_delete.code == '200'
  puts('정상처리')
# token error
elsif response_account_delete.code == '401'
    dict = JSON.parse(response_account_add.body)

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
        response = http_sender(codef_account_delete_url, token, codef_account_delete_body)
        puts('계정수정 정상처리')
    else
        puts('토큰발급 오류')
    end
else
    puts('계정수정 오류')
end
