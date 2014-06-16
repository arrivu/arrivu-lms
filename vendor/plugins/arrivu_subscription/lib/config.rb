module PZ_Config

  MERCHANT_ID = "test_t1289" # Your Merchant ID
  SECRET_KEY = "277d23a3868b41aa75f057b5e5ef34600a66813c2561c3e9737ceadb0f985e00" # Your Secret Key. Do not share this.
  TRANSACTION_TYPE = "SALE"
  CURRENCY = "INR"
  UI_MODE = "REDIRECT" # UI Integration - REDIRECT or IFRAME
  HASH_METHOD = "SHA256" # MD5 or SHA256
  MERCHANT_KEY_ID = "payment" # Your Merchant Key ID
  CALLBACK_URL = "http://arrivu.lvh.me:4000/payments/success" # Your callback URL

  API_BASE = "https://www.payzippy.com/payment/api/"
  API_CHARGING = "charging"
  API_QUERY = "query"
  API_REFUND = "refund"
  API_VERSION = "v1"
  VERIFY_SSL_CERTS = true

end
