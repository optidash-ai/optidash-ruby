require "json"
require "rest-client"
require "uri"
require "optidash/version"
require "optidash/errors"
require "optidash/request"
require "optidash/response"
require "optidash/client"

module Optidash

    ##
    # Making Client constructor public
    # to avoid Optidash::Client.new invocation

    def self.new(*args)
        Client.new(*args)
    end
end