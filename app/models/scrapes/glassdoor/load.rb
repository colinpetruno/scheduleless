module Scrapes
  module Glassdoor
    class Load
      def initialize(file_name:)
        @file_name = file_name
      end

      def load
        counter = 0
        CSV.foreach("#{Rails.root}/lib/scrapes/#{@file_name}", headers: true) do |row|
          # puts "Processing Row #{counter}"
          row = RowAdaptor.new(row: row)

          # only add successful scrapes
          if row.response_code == 200 && row.company_name.present?
            PublicCompany.create(row.as_json)
          end
          counter += 1
        end
      end
    end
  end
end
