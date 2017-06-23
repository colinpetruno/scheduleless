namespace :database do
  desc "Backfill positions to add primary position_id"
  task :backfill_positions => :environment do
    Chewy.strategy(:atomic) do
      User.all.map do |user|
        puts "Updating Position for User: #{user.id}"
        positions = user.positions

        if positions.present?
          user.update(primary_position_id: positions.first.id)
        end
      end
    end
  end
end
