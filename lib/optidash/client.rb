module Optidash
    ##
    # Main Client class, responsible for entire interaction with the API

    class Client
        def initialize(api_key)
            @api_key = api_key
        end

        ##
        # Prepares Fetch request
        # @param url [String] web location of a file we wan't to transform via api

        def fetch(url)
            validate_request :fetch

            # initiating the request
            @request = Optidash::Request::Fetch.new(@api_key, @proxy)

            # and preparing data for the request
            @request.data[:url] = url
            self
        end


        ##
        # Prepares Upload request
        # @param path [String] local file path

        def upload(path)
            validate_request :upload

            # initiating the request
            @request = Optidash::Request::Upload.new(@api_key, path, @proxy)
            self
        end


        ##
        # Returns response containing only JSON metadata

        def to_json
            @request.perform
        end


        ##
        # Returns response containing JSON metadata and saves received binary file
        # @param path [String] file destination

        def to_file(path)
            if path.nil?
                raise Optidash::Errors::NoPathProvided, "No save path provided"
            end

            validate_binary_operations
            @request.perform(binary: true, save_path: path)
        end


        ##
        # Returns response containing JSON metadata and binary file buffer

        def to_buffer
            validate_binary_operations
            @request.perform(binary: true)
        end

        ##
        # Sets request proxy

        def proxy(url = nil)
            return self if url.nil?
            validate_url(url)
            # adding proxy if request instance already exists
            @request ? @request.proxy = url : @proxy = url
            self
        end


        ##
        # Meta programmed operation methods - every single one of them does
        # the same thing: adds operation to be performed along with its params
        # to the request data

        %i(optimize adjust auto border crop mask output padding resize response scale store filter watermark webhook cdn flip).each do |method|
            define_method method do |value = {}|
                return self if value.empty? || !value.respond_to?(:merge)
                @request.data[method] = value
                self
            end
        end

        private


        ##
        # Validates if we can perform request operation, i.e. if fetch was called
        # upload should throw an exception and the other way around. So we don't
        # chain two types of requests
        #
        # @param type [Symbol] request type which we want to perform

        def validate_request(type)
            return if @request.nil? || @request.type == type
            raise Optidash::Errors::RequestTypeConflict.new(@request.type, type)
        end


        ##
        # Validates if particular operations are valid for binary responses.

        def validate_binary_operations
            if @request.data[:webhook]
                raise Optidash::Errors::OperationNotSupported, "Binary responses are not supported when using Webhooks"
            end

            if @request.data[:store]
                raise Optidash::Errors::OperationNotSupported, "Binary responses are not supported when using External Storage"
            end
        end


        ##
        # Validates proxy url

        def validate_url(url)
            return if url =~ /\A#{URI::regexp(['http', 'https'])}\z/
            raise Optidash::Errors::InvalidProxyUrl, "Proxy url is not valid"
        end
    end
end