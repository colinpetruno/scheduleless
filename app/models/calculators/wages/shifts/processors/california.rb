module Calculators
  module Wages
    module Shifts
      module Processors
        class California < Base
          def process
            {
              hours: hours,
              regular_hours: regular_hours,
              overtime_hours: overtime_hours,
              double_overtime_hours: double_overtime_hours,
              regular_hour_pay: regular_hour_cost,
              overtime_pay: overtime_hour_cost,
              double_overtime_pay: double_overtime_hour_cost,
              total: total_cost
            }
          end

          private

          def company
            shift.company
          end

          def schedule_period
            @_schedule_period ||= SchedulePeriod.for(company)
          end

          def seventh_consecutive_day?
            @seventh_day ||= ConsecutiveDaysWorked.for(shift) >= 7
          end

          def seventh_day?
            schedule_period.seventh_day == Date.parse(shift.date.to_s).wday
          end

          def total_cost
            double_overtime_hour_cost + overtime_hour_cost + regular_hour_cost
          end

          def double_overtime_hour_cost
            (double_overtime_hours * double_overtime_rate)
          end

          def double_overtime_hours
            if seventh_day? && seventh_consecutive_day?
              if hours > 8
                hours - 8
              else
                0
              end
            else
              if hours > 12
                hours - 12
              else
                0
              end
            end
          end

          def overtime_hour_cost
            (overtime_hours * normal_overtime_rate)
          end

          def overtime_hours
            if seventh_day? && seventh_consecutive_day?
              # overtime on seventh day
              if hours > 8
                8
              else
                hours
              end
            else
              # normal day
              if hours > 8
                if hours > 12
                  4
                else
                  hours - 8
                end
              else
                0
              end
            end
          end

          def regular_hour_cost
            (regular_hours * rate)
          end

          def regular_hours
            if seventh_day? && seventh_consecutive_day?
              0
            else
              if hours - 8> 0
                8
              else
                hours
              end
            end
          end
        end
      end
    end
  end
end
