require_relative 'nans/niconico'
require 'dotenv'
require 'slack-notifier'

Dotenv.load
module Nans
  def self.niconico
    @niconico ||= Niconico.instance
  end

  def self.slack
    @slack ||= Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
  end
end
