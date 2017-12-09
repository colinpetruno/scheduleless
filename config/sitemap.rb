SitemapGenerator::Sitemap.default_host = "http://www.coworkability.io"
SitemapGenerator::Sitemap.create do
  add why_report_path

  PublicCompany.find_each do |company|
    if company.uuid.present?
      add public_company_path(company.uuid), :changefreq => 'weekly', :lastmod => company.updated_at
    end
  end
end
