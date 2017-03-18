module Scheduler
  class ScheduleManager
    def initialize(options)
      @players = []

      # Note: Updated over time - redundant as player records are stored in timeslots
      #     Makes code access easier while making management harder
      #     TODO: Keep or destroy
      @player_timeslots = {} # predetermined inputs?
      @options = options
    end

    def players=(players)
      @players = players
    end

    def schedule=(schedule)
      @schedule = schedule
    end

    def print_scores
      @players.each do |player|
        puts "%{player} : %{score} slots" % {player: player, score: @player_timeslots[player].length}
      end
    end

    def schedule_full
      (0..@options[:x_max]).each do |x|
        (0..@options[:y_max]).each do |y|
          slot = @schedule.timeslot(x,y)
          return false if !slot.full
        end
      end
      true
    end

    def prepare_initial_schedule
      @players.each do |player|
        @player_timeslots[player] = []
      end

      (0..@options[:x_max]).each do |x|
        y = rand(@options[:y_max])
        slot = @schedule.timeslot(x, y)

        fails = 0
        fails_limit = 5

        while slot.full && fails < fails_limit
          y = rand(@options[:y_max])
          slot = @schedule.timeslot(x, y)
          fails = fails + 1
        end

        if !slot.full
          player = @players[x % @players.length]
          slot.add_player(player)
          @player_timeslots[player].push([x, y])
        end
      end
    end

    def eligible_players(slot)
      # TODO: what about making slot a class? the class can have references to
      # the surrounding classes. slot.up, slot.left, slot.right
      up_slot = @schedule.timeslot(slot.x, slot.y - 1)
      right_slot = @schedule.timeslot(slot.x + 1, slot.y)
      down_slot = @schedule.timeslot(slot.x, slot.y + 1)
      left_slot = @schedule.timeslot(slot.x - 1, slot.y)

      # TODO: Can Adjacent Players be a class as well?
      adjacent_players = []
      adjacent_players.push(up_slot.players) if up_slot
      adjacent_players.push(right_slot.players) if right_slot
      adjacent_players.push(down_slot.players) if down_slot
      adjacent_players.push(left_slot.players) if left_slot

      adjacent_players.flatten!.uniq!

      slot.players.each do |player|
        adjacent_players.delete(player)
      end

      adjacent_players
    end

    def priority_player(eligible_players)
      lowest_score = Float::INFINITY
      lowest_player = nil;

      eligible_players.each do |player|
        if @player_timeslots[player].length < lowest_score
          lowest_player = player
          lowest_score = @player_timeslots[player].length
        end
      end

      lowest_player
    end

    def assign_timeslot(slot)
      elg_players = eligible_players(slot)
      if elg_players.length > 0
        assigned_player = priority_player(elg_players)
        slot.add_player(assigned_player)
        @player_timeslots[assigned_player].push([slot.x, slot.y])

      else
        # TODO handle Ignore or Random case
      end
    end

    def assign_iteration
      (0..@options[:x_max]).each do |x|
        (0..@options[:y_max]).each do |y|
          slot = @schedule.timeslot(x,y)
          if !slot.full then assign_timeslot(slot) end
        end
      end
    end

    def auto_manage_schedule(max_rounds)
      @round = 0
      (0..max_rounds).each do
        assign_iteration
        @round = @round + 1
      end
    end
  end
end