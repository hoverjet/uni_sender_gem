require "uni_sender/version"
require 'uni_sender/camelize'
require 'net/http'
require 'json'
require 'active_support/core_ext/object/to_query'
require 'curb'

module UniSender

  class Client

    attr_accessor :api_key, :client_ip, :locale

    def initialize(api_key, params={})
      self.api_key = api_key
      params.each do |key, value|
        if defined?("#{key}=")
          self.send("#{key}=", value)
        end
      end
    end

    def locale
      @locale || 'en'
    end

    private

      def translate_params(params)
        params.inject({}) do |iparams, couple|
          iparams[couple.first] = case couple.last
          when Hash
            couple.last.each do |key, value|
              iparams["#{couple.first}[#{key}]"] = value.to_s
            end
          else
            couple.last
          end
          iparams
        end
      end

      def method_missing(undefined_action, *args, &block)
        params = (args.first.is_a?(Hash) ? args.first : {} )
        params.merge!({'api_key'=>api_key, 'format'=>'json'})
        default_request(undefined_action.to_s.camelize(false), params)
      end

      def default_request(action, params={})
        params = translate_params(params) if defined?('translate_params')
        url = "http://api.unisender.com/#{locale}/api/#{action}"
        JSON.parse(Curl::Easy.http_post(url, params.to_param).body_str)
      end

  end

end
