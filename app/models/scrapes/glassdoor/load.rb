module Scrapes
  module Glassdoor
    class Load
      def initialize(file_name:)
        @file_name = file_name
      end

      def load
        CSV.foreach("#{Rails.root}/lib/scrapes/#{@file_name}.csv", headers: true) do |row|
          puts "Processing Row"
          row = RowAdaptor.new(row: row)

          # only add successful scrapes
          if row.response_code == 200
            PublicCompany.create(row.as_json)
          end
        end
      end
    end
  end
end
