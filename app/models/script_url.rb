require 'open-uri'

class ScriptUrl < ApplicationRecord

  class << self
    def minify_javascripts
      contents = ''

      javascripts = ScriptUrl.javscripts.not_ignored

      javascripts.each do |javascript|
        file = Net::HTTP.get(URI.parse(javascript.url))
        contents += ";" + file
      end

      Uglifier.compile(contents.force_encoding('UTF-8'))
    end

    def minify_stylesheets
      contents = ''

      javascripts = ScriptUrl.stylesheets.not_ignored

      javascripts.each do |javascript|
        file = Net::HTTP.get(URI.parse(javascript.url))
        contents += ";" + file
      end

      engine = Sass::Engine.new(contents, {
        syntax: :scss, style: :compressed
      })
      engine.render
    end

    def stylesheets
      where(category: 'text/css').order(position: :asc)
    end

    def javscripts
      where(category: 'application/javascript').order(position: :asc)
    end

    def not_ignored
      where(ignored: false)
    end

    def with_shop(shop_id)
      where(shop_id: shop_id)
    end
  end
end
