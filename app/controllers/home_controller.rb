class HomeController < ShopifyApp::AuthenticatedController
  def index
    p session[:shopify_user]

    js_content_type = 'application/javascript'
    css_content_type = 'application/javascript'

    scripts = []
    ShopifyAPI::Asset.find(:all).each do |asset|
      if asset.content_type == css_content_type || asset.content_type == js_content_type
        scripts << ScriptUrl.find_or_initialize_by(url: asset.public_url, category: asset.content_type)
      end
    end

    # existing_scripts = ScriptUrl.

    @js_scripts = scripts.select {|s| s.category == js_content_type && !s.ignored? }
    @ignored_js_scripts = scripts.select {|s| s.category == js_content_type && s.ignored?}

    @css_scripts = scripts.select {|s| s.category == css_content_type}
  end

  def save
  end

  def update
    if params[:script_url][:id].present?
      @script_url = ScriptUrl.find(params[:script_url][:id])
      @script_url.update!(script_url_params)
    else
      @script_url = ScriptUrl.create(script_url_params)
    end
    render json: @script_url
  end

  def script_url_params
    params.require(:script_url).permit(:id, :url, :ignored, :category)
  end
end

# @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
# @webhooks = ShopifyAPI::Webhook.find(:all)
# @assets = ShopifyAPI::Asset.find(:all)
# @script_tags = ShopifyAPI::ScriptTag.find(:all)

# themes/create, themes/delete, themes/publish, themes/update
#<ShopifyAPI::Webhook:0x007f8dd2635300 @attributes={"topic"=>"themes/update", "format"=>"json", "address"=>"https://speedy.ngrok.io/webhooks", "id"=>49758634012, "created_at"=>"2017-10-22T11:16:33-04:00", "updated_at"=>"2017-10-22T11:16:33-04:00", "fields"=>[], "metafield_namespaces"=>[]}, @prefix_options={}, @persisted=true, @remote_errors=nil, @validation_context=nil, @errors=#<ActiveResource::Errors:0x007f8dd2634e78 @base=#<ShopifyAPI::Webhook:0x007f8dd2635300 ...>, @messages={}, @details={}>>
# w = ShopifyAPI::Webhook.create(
#   topic: "themes/update",
#   format: "json",
#   address: "https://speedy.ngrok.io/webhooks"
# )
# p w
# p 'eeeeeee'
#
# w = ShopifyAPI::ScriptTag.create(
#   event: "onload",
#   src: "https://djavaskripped.org/fancy.js"
# )
# p w
# p 'eeeeeee'
#
# "https://djavaskripped.org/fancy.js"
