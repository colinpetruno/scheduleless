CarrierWave.configure do |config|
  config.cache_dir = "#{Rails.root}/tmp/uploads"

  config.fog_provider = "fog/aws"
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: Rails.application.secrets.s3_access_key,
    aws_secret_access_key: Rails.application.secrets.s3_secret,
    region: Rails.application.secrets.s3_region
  }

  if Rails.env.production?
    config.storage = :fog
  else
    config.storage = :file
  end

  config.asset_host = "https://blog-assets.scheduleless.com"
  config.fog_directory = Rails.application.secrets.s3_bucket
  config.fog_attributes = { "Cache-Control": "max-age=315576000" }
end
