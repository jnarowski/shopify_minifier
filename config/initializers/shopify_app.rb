ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "ff994d7e23ff84d30594d7d83fe07786"
  config.secret = "4ed9e88b25a3182a472532bb8c734ea1"
  config.scope = "read_orders, read_products, read_themes, write_themes, read_script_tags, write_script_tags"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
