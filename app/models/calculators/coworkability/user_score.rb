module Calculators
  module Coworkability
    class UserScore
      def initialize(user:, date: Date.today, incidents: nil)
        @date = date
        @incidents = incidents
        @user = user
      end

      def calculate
        # TODO: lots of logic needs to go here
        # after 6 months incident severity should start to decline
        # after 1 year incidents should drop off and not calculate into the score
        #
        # we could do all sorts of interesting stuff here to increase or decrease
        # the weight of the invididual incidents
        result = incidents.map do |incident|
          adjusted_score(incident)
        end

        result.sum
      end

      private

      attr_reader :user, :date

      def adjusted_score(incident)
        # adjust by duration
        # 6 months and newer = multiplier of 1
        # 9 months = .5
        # 12 months ago = 0
        days_past_6_months = [((date - 6.months) - incident.created_at.to_date).to_i, 0].max
        total_days_past_6_months = [((date - 6.months) - (date - 1.year)).to_i, 0].max
        score_multiplier = 1.to_f - (days_past_6_months.to_f / total_days_past_6_months.to_f)

        (incident.score * score_multiplier).to_i
      end

      def incidents
        @incidents ||= Incident.
          where(user_id: user.id,
                created_at: (date - 1.year)..(date + 1.day))
      end
    end
  end
end
