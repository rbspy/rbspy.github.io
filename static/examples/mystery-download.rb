require 'net/http'

def download_image
    begin
        Net::HTTP.start("google.com", 1234, open_timeout: 2) do
            puts 'hi'
        end
    rescue
    end
end

download_image
