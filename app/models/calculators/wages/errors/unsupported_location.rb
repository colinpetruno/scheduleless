module Calculators
  module Wages
    module Errors
      class UnsupportedLocation < StandardError
        def initialize(msg="Wage Calculation Not Supported For This Location")
          super
        end
      end
    end
  end
end
