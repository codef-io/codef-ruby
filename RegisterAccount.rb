RUBY_DESCRIPTION

require 'net/http'
require 'uri'
require 'json'
require 'base64'
require 'uri'

# ========== HTTP 기본 함수 ==========
def http_sender(url, token, body)
  puts('========== http_sender ========== ')
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
  puts('========== request_token ========== ')
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
                    'organization':'0003',
                    'loginType':'0',
                    'password':'',      # 인증서 비밀번호 입력
                    'derFile':'MIIFxjCCBK6gAwIBAgIEAUFs7jANBgkqhkiG9w0BAQsFADBPMQswCQYDVQQGEwJLUjESMBAGA1UECgwJQ3Jvc3NDZXJ0MRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFTATBgNVBAMMDENyb3NzQ2VydENBMzAeFw0xOTA0MTEwNjE0MDBaFw0yMDA4MjAxNDU5NTlaMHwxCzAJBgNVBAYTAktSMRIwEAYDVQQKDAlDcm9zc0NlcnQxFTATBgNVBAsMDEFjY3JlZGl0ZWRDQTEbMBkGA1UECwwS7ZWc6rWt7KCE7J6Q7J247KadMQ8wDQYDVQQLDAbrspXsnbgxFDASBgNVBAMMCyjso7wp7Z2s64KoMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1et/FXFaH/1SPZyrmChXzzlZVPR9N02OjfBvAH0QS+75qwoNDyMxOCWw9WTbKPbjdEGr/t7A+tqr82ft42Fg6+TDqG2iHxjhHn8Xqe8LUEjb4aE31q9Ll9ORzq5aONsDv01zpor4QMXEA2Ma/CmjuhtReB+caa1ps6th7hZ2tdNMQv8y8y9Vfv33j7DL2TV5y5nt4Qus1bM/cpJTp5DB+v5QiZ3zAbymhxO/zDd6+QIumjc3ZHA218fXpZcYUGvQsnJ5wn/0oh3D/hbOAu8rzuCD6u8MGMaUUne5AlVfH7qmwhRGPd05E4GlTQNCNkTeL7iq/ghNa0G5/pdTdMA4GwIDAQABo4ICezCCAncwgY8GA1UdIwSBhzCBhIAUQ9bzZX9lnc1rwc5zCr8yEKBR5xGhaKRmMGQxCzAJBgNVBAYTAktSMQ0wCwYDVQQKDARLSVNBMS4wLAYDVQQLDCVLb3JlYSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSBDZW50cmFsMRYwFAYDVQQDDA1LSVNBIFJvb3RDQSA0ggIQHjAdBgNVHQ4EFgQUrmZgseTWu9vZvke7s3/v3+va5IUwDgYDVR0PAQH/BAQDAgbAMH8GA1UdIAEB/wR1MHMwcQYKKoMajJpEBQQBAjBjMC0GCCsGAQUFBwIBFiFodHRwOi8vZ2NhLmNyb3NzY2VydC5jb20vY3BzLmh0bWwwMgYIKwYBBQUHAgIwJh4kx3QAIMd4yZ3BHLKUACCs9cd4ACDHeMmdwRwAIMeFssiy5AAuMGoGA1UdEQRjMGGgXwYJKoMajJpECgEBoFIwUAwLKOyjvCntnazrgqgwQTA/BgoqgxqMmkQKAQEBMDEwCwYJYIZIAWUDBAIBoCIEIPNcFlxaMKhfliMTh5PoKHaZAeM3bzSlGXRVbAkQ2DWbMH8GA1UdHwR4MHYwdKByoHCGbmxkYXA6Ly9kaXIuY3Jvc3NjZXJ0LmNvbTozODkvY249czFkcDEwcDcwOSxvdT1jcmxkcCxvdT1BY2NyZWRpdGVkQ0Esbz1Dcm9zc0NlcnQsYz1LUj9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0MEYGCCsGAQUFBwEBBDowODA2BggrBgEFBQcwAYYqaHR0cDovL29jc3AuY3Jvc3NjZXJ0LmNvbToxNDIwMy9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBCwUAA4IBAQCdXnCVDusDd/OybQum1v7DPZLQt3uv9Nuj50A03a7VCIPoHH2zWSdLhuPRpssuseNNj8resQHuOnhGPQa4hjL6lWAK+hR2jZGMiB63jNHz/SlCnrJtCuOJcgOsKBgr8/oDuiZ5WFST35P9jaQkuq7NEcGkQPrHyZZsTKyAhT2+t87hXHVgqJEP1XgPdXW5uDDn9GQRZOHjT4F7U3WfuWy8Whx1iT8lK/EP9/sYTbjnoVCuqdms7xhYmsDdvEBw37zhmfHs4sA2bmiiUl4gcBw/H9GbFFCsMUMKHeMPzr15Wz8qW5533s2uOvBNRaBZNn/SPBgREy6eKKWdVnVyRE5I',
                    'keyFile':'MIIFPjBIBgkqhkiG9w0BBQ0wOzAbBgkqhkiG9w0BBQwwDgQIS5nLMjlldfUCAggAMBwGCCqDGoyaRAEEBBDq5Nu5o9POLsez7yUgreDLBIIE8LrujpQJMLu1drtsBupaihmA4SFa7mJHoo+4ZGzA/8WfdnX64G0dXSyfUCi7wXq9vY/hCyGSmuM6XhWP4FIMnQlb5R5HH4mC1a5Y0dt7dWAhEzF+eHplYsbVRl34KSLWWxG1qGnaeG4ypyo29cInOJt9mkIl1ht45d0gQvLwP1EnniSxcMfKeov/NO+iHM3RW/o8ZSFJD9DBPskXxittZR1zdhrAmmJBTiEp0sOYl8Q1940IYox+LoWYOwO7JA354TVsZKBSu2Va2WQ8dQlkTC/qztxu3EXy4jyQtv3vOmUUdUWsmTdmYq8r/75YQo41EnbjxqctCpA2jrtvlMfaRATlOAoO+e/ZHG93d4NZfC9ghLlprXcnkJ/r8V7181Zsnj2kfiCCz9MLVlZwuPypEzSW0KLHC3ucEWmD0TSZsRri/pcu3H0LfUt+6COO96nRtT9r2VIBfxYz78nvCjZgGDLYSLy6RHDxBQZG0hGiOuXVYvcJSgPcaM/G0uoBtCUl6RrpHINdNzIEpIkiTiB6zZdr+dwBygVAw88A52HcGqko6ZeMERMGqSjH033homa53CSMjT3MpAc5Z1Rxx0NvYktY8DiOS5Wg+6CLJyTGk2zoXTj/cs1OeSU3uHx2Q8ejQHAAyi6djzsH+DHvcCQnjtbXZyVBl7XqOp6PqPUn/JwufKqa2x/Qh3vtC/46ZdaF6vkh39PgMrTNUQAdh6FNhW6ZzMQ+82FD0gUfqtycZvM7eiPvUXMyWSeWNxbi4/aAUM/e+fQMaPaD01gKDQ/5owl4R7ADrWnJUu/mnBq9aoX+QJLmuyKTsFS0jOxOIU8q+2V3mTA+wyf7WIPkXPr7aty38yFuvSWvP5isOSEOfWVqerb8sq5tNeXKZkl+QywIA6bwgQ0aWqVTzRf+P40q/YLzMJQgG+7qY2a/xwJdLn7tYaGUj+Ui1CjkGyR2LqQ2Kb2cNRpLa77mF0yt+YrVgoP48yl+TZ6NKIl0I3LsViKbrL+WPBrCTc91wdfcbyHLnEabVY7nXTYQh6RIjM5gDDiJFGiAghFDX9GJXuRSLV0UzV2suB1dkPpQPUHnJNg5arQJyVOrpAOD0CaElJW+C3kkmwBbVeeGWM+RXbUvDstIFRc2I0eLytP6lQ5V2Z+h9LZJ4co3juPi5UOHqNysSvifVp8O+Kq0rWNGC/YZBefqOUax21eLwAW+kT8QsmfHOIuvzMx4yMug7SOt8sJmO8rno8IY3v/vdaNeQ+7P0Oz0fyfgY34Giisk1Y/KzIjt2Q89F5V5yQClgsPMNbGb2HJMU5Pc3CgdxWwWw2geT8rBcsdPFQQ9WBYd+cjVKrMX99HrOsZF1pazT87LqycLlxf8JoBLgZ7DFIah9vhc93nA1XNaDhLusKvQLZk90BA1B7CykBDSeDfE9uRVtHGJsEG7g4zwH35MyP0wu47JW+BNIOnMI4eBJs+eWPU2KM5pruEdmO7vzjER3rP57hdJhtG7i+2cBXpVu1RtekBj3glggTHnyt68wHoYLrtagF1Ug08dfq4ssC03c6bPyxAWJiq7WoV/sfancqYQuLorYaC+Q6b/Gm98/U4hoEWIB/9iRa3JYnFN2egxc2XnGmr6BE57HZ6s8KRjG9EIpUsc9jkJzvdfvYfcnh/o/lrSyReD4UFuTqU5hh21ALeeK6PuAF0='
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
    response_oauth = request_token(token_url, "codef_master", "codef_master_secret");
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
                    'organization':'0003',
                    'loginType':'0',
                    'password':'',      # 인증서 비밀번호 입력
                    'derFile':'MIIFxjCCBK6gAwIBAgIEAUFs7jANBgkqhkiG9w0BAQsFADBPMQswCQYDVQQGEwJLUjESMBAGA1UECgwJQ3Jvc3NDZXJ0MRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFTATBgNVBAMMDENyb3NzQ2VydENBMzAeFw0xOTA0MTEwNjE0MDBaFw0yMDA4MjAxNDU5NTlaMHwxCzAJBgNVBAYTAktSMRIwEAYDVQQKDAlDcm9zc0NlcnQxFTATBgNVBAsMDEFjY3JlZGl0ZWRDQTEbMBkGA1UECwwS7ZWc6rWt7KCE7J6Q7J247KadMQ8wDQYDVQQLDAbrspXsnbgxFDASBgNVBAMMCyjso7wp7Z2s64KoMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1et/FXFaH/1SPZyrmChXzzlZVPR9N02OjfBvAH0QS+75qwoNDyMxOCWw9WTbKPbjdEGr/t7A+tqr82ft42Fg6+TDqG2iHxjhHn8Xqe8LUEjb4aE31q9Ll9ORzq5aONsDv01zpor4QMXEA2Ma/CmjuhtReB+caa1ps6th7hZ2tdNMQv8y8y9Vfv33j7DL2TV5y5nt4Qus1bM/cpJTp5DB+v5QiZ3zAbymhxO/zDd6+QIumjc3ZHA218fXpZcYUGvQsnJ5wn/0oh3D/hbOAu8rzuCD6u8MGMaUUne5AlVfH7qmwhRGPd05E4GlTQNCNkTeL7iq/ghNa0G5/pdTdMA4GwIDAQABo4ICezCCAncwgY8GA1UdIwSBhzCBhIAUQ9bzZX9lnc1rwc5zCr8yEKBR5xGhaKRmMGQxCzAJBgNVBAYTAktSMQ0wCwYDVQQKDARLSVNBMS4wLAYDVQQLDCVLb3JlYSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSBDZW50cmFsMRYwFAYDVQQDDA1LSVNBIFJvb3RDQSA0ggIQHjAdBgNVHQ4EFgQUrmZgseTWu9vZvke7s3/v3+va5IUwDgYDVR0PAQH/BAQDAgbAMH8GA1UdIAEB/wR1MHMwcQYKKoMajJpEBQQBAjBjMC0GCCsGAQUFBwIBFiFodHRwOi8vZ2NhLmNyb3NzY2VydC5jb20vY3BzLmh0bWwwMgYIKwYBBQUHAgIwJh4kx3QAIMd4yZ3BHLKUACCs9cd4ACDHeMmdwRwAIMeFssiy5AAuMGoGA1UdEQRjMGGgXwYJKoMajJpECgEBoFIwUAwLKOyjvCntnazrgqgwQTA/BgoqgxqMmkQKAQEBMDEwCwYJYIZIAWUDBAIBoCIEIPNcFlxaMKhfliMTh5PoKHaZAeM3bzSlGXRVbAkQ2DWbMH8GA1UdHwR4MHYwdKByoHCGbmxkYXA6Ly9kaXIuY3Jvc3NjZXJ0LmNvbTozODkvY249czFkcDEwcDcwOSxvdT1jcmxkcCxvdT1BY2NyZWRpdGVkQ0Esbz1Dcm9zc0NlcnQsYz1LUj9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0MEYGCCsGAQUFBwEBBDowODA2BggrBgEFBQcwAYYqaHR0cDovL29jc3AuY3Jvc3NjZXJ0LmNvbToxNDIwMy9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBCwUAA4IBAQCdXnCVDusDd/OybQum1v7DPZLQt3uv9Nuj50A03a7VCIPoHH2zWSdLhuPRpssuseNNj8resQHuOnhGPQa4hjL6lWAK+hR2jZGMiB63jNHz/SlCnrJtCuOJcgOsKBgr8/oDuiZ5WFST35P9jaQkuq7NEcGkQPrHyZZsTKyAhT2+t87hXHVgqJEP1XgPdXW5uDDn9GQRZOHjT4F7U3WfuWy8Whx1iT8lK/EP9/sYTbjnoVCuqdms7xhYmsDdvEBw37zhmfHs4sA2bmiiUl4gcBw/H9GbFFCsMUMKHeMPzr15Wz8qW5533s2uOvBNRaBZNn/SPBgREy6eKKWdVnVyRE5I',
                    'keyFile':'MIIFPjBIBgkqhkiG9w0BBQ0wOzAbBgkqhkiG9w0BBQwwDgQIS5nLMjlldfUCAggAMBwGCCqDGoyaRAEEBBDq5Nu5o9POLsez7yUgreDLBIIE8LrujpQJMLu1drtsBupaihmA4SFa7mJHoo+4ZGzA/8WfdnX64G0dXSyfUCi7wXq9vY/hCyGSmuM6XhWP4FIMnQlb5R5HH4mC1a5Y0dt7dWAhEzF+eHplYsbVRl34KSLWWxG1qGnaeG4ypyo29cInOJt9mkIl1ht45d0gQvLwP1EnniSxcMfKeov/NO+iHM3RW/o8ZSFJD9DBPskXxittZR1zdhrAmmJBTiEp0sOYl8Q1940IYox+LoWYOwO7JA354TVsZKBSu2Va2WQ8dQlkTC/qztxu3EXy4jyQtv3vOmUUdUWsmTdmYq8r/75YQo41EnbjxqctCpA2jrtvlMfaRATlOAoO+e/ZHG93d4NZfC9ghLlprXcnkJ/r8V7181Zsnj2kfiCCz9MLVlZwuPypEzSW0KLHC3ucEWmD0TSZsRri/pcu3H0LfUt+6COO96nRtT9r2VIBfxYz78nvCjZgGDLYSLy6RHDxBQZG0hGiOuXVYvcJSgPcaM/G0uoBtCUl6RrpHINdNzIEpIkiTiB6zZdr+dwBygVAw88A52HcGqko6ZeMERMGqSjH033homa53CSMjT3MpAc5Z1Rxx0NvYktY8DiOS5Wg+6CLJyTGk2zoXTj/cs1OeSU3uHx2Q8ejQHAAyi6djzsH+DHvcCQnjtbXZyVBl7XqOp6PqPUn/JwufKqa2x/Qh3vtC/46ZdaF6vkh39PgMrTNUQAdh6FNhW6ZzMQ+82FD0gUfqtycZvM7eiPvUXMyWSeWNxbi4/aAUM/e+fQMaPaD01gKDQ/5owl4R7ADrWnJUu/mnBq9aoX+QJLmuyKTsFS0jOxOIU8q+2V3mTA+wyf7WIPkXPr7aty38yFuvSWvP5isOSEOfWVqerb8sq5tNeXKZkl+QywIA6bwgQ0aWqVTzRf+P40q/YLzMJQgG+7qY2a/xwJdLn7tYaGUj+Ui1CjkGyR2LqQ2Kb2cNRpLa77mF0yt+YrVgoP48yl+TZ6NKIl0I3LsViKbrL+WPBrCTc91wdfcbyHLnEabVY7nXTYQh6RIjM5gDDiJFGiAghFDX9GJXuRSLV0UzV2suB1dkPpQPUHnJNg5arQJyVOrpAOD0CaElJW+C3kkmwBbVeeGWM+RXbUvDstIFRc2I0eLytP6lQ5V2Z+h9LZJ4co3juPi5UOHqNysSvifVp8O+Kq0rWNGC/YZBefqOUax21eLwAW+kT8QsmfHOIuvzMx4yMug7SOt8sJmO8rno8IY3v/vdaNeQ+7P0Oz0fyfgY34Giisk1Y/KzIjt2Q89F5V5yQClgsPMNbGb2HJMU5Pc3CgdxWwWw2geT8rBcsdPFQQ9WBYd+cjVKrMX99HrOsZF1pazT87LqycLlxf8JoBLgZ7DFIah9vhc93nA1XNaDhLusKvQLZk90BA1B7CykBDSeDfE9uRVtHGJsEG7g4zwH35MyP0wu47JW+BNIOnMI4eBJs+eWPU2KM5pruEdmO7vzjER3rP57hdJhtG7i+2cBXpVu1RtekBj3glggTHnyt68wHoYLrtagF1Ug08dfq4ssC03c6bPyxAWJiq7WoV/sfancqYQuLorYaC+Q6b/Gm98/U4hoEWIB/9iRa3JYnFN2egxc2XnGmr6BE57HZ6s8KRjG9EIpUsc9jkJzvdfvYfcnh/o/lrSyReD4UFuTqU5hh21ALeeK6PuAF0='
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
    response_oauth = request_token(token_url, "codef_master", "codef_master_secret");
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
                    'organization':'0003',
                    'loginType':'0',
                    'password':'',      # 인증서 비밀번호 입력 - 수정할 데이터
                    'derFile':'MIIFxjCCBK6gAwIBAgIEAUFs7jANBgkqhkiG9w0BAQsFADBPMQswCQYDVQQGEwJLUjESMBAGA1UECgwJQ3Jvc3NDZXJ0MRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFTATBgNVBAMMDENyb3NzQ2VydENBMzAeFw0xOTA0MTEwNjE0MDBaFw0yMDA4MjAxNDU5NTlaMHwxCzAJBgNVBAYTAktSMRIwEAYDVQQKDAlDcm9zc0NlcnQxFTATBgNVBAsMDEFjY3JlZGl0ZWRDQTEbMBkGA1UECwwS7ZWc6rWt7KCE7J6Q7J247KadMQ8wDQYDVQQLDAbrspXsnbgxFDASBgNVBAMMCyjso7wp7Z2s64KoMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1et/FXFaH/1SPZyrmChXzzlZVPR9N02OjfBvAH0QS+75qwoNDyMxOCWw9WTbKPbjdEGr/t7A+tqr82ft42Fg6+TDqG2iHxjhHn8Xqe8LUEjb4aE31q9Ll9ORzq5aONsDv01zpor4QMXEA2Ma/CmjuhtReB+caa1ps6th7hZ2tdNMQv8y8y9Vfv33j7DL2TV5y5nt4Qus1bM/cpJTp5DB+v5QiZ3zAbymhxO/zDd6+QIumjc3ZHA218fXpZcYUGvQsnJ5wn/0oh3D/hbOAu8rzuCD6u8MGMaUUne5AlVfH7qmwhRGPd05E4GlTQNCNkTeL7iq/ghNa0G5/pdTdMA4GwIDAQABo4ICezCCAncwgY8GA1UdIwSBhzCBhIAUQ9bzZX9lnc1rwc5zCr8yEKBR5xGhaKRmMGQxCzAJBgNVBAYTAktSMQ0wCwYDVQQKDARLSVNBMS4wLAYDVQQLDCVLb3JlYSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSBDZW50cmFsMRYwFAYDVQQDDA1LSVNBIFJvb3RDQSA0ggIQHjAdBgNVHQ4EFgQUrmZgseTWu9vZvke7s3/v3+va5IUwDgYDVR0PAQH/BAQDAgbAMH8GA1UdIAEB/wR1MHMwcQYKKoMajJpEBQQBAjBjMC0GCCsGAQUFBwIBFiFodHRwOi8vZ2NhLmNyb3NzY2VydC5jb20vY3BzLmh0bWwwMgYIKwYBBQUHAgIwJh4kx3QAIMd4yZ3BHLKUACCs9cd4ACDHeMmdwRwAIMeFssiy5AAuMGoGA1UdEQRjMGGgXwYJKoMajJpECgEBoFIwUAwLKOyjvCntnazrgqgwQTA/BgoqgxqMmkQKAQEBMDEwCwYJYIZIAWUDBAIBoCIEIPNcFlxaMKhfliMTh5PoKHaZAeM3bzSlGXRVbAkQ2DWbMH8GA1UdHwR4MHYwdKByoHCGbmxkYXA6Ly9kaXIuY3Jvc3NjZXJ0LmNvbTozODkvY249czFkcDEwcDcwOSxvdT1jcmxkcCxvdT1BY2NyZWRpdGVkQ0Esbz1Dcm9zc0NlcnQsYz1LUj9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0MEYGCCsGAQUFBwEBBDowODA2BggrBgEFBQcwAYYqaHR0cDovL29jc3AuY3Jvc3NjZXJ0LmNvbToxNDIwMy9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBCwUAA4IBAQCdXnCVDusDd/OybQum1v7DPZLQt3uv9Nuj50A03a7VCIPoHH2zWSdLhuPRpssuseNNj8resQHuOnhGPQa4hjL6lWAK+hR2jZGMiB63jNHz/SlCnrJtCuOJcgOsKBgr8/oDuiZ5WFST35P9jaQkuq7NEcGkQPrHyZZsTKyAhT2+t87hXHVgqJEP1XgPdXW5uDDn9GQRZOHjT4F7U3WfuWy8Whx1iT8lK/EP9/sYTbjnoVCuqdms7xhYmsDdvEBw37zhmfHs4sA2bmiiUl4gcBw/H9GbFFCsMUMKHeMPzr15Wz8qW5533s2uOvBNRaBZNn/SPBgREy6eKKWdVnVyRE5I',
                    'keyFile':'MIIFPjBIBgkqhkiG9w0BBQ0wOzAbBgkqhkiG9w0BBQwwDgQIS5nLMjlldfUCAggAMBwGCCqDGoyaRAEEBBDq5Nu5o9POLsez7yUgreDLBIIE8LrujpQJMLu1drtsBupaihmA4SFa7mJHoo+4ZGzA/8WfdnX64G0dXSyfUCi7wXq9vY/hCyGSmuM6XhWP4FIMnQlb5R5HH4mC1a5Y0dt7dWAhEzF+eHplYsbVRl34KSLWWxG1qGnaeG4ypyo29cInOJt9mkIl1ht45d0gQvLwP1EnniSxcMfKeov/NO+iHM3RW/o8ZSFJD9DBPskXxittZR1zdhrAmmJBTiEp0sOYl8Q1940IYox+LoWYOwO7JA354TVsZKBSu2Va2WQ8dQlkTC/qztxu3EXy4jyQtv3vOmUUdUWsmTdmYq8r/75YQo41EnbjxqctCpA2jrtvlMfaRATlOAoO+e/ZHG93d4NZfC9ghLlprXcnkJ/r8V7181Zsnj2kfiCCz9MLVlZwuPypEzSW0KLHC3ucEWmD0TSZsRri/pcu3H0LfUt+6COO96nRtT9r2VIBfxYz78nvCjZgGDLYSLy6RHDxBQZG0hGiOuXVYvcJSgPcaM/G0uoBtCUl6RrpHINdNzIEpIkiTiB6zZdr+dwBygVAw88A52HcGqko6ZeMERMGqSjH033homa53CSMjT3MpAc5Z1Rxx0NvYktY8DiOS5Wg+6CLJyTGk2zoXTj/cs1OeSU3uHx2Q8ejQHAAyi6djzsH+DHvcCQnjtbXZyVBl7XqOp6PqPUn/JwufKqa2x/Qh3vtC/46ZdaF6vkh39PgMrTNUQAdh6FNhW6ZzMQ+82FD0gUfqtycZvM7eiPvUXMyWSeWNxbi4/aAUM/e+fQMaPaD01gKDQ/5owl4R7ADrWnJUu/mnBq9aoX+QJLmuyKTsFS0jOxOIU8q+2V3mTA+wyf7WIPkXPr7aty38yFuvSWvP5isOSEOfWVqerb8sq5tNeXKZkl+QywIA6bwgQ0aWqVTzRf+P40q/YLzMJQgG+7qY2a/xwJdLn7tYaGUj+Ui1CjkGyR2LqQ2Kb2cNRpLa77mF0yt+YrVgoP48yl+TZ6NKIl0I3LsViKbrL+WPBrCTc91wdfcbyHLnEabVY7nXTYQh6RIjM5gDDiJFGiAghFDX9GJXuRSLV0UzV2suB1dkPpQPUHnJNg5arQJyVOrpAOD0CaElJW+C3kkmwBbVeeGWM+RXbUvDstIFRc2I0eLytP6lQ5V2Z+h9LZJ4co3juPi5UOHqNysSvifVp8O+Kq0rWNGC/YZBefqOUax21eLwAW+kT8QsmfHOIuvzMx4yMug7SOt8sJmO8rno8IY3v/vdaNeQ+7P0Oz0fyfgY34Giisk1Y/KzIjt2Q89F5V5yQClgsPMNbGb2HJMU5Pc3CgdxWwWw2geT8rBcsdPFQQ9WBYd+cjVKrMX99HrOsZF1pazT87LqycLlxf8JoBLgZ7DFIah9vhc93nA1XNaDhLusKvQLZk90BA1B7CykBDSeDfE9uRVtHGJsEG7g4zwH35MyP0wu47JW+BNIOnMI4eBJs+eWPU2KM5pruEdmO7vzjER3rP57hdJhtG7i+2cBXpVu1RtekBj3glggTHnyt68wHoYLrtagF1Ug08dfq4ssC03c6bPyxAWJiq7WoV/sfancqYQuLorYaC+Q6b/Gm98/U4hoEWIB/9iRa3JYnFN2egxc2XnGmr6BE57HZ6s8KRjG9EIpUsc9jkJzvdfvYfcnh/o/lrSyReD4UFuTqU5hh21ALeeK6PuAF0='
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
    response_oauth = request_token(token_url, "codef_master", "codef_master_secret");
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
                    'organization':'0003',
                    'loginType':'0',
                    'password':'',      # 인증서 비밀번호 입력
                    'derFile':'MIIFxjCCBK6gAwIBAgIEAUFs7jANBgkqhkiG9w0BAQsFADBPMQswCQYDVQQGEwJLUjESMBAGA1UECgwJQ3Jvc3NDZXJ0MRUwEwYDVQQLDAxBY2NyZWRpdGVkQ0ExFTATBgNVBAMMDENyb3NzQ2VydENBMzAeFw0xOTA0MTEwNjE0MDBaFw0yMDA4MjAxNDU5NTlaMHwxCzAJBgNVBAYTAktSMRIwEAYDVQQKDAlDcm9zc0NlcnQxFTATBgNVBAsMDEFjY3JlZGl0ZWRDQTEbMBkGA1UECwwS7ZWc6rWt7KCE7J6Q7J247KadMQ8wDQYDVQQLDAbrspXsnbgxFDASBgNVBAMMCyjso7wp7Z2s64KoMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1et/FXFaH/1SPZyrmChXzzlZVPR9N02OjfBvAH0QS+75qwoNDyMxOCWw9WTbKPbjdEGr/t7A+tqr82ft42Fg6+TDqG2iHxjhHn8Xqe8LUEjb4aE31q9Ll9ORzq5aONsDv01zpor4QMXEA2Ma/CmjuhtReB+caa1ps6th7hZ2tdNMQv8y8y9Vfv33j7DL2TV5y5nt4Qus1bM/cpJTp5DB+v5QiZ3zAbymhxO/zDd6+QIumjc3ZHA218fXpZcYUGvQsnJ5wn/0oh3D/hbOAu8rzuCD6u8MGMaUUne5AlVfH7qmwhRGPd05E4GlTQNCNkTeL7iq/ghNa0G5/pdTdMA4GwIDAQABo4ICezCCAncwgY8GA1UdIwSBhzCBhIAUQ9bzZX9lnc1rwc5zCr8yEKBR5xGhaKRmMGQxCzAJBgNVBAYTAktSMQ0wCwYDVQQKDARLSVNBMS4wLAYDVQQLDCVLb3JlYSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSBDZW50cmFsMRYwFAYDVQQDDA1LSVNBIFJvb3RDQSA0ggIQHjAdBgNVHQ4EFgQUrmZgseTWu9vZvke7s3/v3+va5IUwDgYDVR0PAQH/BAQDAgbAMH8GA1UdIAEB/wR1MHMwcQYKKoMajJpEBQQBAjBjMC0GCCsGAQUFBwIBFiFodHRwOi8vZ2NhLmNyb3NzY2VydC5jb20vY3BzLmh0bWwwMgYIKwYBBQUHAgIwJh4kx3QAIMd4yZ3BHLKUACCs9cd4ACDHeMmdwRwAIMeFssiy5AAuMGoGA1UdEQRjMGGgXwYJKoMajJpECgEBoFIwUAwLKOyjvCntnazrgqgwQTA/BgoqgxqMmkQKAQEBMDEwCwYJYIZIAWUDBAIBoCIEIPNcFlxaMKhfliMTh5PoKHaZAeM3bzSlGXRVbAkQ2DWbMH8GA1UdHwR4MHYwdKByoHCGbmxkYXA6Ly9kaXIuY3Jvc3NjZXJ0LmNvbTozODkvY249czFkcDEwcDcwOSxvdT1jcmxkcCxvdT1BY2NyZWRpdGVkQ0Esbz1Dcm9zc0NlcnQsYz1LUj9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0MEYGCCsGAQUFBwEBBDowODA2BggrBgEFBQcwAYYqaHR0cDovL29jc3AuY3Jvc3NjZXJ0LmNvbToxNDIwMy9PQ1NQU2VydmVyMA0GCSqGSIb3DQEBCwUAA4IBAQCdXnCVDusDd/OybQum1v7DPZLQt3uv9Nuj50A03a7VCIPoHH2zWSdLhuPRpssuseNNj8resQHuOnhGPQa4hjL6lWAK+hR2jZGMiB63jNHz/SlCnrJtCuOJcgOsKBgr8/oDuiZ5WFST35P9jaQkuq7NEcGkQPrHyZZsTKyAhT2+t87hXHVgqJEP1XgPdXW5uDDn9GQRZOHjT4F7U3WfuWy8Whx1iT8lK/EP9/sYTbjnoVCuqdms7xhYmsDdvEBw37zhmfHs4sA2bmiiUl4gcBw/H9GbFFCsMUMKHeMPzr15Wz8qW5533s2uOvBNRaBZNn/SPBgREy6eKKWdVnVyRE5I',
                    'keyFile':'MIIFPjBIBgkqhkiG9w0BBQ0wOzAbBgkqhkiG9w0BBQwwDgQIS5nLMjlldfUCAggAMBwGCCqDGoyaRAEEBBDq5Nu5o9POLsez7yUgreDLBIIE8LrujpQJMLu1drtsBupaihmA4SFa7mJHoo+4ZGzA/8WfdnX64G0dXSyfUCi7wXq9vY/hCyGSmuM6XhWP4FIMnQlb5R5HH4mC1a5Y0dt7dWAhEzF+eHplYsbVRl34KSLWWxG1qGnaeG4ypyo29cInOJt9mkIl1ht45d0gQvLwP1EnniSxcMfKeov/NO+iHM3RW/o8ZSFJD9DBPskXxittZR1zdhrAmmJBTiEp0sOYl8Q1940IYox+LoWYOwO7JA354TVsZKBSu2Va2WQ8dQlkTC/qztxu3EXy4jyQtv3vOmUUdUWsmTdmYq8r/75YQo41EnbjxqctCpA2jrtvlMfaRATlOAoO+e/ZHG93d4NZfC9ghLlprXcnkJ/r8V7181Zsnj2kfiCCz9MLVlZwuPypEzSW0KLHC3ucEWmD0TSZsRri/pcu3H0LfUt+6COO96nRtT9r2VIBfxYz78nvCjZgGDLYSLy6RHDxBQZG0hGiOuXVYvcJSgPcaM/G0uoBtCUl6RrpHINdNzIEpIkiTiB6zZdr+dwBygVAw88A52HcGqko6ZeMERMGqSjH033homa53CSMjT3MpAc5Z1Rxx0NvYktY8DiOS5Wg+6CLJyTGk2zoXTj/cs1OeSU3uHx2Q8ejQHAAyi6djzsH+DHvcCQnjtbXZyVBl7XqOp6PqPUn/JwufKqa2x/Qh3vtC/46ZdaF6vkh39PgMrTNUQAdh6FNhW6ZzMQ+82FD0gUfqtycZvM7eiPvUXMyWSeWNxbi4/aAUM/e+fQMaPaD01gKDQ/5owl4R7ADrWnJUu/mnBq9aoX+QJLmuyKTsFS0jOxOIU8q+2V3mTA+wyf7WIPkXPr7aty38yFuvSWvP5isOSEOfWVqerb8sq5tNeXKZkl+QywIA6bwgQ0aWqVTzRf+P40q/YLzMJQgG+7qY2a/xwJdLn7tYaGUj+Ui1CjkGyR2LqQ2Kb2cNRpLa77mF0yt+YrVgoP48yl+TZ6NKIl0I3LsViKbrL+WPBrCTc91wdfcbyHLnEabVY7nXTYQh6RIjM5gDDiJFGiAghFDX9GJXuRSLV0UzV2suB1dkPpQPUHnJNg5arQJyVOrpAOD0CaElJW+C3kkmwBbVeeGWM+RXbUvDstIFRc2I0eLytP6lQ5V2Z+h9LZJ4co3juPi5UOHqNysSvifVp8O+Kq0rWNGC/YZBefqOUax21eLwAW+kT8QsmfHOIuvzMx4yMug7SOt8sJmO8rno8IY3v/vdaNeQ+7P0Oz0fyfgY34Giisk1Y/KzIjt2Q89F5V5yQClgsPMNbGb2HJMU5Pc3CgdxWwWw2geT8rBcsdPFQQ9WBYd+cjVKrMX99HrOsZF1pazT87LqycLlxf8JoBLgZ7DFIah9vhc93nA1XNaDhLusKvQLZk90BA1B7CykBDSeDfE9uRVtHGJsEG7g4zwH35MyP0wu47JW+BNIOnMI4eBJs+eWPU2KM5pruEdmO7vzjER3rP57hdJhtG7i+2cBXpVu1RtekBj3glggTHnyt68wHoYLrtagF1Ug08dfq4ssC03c6bPyxAWJiq7WoV/sfancqYQuLorYaC+Q6b/Gm98/U4hoEWIB/9iRa3JYnFN2egxc2XnGmr6BE57HZ6s8KRjG9EIpUsc9jkJzvdfvYfcnh/o/lrSyReD4UFuTqU5hh21ALeeK6PuAF0='
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
    response_oauth = request_token(token_url, "codef_master", "codef_master_secret");
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
