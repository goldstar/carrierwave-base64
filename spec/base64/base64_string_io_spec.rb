require "spec_helper"

RSpec.describe Carrierwave::Base64::Base64StringIO do
  MIME_TYPES = {
    "application/pdf" => "pdf",
    "image/jpeg" => "jpeg",
    "image/svg+xml" => "svg"
  }

  subject(:string) { described_class.new(data, "file") }

  MIME_TYPES.each do |mime_type, extension|
    context "when the mime_type is: #{mime_type}" do
      let(:data) { "data:#{mime_type};base64,/9j/4AAQSkZJRgABAQEASABKdhH//2Q==" }

      it "identifies the mime_type" do
        expect(string.mime_type).to eq mime_type
      end

      it "looks up the appropriate file extension" do
        expect(string.file_extension).to eq extension
      end

      it "generates the correct filename" do
        expect(string.original_filename).to eq "file.#{extension}"
      end
    end
  end

  describe "invalid image data" do
    context "when the data uri mime type is missing" do
      let(:data) { "/9j/4AAQSkZJRgABAQEASABIAADKdhH//2Q==" }
      specify { expect { string }.to raise_error(Carrierwave::Base64::Base64StringIO::ArgumentError) }
    end

    context "when there base64 data is null" do
      let(:data) { "data:image/jpg;base64,(null)" }
      specify { expect { string }.to raise_error(Carrierwave::Base64::Base64StringIO::ArgumentError) }
    end
  end
end
