module Optidash

    ##
    # Types of request along with their slightly differing implementations

    class Request

        ##
        # Base class.
        # Should be inherited by Fetch and Upload classes.

        class Base
            attr_reader :type
            attr_accessor :data
            attr_accessor :proxy

            API_URL = "https://api.optidash.ai/1.0"


            ##
            # Constructor. Passing api key for authentication

            def initialize(key, proxy = nil)

                ##
                # Setting initial options for the request

                @options = {
                    user: key,
                    password: "",
                    method: :post,
                    url: "#{API_URL}/#{@type}",
                    ssl_ca_file: File.dirname(__FILE__) + '/../data/cacert.pem'
                }

                @proxy = proxy

                ##
                # Request data, which will be sent do API server

                @data = {}
            end


            ##
            # Performs actual request, sending entire data set options:
            # - binary [Boolean] indicates whether request should return binary response or not
            # - save_path [String|NilClass] save location for binary file, if needed

            def perform(binary: false, save_path: nil)
                @data.merge!(response: { mode: "binary" }) if binary

                Optidash::Response.new(
                    RestClient::Request.execute(@options.merge(
                        payload: request_data,
                        headers: headers(binary: binary),
                        proxy: proxy
                    )),
                    save_path: save_path
                ).data
            rescue RestClient::ExceptionWithResponse => e
                Optidash::Response.new(e.response).data
            end

            private


            ##
            # Prepares request headers, appending x-optidash-binary header if necessary.

            def headers(binary: false)
                @headers ||= {}
                @headers["x-optidash-binary"] = 1 if binary
                @headers
            end
        end


        ##
        # Responsible for handling Fetch requests

        class Fetch < Base
            def initialize(key)
                @type = :fetch
                super(key)
            end

            ##
            # Returns fetch request data, which is a simple JSON

            def request_data
                @data.to_json
            end

            private

            def headers(binary: false)
                @headers ||= { content_type: :json }
                super
            end
        end


        ##
        # Responsible for handling Upload requests

        class Upload < Base
            def initialize(key, upload_path, proxy = nil)
                @type = :upload
                @upload_path = upload_path
                super(key, proxy)
            end

            def perform(binary: false, save_path: nil)
                unless File.exist?(@upload_path)
                    return "Input file #{@upload_path} does not exist", nil, nil
                end
                super
            end


            ##
            # Returns upload request data. Multipart containing uploaded file
            # and operations performed on it

            def request_data
                {
                    file: File.new(@upload_path, "rb"),
                    data: @data.to_json
                }
            end
        end
    end
end