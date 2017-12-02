module Scrapes
  module Glassdoor
    class RowAdaptor
      COMPANY_SIZES = ["", "1 to 50 employees", "51 to 200 employees",
                       "201 to 500 employees", "501 to 1000 employees",
                       "1001 to 5000 employees", "5001 to 10000 employees",
                       "10000+ employees"]

      COMPANY_REVENUES = ["", "Less than $1 million (USD) per year",
        "$1 to $5 million (USD) per year", "$5 to $10 million (USD) per year",
        "$10 to $25 million (USD) per year", "$25 to $50 million (USD) per year",
        "$50 to $100 million (USD) per year", "$100 to $500 million (USD) per year",
        "$500 million to $1 billion (USD) per year", "$1 to $2 billion (USD) per year",
        "$2 to $5 billion (USD) per year", "$5 to $10 billion (USD) per year",
        "$10+ billion (USD) per year"]

      def initialize(row:)
        @row = row
      end

      def as_json(_options={})
        {
          company_size: company_size || 0,
          name: company_name,
          website: company_website,
          headquarters: headquarters,
          category: company_category,
          revenue: revenue || 0,
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
          size = @row["CompanySize"].strip
          if COMPANY_SIZES.index(size)
            COMPANY_SIZES.index(size)
          else
            0
          end
        end
      rescue
        0
      end

      def company_name
        @row["CompanyName"].strip
      end

      def company_website
        @row["CompanyWebsite"].strip
      end

      def company_category
        valid_categories = I18n.t("models.public_company.categories")

        wonky_attributes.select do |attr|
          valid_categories[attr.parameterize(separator: "_").gsub("-", "_").to_sym].present?
        end.first.parameterize(separator: "_").gsub("-", "_").to_sym
      rescue
        :unclassified
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
          @row["Headquarters"].strip
        end
      rescue
        nil
      end

      def revenue
        revenue = wonky_attributes.select do |attr|
          attr.include?("million") || attr.include?("billion")
        end.first.strip

        if COMPANY_REVENUES.index(revenue).present?
          COMPANY_REVENUES.index(revenue)
        else
          0
        end
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
        @row["LinkedinUrl"].strip
      rescue
        ""
      end

      def twitter_url
        @row["TwitterUrl"].strip
      rescue
        ""
      end

      def facebook_url
        @row["FacebookUrl"].strip
      rescue
        ""
      end

      def instagram_url
        @row["InstagramUrl"].strip
      rescue
        ""
      end

      def youtube_url
        @row["YoutubeUrl"].strip
      rescue
        ""
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
