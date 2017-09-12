CarrierWave.configure do |config|
  #config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     ENV['S3_ACCESS_KEY_ID'],                        # required
    aws_secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],                        # required
    region:                'ap-northeast-2',                  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = ENV['S3_BUCKET_NAME']                          # required
  config.fog_public     = false                                        # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" } # optional, defaults to {}
end
