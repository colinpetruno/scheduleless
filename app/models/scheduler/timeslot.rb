module Scheduler
  class Timeslot

    attr_reader :x
    attr_reader :y
    attr_reader :players


    def initialize(x, y, slots_available)
      @x = x
      @y = y
      @slots_available = slots_available
      @players = []
    end

    def full
      @players.length == @slots_available
    end

    def add_player(player)
      @players.push(player)
    end

    def print
      printf "[ %{slots_available} %{players} ]" % {slots_available: @slots_available, players: @players}
    end
  end
end