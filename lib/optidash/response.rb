module Optidash

    ##
    # Builds an object containing response data

    class Response
        def initialize(object, save_path: nil)
            @object = object
            @save_path = save_path
            fetch_metadata
            return unless @error.nil?

            binary_response if binary?
        end

        def data
            result = [@error, @metadata]
            result << @file if binary? && @save_path.nil? && @file
            result
        end

        private

        def binary?
            !@object.headers[:x_optidash_meta].nil?
        end


        ##
        # Extracts the metadata either from the response body
        # or X-Optidash-Meta header if the binary response was in use

        def fetch_metadata
            data = JSON.parse(@object.headers[:x_optidash_metadata] || @object.body)

            if data["success"]
                @metadata = data
            else
                @error = data["message"]
            end
        rescue JSON::ParserError
            @error = "Unable to parse JSON response from "
            @error += (binary? ? "X-Optidash-Meta header" : "the Optidash Image API")
        end


        ##
        # Handles binary response and
        # saves the file or stores it as a buffer

        def binary_response
            return save_file if @save_path
            @file = @object.body
        end


        ##
        # Saves binary response to disk

        def save_file
            @file = File.open(@save_path, "wb")
            @file.write(@object.body)
            @file.close
        rescue
            @error = "Unable to save resulting image at `#{@save_path}` location"
        end
    end
end