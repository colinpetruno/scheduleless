module Business
  module Employees
    class CoworkabilityShowPresenter
      attr_reader :user

      def initialize(user:)
        @user = user
      end

      def months(count = 12)
        count.times.map { |i| (Date.today - i.month).end_of_month }
      end

      def indicator_class_for(date)
        Calculators::Coworkability::Rating.for(score_for(date)).to_s
      end

      def incidents_for(date)
        user_incidents.select do |incident|
          (date.beginning_of_month..date.end_of_month).
            include?(incident.created_at.to_date)
        end
      end

      private

      def incidents_before(date)
        user_incidents.select do |incident|
          incident.created_at.to_date <= date
        end
      end

      def score_for(date)
        Calculators::Coworkability::UserScore.
          new(user: user,
              date: date,
              incidents: incidents_before(date)).
          calculate
      end

      def user_incidents
        @incidents ||= Incident.where(user_id: user.id)
      end
    end
  end
end
