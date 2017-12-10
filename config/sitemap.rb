
SitemapGenerator::Sitemap.default_host = "http://www.coworkability.io"
SitemapGenerator::Sitemap.public_path = 'tmp/'

SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                         aws_access_key_id: ENV["S3_ACCESS_KEY"],
                                         aws_secret_access_key: ENV["S3_SECRET"],
                                         fog_directory: ENV["BUCKETNAME_SITEMAPS"],
                                         fog_region: 'us-east-2')

SitemapGenerator::Sitemap.sitemaps_host = "http://s3.us-east-2.amazonaws.com/#{ENV["BUCKETNAME_SITEMAPS"]}/"

SitemapGenerator::Sitemap.create do
  add why_report_path

  PublicCompany.find_each do |company|
    if company.uuid.present?
      add public_company_path(company.uuid), :changefreq => 'weekly', :lastmod => company.updated_at
    end
  end
end
