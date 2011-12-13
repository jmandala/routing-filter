# The Embed filter extracts an UUID segment from the beginning of the recognized
# path and exposes the page parameter as params[:page]. When a path is generated
# the filter adds the segments to the path accordingly if the page parameter is
# passed to the url helper.
#
#   incoming url: /embed/products
#   filtered url: /products
#   params:       params[:embed] = true
#
# You can install the filter like this:
#
#   # in config/routes.rb
#   Rails.application.routes.draw do
#     filter :embed
#   end
#
# To make your named_route helpers or url_for add the uuid segment you can use:
#
#   products_path(:embed => true)
#   url_for(:products, :embed => true)

module RoutingFilter
  class Embed < Filter
    EMBED_SEGMENT = %r(^/?embed(/)?)
    
    def around_recognize(path, env, &block)
      embed = extract_segment!(EMBED_SEGMENT, path)
      yield.tap do |params|
        params[:embed] = true if embed
      end
    end

    def around_generate(params, &block)
      embed = params.delete(:embed)
      yield.tap do |result|
        prepend_segment!(result, 'embed') if embed
      end
    end
  end
end