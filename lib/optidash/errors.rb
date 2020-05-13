module Optidash

    ##
    # Handling errors and app exceptions

    class Errors
        class RequestTypeConflict < StandardError
            def initialize(type1, type2)
                super("current type: #{type1}, attempted: #{type2}")
            end
        end

        class NoPathProvided < StandardError; end
        class OperationNotSupported < StandardError; end
        class InvalidProxyUrl < StandardError; end
    end
end