module Scrapes
  module Glassdoor
    class RowAdaptor
      def initialize(row:)
        @row = row
      end

      def as_json(_options={})
        {
          company_size: company_size,
          name: company_name,
          website: company_website,
          headquarters: headquarters,
          category: company_category,
          revenue: revenue,
          founded: founded,
          linkedin_url: linkedin_url,
          twitter_url: twitter_url,
          facebook_url: facebook_url,
          instagram_url: instagram_url,
          youtube_url: youtube_url,
          gd_logo_url: glassdoor_logo_url,
          gd_url: glassdoor_url,
          gd_employer_id: glassdoor_employer_id,
          gd_id: glassdoor_id
        }
      end

      def company_size
        if @row["CompanySize"].include?("employees")
          @row["CompanySize"]
        end
      rescue
        0
      end

      def company_name
        @row["CompanyName"]
      end

      def company_website
        @row["CompanyWebsite"]
      end

      def company_category
        # not sure why most of these ended up in revenue, my guess is revenue
        # isn't often filled out and thus the xpath integer resolves here
        if @row["Revenue"].exclude?("million") && @row["Revenue"].exclude?("billion")
          @row["Revenue"]
        end
      rescue
        nil
      end

      def company_type
        wonky_attributes.select do |attr|
          attr.include?("Type Company")
        end.first.gsub("Type Company - ", "")
      rescue
        nil
      end

      def headquarters
        if @row["Headquarters"].exclude?("employees")
          @row["Headquarters"]
        end
      rescue
        nil
      end

      def revenue
        wonky_attributes.select do |attr|
          attr.include?("million") || attr.include?("billion")
        end.first
      rescue
        0
      end

      def glassdoor_id
        @row["GlassdoorId"].to_i
      end

      def glassdoor_employer_id
        @row["GlassdoorEmployerId"].to_i
      end

      def glassdoor_logo_url
        @row["LogoUrl"]
      end

      def glassdoor_url
        @row["GlassdoorUrl"].to_i
      end

      def founded
        if (1600..2030).include?(@row["Founded"].to_i)
          @row["Founded"].to_i
        else
          wonky_attributes.select do |attr|
            attr.include?("Founded")
          end.first.to_i
        end
      rescue
        nil
      end

      def linkedin_url
        @row["LinkedinUrl"]
      end

      def twitter_url
        @row["TwitterUrl"]
      end

      def facebook_url
        @row["FacebookUrl"]
      end

      def instagram_url
        @row["InstagramUrl"]
      end

      def youtube_url
        @row["YoutubeUrl"]
      end

      def response_code
        @row["ResponseCode"].to_i
      rescue
        nil
      end

      private

      def wonky_attributes
        @_wonky_attributes ||= [
          @row["Founded"],
          @row["CompanySize"],
          @row["CompanyType"],
          @row["Headquarters"],
          @row["Revenue"]
        ]
      end
    end
  end
end
