namespace :scrape do
  desc "Load Glassdoor CSV Files Into Database"
  task :load_glassdoor => :environment do 
    files = Dir.entries("#{Rails.root}/lib/scrapes/").select {|e| /^.+\.csv$/.match(e)}

    files.map do |file|
      puts "Beginning to Load #{file}..."
      Chewy.strategy(:atomic) do
        Scrapes::Glassdoor::Load.new(file_name: file).load
      end
      puts "Finished Loading #{file}"
      puts ""
      puts ""
      puts ""
    end
  end
end
