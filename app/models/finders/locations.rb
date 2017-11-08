module Finders
  class Locations
    def self.for(user)
      new(user: user)
    end

    def initialize(user:)
      @user = user
    end

    def all
      Location.where(id: all_location_ids)
    end

    def alternate
      user.locations
    end

    def primary
      user.primary_location
    end

    private

    attr_reader :user

    def all_location_ids
      alternate_location_ids + [user.primary_location_id]
    end

    def alternate_location_ids
      UserLocation.where(user_id: user.id).pluck(:location_id)
    end
  end
end
