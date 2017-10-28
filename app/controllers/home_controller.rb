class HomeController < ShopifyApp::AuthenticatedController
  def index
    # p 'deee'
    # p shop_session.url
    # p 'deeee'
    # ss = ShopifyAPI::Shop.where(url: shop_session.url).first
    # p ss
    # p 'deeee'

    js_content_type = 'application/javascript'
    css_content_type = 'text/css'

    scripts = []
    ShopifyAPI::Asset.find(:all).each do |asset|
      if asset.content_type == css_content_type || asset.content_type == js_content_type
        script = ScriptUrl.find_or_initialize_by(url: asset.public_url, category: asset.content_type)
        if script.new_record?
          script.position = 999
        end
        scripts << script
      end
    end

    ScriptUrl.all.each do |local_script|
      unless scripts.detect{|s| s.url == local_script.url }
        scripts << local_script
      end
    end

    @js_scripts = scripts.select {|s| s.category == js_content_type && !s.ignored? }.sort_by { |hsh| hsh.position }
    @ignored_js_scripts = scripts.select {|s| s.category == js_content_type && s.ignored? }.sort_by { |hsh| hsh.position }

    @css_scripts = scripts.select {|s| s.category == css_content_type && !s.ignored? }.sort_by { |hsh| hsh.position }
    @ignored_css_scripts = scripts.select {|s| s.category == css_content_type && s.ignored? }.sort_by { |hsh| hsh.position }
  end

  def save_all
    params[:script_url].each do |script|
      next if script[:url].blank?

      script_url = ScriptUrl.find_or_initialize_by(
        url: script[:url],
        category: script[:category]
      )
      script_url.position = script[:position]
      script_url.save
    end
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

  def destroy
    @script_url = ScriptUrl.find(params[:id])
    @script_url.destroy
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
