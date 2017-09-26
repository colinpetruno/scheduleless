module Calculators
  module Wages
    module Shifts
      module Processors
        class Lookup
          STATE_MAP = {
            AK: OvertimeAfterEight,
            CA: California,
            CO: OvertimeAfterTwelve,
            PR: OvertimeAfterEight,
            VI: VirginIslands
          }

          COUNTRY_MAP = {
            US: Base
          }

          def self.for(location)
            new(location: location).lookup
          end

          def initialize(location:)
            @location = location
          end

          def lookup
            if STATE_MAP[state].present?
              STATE_MAP[state]
            elsif COUNTRY_MAP[country].present?
              COUNTRY_MAP[country]
            else
              raise Errors::UnsupportedLocation.new
            end
          end

          private

          attr_reader :location

          def country
            location.country.to_sym
          end

          def state
            location.county_province.to_sym
          end
        end
      end
    end
  end
end
