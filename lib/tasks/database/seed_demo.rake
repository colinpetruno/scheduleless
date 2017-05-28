namespace :database do
  desc "Seed a demo account, rake database:seed_demo[demo1]"
  task :seed_demo, [:email_base] => [:environment] do |t, args|
    email_base = args[:email_base]


    Chewy.strategy(:atomic) do
      company = Company.create(name: "#{email_base.capitalize} Company")

      small_locations = Location.create(
        [
          { name: "Wellesley (small)", line_1: "339 Washington Street", line_2: "", city: "Wellesley", county_province: "MA", postalcode: "02481", company: company },
          { name: "Brookline Village (small)", line_1: "1 Harvard Street", line_2: "", city: "Brookline", county_province: "MA", postalcode: "02445", company: company }
        ]
      )

      mid_locations = Location.create([
          { name: "Jamaica Plain (mid)", line_1: "731 Centre Street", line_2: "Suite 2", city: "Boston", county_province: "MA", postalcode: "02130", company: company },
          { name: "Central Square (mid)", line_1: "589 Massachusetts Ave", line_2: "", city: "Cambridge", county_province: "MA", postalcode: "02139", company: company }
        ]
     )

      large_locations = Location.create([
          { name: "South End (large)", line_1: "364 Tremont Street", line_2: "", city: "Boston", county_province: "MA", postalcode: "02118", company: company },
          { name: "Arlington (large)", line_1: "321 Broadway", line_2: "", city: "Arlington", county_province: "MA", postalcode: "02474", company: company }
        ]
      )

      counter = 1
      first_names = %w(  
        Jamey Clyde Neely Jeana Eldridge Randa Terence Jolie Jenise Russ Adolfo Barney
        Chelsea Tiffanie Sanford Susana Rodney Ilona Robbi Chauncey Deidra Annelle Sona
        Adalberto Arianne Evelynn Maisie Juliet Anjelica Milan Burl Loura Huong Summer
        Allen Evia Esteban Ashlie Toni Zachery Shawn Kerrie Maire Pia Kellye Janee
        Zenia Dian Wenona Colton
      )

      last_names = %w(
        Howard Arroyo Holt Allen Murray Lopez Boyer Key Hodge Nielsen
        Summers Steele Schultz Castaneda Hayden Zamora Golden Duffy Lee Ellison
        Castillo Mcintosh Mack Clark Snow Duncan Blevins Le Rodriguez Gillespie Potter
        Sheppard Berger Yu Wyatt Melendez Mccullough Conrad Crosby Rangel Ayers
        Bailey Vance Mueller Williamson Underwood Middleton Matthews Hale Cordova
      )

      manager = Position.create(name: "Manager", location_admin: true, company: company)
      assistant_manager = Position.create(name: "Assistant Manager", location_admin: true, company: company)
      barista = Position.create(name: "Barista", company: company)
      support = Position.create(name: "Support", company: company)
      cashier = Position.create(name: "Cashier", company: company)
      bus = Position.create(name: "Bus", company: company)

      puts "Setting up Small Loation 1"
      (1..10).each do |i|
        location = small_locations.first
        user = User.create(email: "#{email_base}.#{counter}@example.com",
                           password: "password",
                           password_confirmation: "password",
                           given_name: first_names.sample,
                           family_name: last_names.sample,
                           company: company
                          )

        if i == 1
          user.company_admin = true
          user.save
        end

        UserLocation.create(user_id: user.id, location_id: location.id, home: true)

        if i <= 2 # 2 managers
          EmployeePosition.create(user_id: user.id, position_id: manager.id)
        elsif i > 2 && i <= 6 # 4 barista
          EmployeePosition.create(user_id: user.id, position_id: barista.id)
        else # 4 support
          EmployeePosition.create(user_id: user.id, position_id: support.id)
        end

        counter += 1
      end

      puts "Setting up Small Location 2"
      (1..20).each do |i|
        location = small_locations.last
        user = User.create(email: "#{email_base}.#{counter}@example.com",
                           password: "password",
                           password_confirmation: "password",
                           given_name: first_names.sample,
                           family_name: last_names.sample,
                           company: company
                          )

        UserLocation.create(user_id: user.id, location_id: location.id, home: true)

        if i <= 2 # 2 managers
          EmployeePosition.create(user_id: user.id, position_id: manager.id)
        elsif i > 2 && i <= 4 # 2 assistant managers
          EmployeePosition.create(user_id: user.id, position_id: assistant_manager.id)
        elsif i > 4 && i <= 12
          EmployeePosition.create(user_id: user.id, position_id: barista.id)
        else # 4 support
          EmployeePosition.create(user_id: user.id, position_id: support.id)
        end

        counter += 1
      end

      puts "Setting up Medium Location 1"
      (1..30).each do |i|
        location = mid_locations.first
        user = User.create(email: "#{email_base}.#{counter}@example.com",
                           password: "password",
                           password_confirmation: "password",
                           given_name: first_names.sample,
                           family_name: last_names.sample,
                           company: company
                          )

        UserLocation.create(user_id: user.id, location_id: location.id, home: true)

        if i <= 4 # 2 managers
          EmployeePosition.create(user_id: user.id, position_id: manager.id)
        elsif i > 4 && i <= 8 # 2 assistant managers
          EmployeePosition.create(user_id: user.id, position_id: assistant_manager.id)
        elsif i > 8 && i <= 19
          EmployeePosition.create(user_id: user.id, position_id: barista.id)
        else # 4 support
          EmployeePosition.create(user_id: user.id, position_id: support.id)
        end

        counter += 1
      end

      puts "Setting up Medium Location 2"
      (1..40).each do |i|
        location = mid_locations.last
        user = User.create(email: "#{email_base}.#{counter}@example.com",
                           password: "password",
                           password_confirmation: "password",
                           given_name: first_names.sample,
                           family_name: last_names.sample,
                           company: company
                          )

        UserLocation.create(user_id: user.id, location_id: location.id, home: true)

        if i <= 4 # 2 managers
          EmployeePosition.create(user_id: user.id, position_id: manager.id)
        elsif i > 4 && i <= 11 # 2 assistant managers
          EmployeePosition.create(user_id: user.id, position_id: assistant_manager.id)
        elsif i > 11 && i <= 26
          EmployeePosition.create(user_id: user.id, position_id: barista.id)
        else # 4 support
          EmployeePosition.create(user_id: user.id, position_id: support.id)
        end

        counter += 1
      end

      puts "Setting up Large Location 1"
      (1..50).each do |i|
        location = large_locations.first
        user = User.create(email: "#{email_base}.#{counter}@example.com",
                           password: "password",
                           password_confirmation: "password",
                           given_name: first_names.sample,
                           family_name: last_names.sample,
                           company: company
                          )

        UserLocation.create(user_id: user.id, location_id: location.id, home: true)

        if i <= 4 # 2 managers
          EmployeePosition.create(user_id: user.id, position_id: manager.id)
        elsif i > 4 && i <= 11 # 2 assistant managers
          EmployeePosition.create(user_id: user.id, position_id: assistant_manager.id)
        elsif i > 11 && i <= 26
          EmployeePosition.create(user_id: user.id, position_id: barista.id)
        elsif i > 26 && i <= 34
          EmployeePosition.create(user_id: user.id, position_id: cashier.id)
        elsif i > 34 && i <= 40
          EmployeePosition.create(user_id: user.id, position_id: bus.id)
        else # 4 support
          EmployeePosition.create(user_id: user.id, position_id: support.id)
        end

        counter += 1
      end

      puts "Setting up Large Location 2"
      (1..60).each do |i|
        location = large_locations.last
        user = User.create(email: "#{email_base}.#{counter}@example.com",
                           password: "password",
                           password_confirmation: "password",
                           given_name: first_names.sample,
                           family_name: last_names.sample,
                           company: company
                          )

        UserLocation.create(user_id: user.id, location_id: location.id, home: true)

        if i <= 4 # 2 managers
          EmployeePosition.create(user_id: user.id, position_id: manager.id)
        elsif i > 4 && i <= 11 # 2 assistant managers
          EmployeePosition.create(user_id: user.id, position_id: assistant_manager.id)
        elsif i > 11 && i <= 30
          EmployeePosition.create(user_id: user.id, position_id: barista.id)
        elsif i > 30 && i <= 40
          EmployeePosition.create(user_id: user.id, position_id: cashier.id)
        elsif i > 40 && i <= 43 # intential short, throw a wrench in the works
          EmployeePosition.create(user_id: user.id, position_id: bus.id)
        else # 4 support
          EmployeePosition.create(user_id: user.id, position_id: support.id)
        end

        counter += 1
      end
    end # chewy

    puts "FINISHED"
  end # task
end # namespace
