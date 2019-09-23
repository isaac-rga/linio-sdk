require 'linio/api/version'
require 'linio/api/client'
require 'linio/api/request_signer'
require 'linio/api/request'
require 'linio/api/response'

module Linio
  module Api
    def self.root
      File.expand_path('../..', __dir__)
    end
  end
end
