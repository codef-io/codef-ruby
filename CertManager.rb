require 'base64'

# ========== HTTP 기본 함수 ==========
def fileToBase64(filepath)
  data = File.open(filepath).read
  encoded = Base64.encode64(data)

  return encoded.delete("\n")
end
# ========== HTTP 함수  ==========

derFileB64 = fileToBase64('/Users/skcrackers/Documents/cobweb/Modules/modules/certification/ssk/signCert.der')
keyFileB64 = fileToBase64('/Users/skcrackers/Documents/cobweb/Modules/modules/certification/ssk/signPri.key')

puts('derFileB64 = ' + derFileB64)
puts('keyFileB64 = ' + keyFileB64)
