namespace :scrape do
  desc "Ensure Login users Are Created For All users"
  task :glassdoor => :environment do
  require "csv"

    class ScrapePage
      require "capybara"
      require 'capybara/dsl'
      require "capybara/webkit"

      include Capybara::DSL
      Capybara.default_driver = :webkit

      Capybara::Webkit.configure do |config|
        #config.allow_unknown_urls
        config.debug = false
        config.skip_image_loading = true
        config.ignore_ssl_errors = true
        config.allow_url("glassdoor.com")
        config.block_url("activityi")
      end

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

      def visit_page
        begin
          visit @url 
        rescue Capybara::Webkit::InvalidResponseError => error
          # do nothing because of stuff
        rescue StandardError => error
          # log?
        end
      end

      def make_output_hash
        if status_code == 200
          {
            glassdoor_id: @integer,
            glassdoor_employer_id: glassdoor_employer_id,
            response_code: page.status_code,
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
            response_code: page.status_code
          }
        end
      end

      private

      def company_name
        begin
          page.find(:xpath, '//*[@id="EmpHeroAndEmpInfo"]/div[3]/div[2]/h1').text
        rescue
          ""
        end
      end

      def glassdoor_url
        page.current_url
      end

      def company_website
        begin
          page.find(:xpath, '//*[@id="EmpBasicInfo"]/div[1]/div/div[1]/span/a')["href"]
        rescue
          ""
        end
      end

      def company_size
        begin
          page.find(:xpath, '//*[@id="EmpBasicInfo"]/div[1]/div/div[3]/span').text
        rescue
          ""
        end
      end

      def company_type
        begin
          page.find(:xpath, '//*[@id="EmpBasicInfo"]/div[1]/div/div[5]').text 
        rescue
          ""
        end
      end

      def headquarters
        begin
          page.find(:xpath, '//*[@id="EmpBasicInfo"]/div[1]/div/div[2]/span').text
        rescue
          ""
        end
      end

      def founded
        begin
          page.find(:xpath, '//*[@id="EmpBasicInfo"]/div[1]/div/div[4]/span').text
        rescue
          ""
        end
      end

      def revenue
        begin
          page.find(:xpath, '//*[@id="EmpBasicInfo"]/div[1]/div/div[6]/span').text  
        rescue
          ""
        end
      end

      def glassdoor_employer_id
        begin
        page.find("div#EmpHero")["data-employer-id"]
        rescue
          ""
        end
      end

      def social_media_urls
        @social_media_urls ||= (1..6).map do |xpath_index|
          begin
            page.find(:xpath, "//*[@id='SocialMediaBucket']/a[#{xpath_index}]")[:href]   
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
          page.find("a.sqLogoLink img")[:src]
        rescue
          ""
        end
      end
    end


    # UPDATE START AND END FOR YOUR RUNS
    @start_int = 1 
    @end_int = 499 

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
      sleep 3
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
