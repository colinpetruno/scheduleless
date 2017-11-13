module Calculators
  module Coworkability
    class Rating
      def self.for(score)
        new(score: score).rating
      end

      def initialize(score:)
        @score = score
      end

      def rating
        if score >= 900
          :red
        elsif score >= 450
          :orange
        elsif score >= 250
          :yellow
        else
          :green
        end
      end

      private

      attr_reader :score
    end
  end
end
