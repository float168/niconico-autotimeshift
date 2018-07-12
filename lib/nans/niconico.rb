require 'mechanize'
require 'singleton'
require 'uri'

module Nans
  class Niconico
    include Singleton
    URL = {
      login: 'https://secure.nicovideo.jp/secure/login?site=niconico',
      search: 'http://api.search.nicovideo.jp/api/',
      reserve: 'http://live.nicovideo.jp/api/watchingreservation',
      list: 'http://live.nicovideo.jp/my',
      content: 'https://live.nicovideo.jp/gate'
    }

    attr_reader :agent, :logined

    def initialize
      @logined = false

      @agent = Mechanize.new
      @agent.ssl_version = 'TLSv1'
    end

    def login
      page = @agent.post(URL[:login], 'mail' => ENV['NICONICO_EMAIL'], 'password' => ENV['NICONICO_PASSWORD'])

      raise LoginError, "Failed to login (x-niconico-authflag is 0)" if page.header["x-niconico-authflag"] == '0'
      @logined = true
    end

    def logout
      Ayaneru.niconico.agent.cookie_jar.clear!
      @logined = false
    end

    def self.buildContentURL(lv)
      URL[:content] + '/' + lv
    end
  end
  class LoginError < StandardError; end
end

require_relative 'niconico/search'
require_relative 'niconico/reserve'
