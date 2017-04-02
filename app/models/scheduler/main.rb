module Scheduler
  NONE_ELIGIBLE_CONDITION = "IGNORE"
  RANDOM_BLOCK_START_REQ = 0

  MAX_ROUNDS = 20

  START_PRIORITY = 0

  MAX_X_DIMENSION = 3
  MAX_Y_DIMENSION = 3

  PLAYERS = [1,2,3]

  ALLOW_ZERO_SHIFT = true
  FIND_SHIFT_ALTERNATIVE = true
end

# USEAGE EXAMPLE

# def execute
#  schedule = Schedule.new(MAX_X_DIMENSION, MAX_X_DIMENSION)
#
#  manager = ScheduleManager.new({
#      :x_max => MAX_X_DIMENSION,
#      :y_max => MAX_Y_DIMENSION,
#      :find_shift_alternative => FIND_SHIFT_ALTERNATIVE,
#      :none_eligible_strategy => NONE_ELIGIBLE_CONDITION,
#      :random_block_start_req => RANDOM_BLOCK_START_REQ,
#      :start_priority => START_PRIORITY })
#  manager.players = PLAYERS
#  manager.schedule = schedule
#
#
#  # If this is predetermined - this step need not run
#  manager.prepare_initial_schedule
#
#  manager.auto_manage_schedule(MAX_ROUNDS)
#
#  schedule.print
#  manager.print_scores

#end
