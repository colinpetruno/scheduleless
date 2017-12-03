namespace :scrape do
  desc "Ensure Login users Are Created For All users"
  task :glassdoor, [:start_range, :end_range] => :environment do |t, args|
    require "csv"

    @start_int = args[:start_range].to_i 
    @end_int = args[:end_range].to_i 

    class ScrapePage
      require "nokogiri"
      require "open-uri"

      def initialize(integer:)
        @integer = integer
        @url = "https://www.glassdoor.com/Overview/Working-at-the-company-EI_IE#{integer}.11,25.htm"
      end

      def output
        puts "hi im scrapping a page"
      end

      def scrape
        visit_page
        make_output_hash
      end

      def get_response_with_redirect(uri)
         r = Net::HTTP.get_response(uri)
         if r.code == "301"
           r = Net::HTTP.get_response(URI.parse("https://www.glassdoor.com#{r.header['location']}"))
         end
         r
      end

      def visit_page
        begin
          uri = URI.parse(@url)
          @response = get_response_with_redirect(uri)
          @doc = Nokogiri::HTML(@response.body)
          @status = @response.code.to_i
        rescue OpenURI::HTTPError => e
          @status = @response.code.to_i
        rescue Net::OpenTimeout => e
          @status = -2
        end
      end

      def make_output_hash
        if @status == 200
          {
            glassdoor_id: @integer,
            glassdoor_employer_id: glassdoor_employer_id,
            response_code: @status,
            company_name: company_name,
            company_website: company_website,
            company_size: company_size,
            company_type: company_type,
            headquarters: headquarters,
            founded: founded,
            revenue: revenue,
            linkedin_url: linkedin_url,
            facebook_url: facebook_url,
            twitter_url: twitter_url,
            instagram_url: instagram_url,
            youtube_url: youtube_url,
            logo_url: logo_url,
            glassdoor_url: glassdoor_url
          }
        else
          {
            glassdoor_id: @integer,
            response_code: @status
          }
        end

      # rescue StandardError => error
       #  { response_code: -1 }
      end

      private

      def company_name
        begin
          @doc.xpath('//*[@id="EmpHeroAndEmpInfo"]/div[3]/div[2]/h1').first.text
        rescue
          ""
        end
      end

      def glassdoor_url
        @response.uri.to_s
      end

      def company_website
        begin
          @doc.xpath('//*[@id="EmpBasicInfo"]/div[1]/div/div[1]/span/a').first.attributes["href"].value
        rescue
          ""
        end
      end

      def company_size
        begin
          @doc.xpath('//*[@id="EmpBasicInfo"]/div[1]/div/div[3]/span').first.text
        rescue
          ""
        end
      end

      def company_type
        begin
          @doc.xpath('//*[@id="EmpBasicInfo"]/div[1]/div/div[5]').first.text
        rescue
          ""
        end
      end

      def headquarters
        begin
          @doc.xpath('//*[@id="EmpBasicInfo"]/div[1]/div/div[2]/span').first.text
        rescue
          ""
        end
      end

      def founded
        begin
          @doc.xpath('//*[@id="EmpBasicInfo"]/div[1]/div/div[4]/span').first.text
        rescue
          ""
        end
      end

      def revenue
        begin
          @doc.xpath('//*[@id="EmpBasicInfo"]/div[1]/div/div[6]/span').first.text
        rescue
          ""
        end
      end

      def glassdoor_employer_id
        begin
          @doc.xpath('//*[@id="EmpHero"]').first.attributes["data-employer-id"].value.to_i
        rescue
          ""
        end
      end

      def social_media_urls
        @social_media_urls ||= (1..6).map do |xpath_index|
          begin
            @doc.xpath("//*[@id='SocialMediaBucket']/a[#{xpath_index}]").first.attributes["href"].value
          rescue
            nil
          end
        end.compact
      end

      def linkedin_url
        social_media_urls.select { |u| u.include?("linkedin.") }.first
      end

      def facebook_url
        social_media_urls.select { |u| u.include?("facebook.") }.first
      end

      def twitter_url
        social_media_urls.select { |u| u.include?("twitter.") }.first
      end

      def instagram_url
        social_media_urls.select { |u| u.include?("instagram.") }.first
      end

      def youtube_url
        social_media_urls.select { |u| u.include?("youtube.") }.first
      end

      def logo_url
        begin
          @doc.xpath('//*[@id="EmpHeroAndEmpInfo"]/div[3]/div[1]/a/span/img').first.attributes["src"].value
        rescue
          ""
        end
      end
    end




    file_name = "glassdoor_#{@start_int}_#{@end_int}"

    # skip this  because we want to concat our files?
    unless File.exist?("#{Rails.root}/lib/scrapes/#{file_name}.csv")
      CSV.open("#{Rails.root}/lib/scrapes/#{file_name}.csv", "a") do |csv|
        csv << [
          "GlassdoorId",
          "GlassdoorEmployerId",
          "ResponseCode",
          "CompanyName",
          "CompanySize",
          "CompanyWebsite",
          "CompanyType",
          "Headquarters",
          "Founded",
          "Revenue",
          "LinkedinUrl",
          "TwitterUrl",
          "FacebookUrl",
          "InstagramUrl",
          "YoutubeUrl",
          "LogoUrl",
          "GlassdoorUrl"
        ]
      end
    end

    # ensure we shuffle our range to prevent sequential access
    (@start_int..@end_int).to_a.shuffle.each do |integer|
      # slow down so we dont get too much in trouble
      sleep rand(0.7..1.3)
      puts "scrapping id: #{integer}"
      result = ScrapePage.new(integer: integer).scrape

      CSV.open("#{Rails.root}/lib/scrapes/#{file_name}.csv", "a") do |csv|
          csv << [
            result[:glassdoor_id],
            result[:glassdoor_employer_id],
            result[:response_code],
            result[:company_name],
            result[:company_size],
            result[:company_website],
            result[:company_type],
            result[:headquarters],
            result[:founded],
            result[:revenue],
            result[:linkedin_url],
            result[:twitter_url],
            result[:facebook_url],
            result[:instagram_url],
            result[:youtube_url],
            result[:logo_url],
            result[:glassdoor_url],
          ]
      end
    end
  end
end
