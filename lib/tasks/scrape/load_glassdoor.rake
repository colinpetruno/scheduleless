namespace :scrape do
  desc "Load Glassdoor CSV Files Into Database"
  task :load_glassdoor => :environment do 
    file_directory = "#{Rails.root}/lib/scrapes/"
    finished_directory = "#{Rails.root}/lib/scrapes/imported/"

    files = Dir.entries("#{Rails.root}/lib/scrapes/").select {|e| /^.+\.csv$/.match(e)}.sort


    files.map do |file|

      src = "#{file_directory}#{file}"
      dest = "#{finished_directory}#{file}"
        
      puts "Beginning to Load #{file}..."

      Chewy.strategy(:atomic) do
        Scrapes::Glassdoor::Load.new(file_name: file).load
      end

      `mv #{src} #{dest}`
      puts "Finished Loading #{file}"
      puts ""
    end
  end
end
