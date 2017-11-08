class ShopifyController < ShopifyApp::AuthenticatedController
  layout 'application'

  def current_shop
    @shop ||= Shop.find(session[:shopify])
  end
end
