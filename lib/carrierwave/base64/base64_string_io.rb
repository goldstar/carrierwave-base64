require "rack/mime"

module Carrierwave
  module Base64
    class Base64StringIO < StringIO
      class ArgumentError < StandardError; end

      attr_accessor :header, :data, :file_name

      def initialize(encoded_string, file_name)
        @header, @data = encoded_string.split(",")
        @file_name = file_name

        raise ArgumentError unless data
        raise ArgumentError if data.eql? "(null)"

        super decoded_data
      end

      def original_filename
        File.basename("#{file_name}.#{file_extension}")
      end

      def mime_type
        /data:([a-z0-9+\/]+);base64\z/.match(header)[1]
      rescue
        "application/octet-stream"
      end

      def file_extension
        Rack::Mime::MIME_TYPES.key(mime_type).delete(".")
      rescue
        "txt"
      end

      private

      def decoded_data
        ::Base64.decode64(data)
      end
    end
  end
end
