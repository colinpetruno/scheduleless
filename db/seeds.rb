Chewy.strategy(:atomic) do
  puts "Creating: Company named 'Scheduleless Dev'"
  company = Company.find_or_create_by(name: "Scheduleless Dev")
  puts "Created: Company"

  puts "Creating: Admin 'admin@example.com' with password 'password1234'"
  admin = LoginUser.find_or_create_by(email: "admin@example.com") do |admin|
    admin.password = "password1234"
    admin.password_confirmation = "password1234"
  end
  puts "Created: Admin"

  puts "Creating: Admin User"
  User.find_or_create_by(email: "admin@example.com") do |user|
    user.given_name = "Pascal"
    user.family_name = "Fluffy"
    user.company_id = company.id
    user.login_user_id = admin.id
    user.scheduleless_admin = true
  end
  puts "Created: Admin User"

  puts "Creating Features"
  wage_calculator = Feature.find_or_create_by(key: "wage_calculator") do |feature|
    feature.description = "View, calculate & report on wages while scheduling"
  end

  shift_trading = Feature.find_or_create_by(key: "shift_trading") do |feature|
    feature.description = "Allow employees to trade shifts"
  end

  mobile_apps = Feature.find_or_create_by(key: "mobile_apps") do |feature|
    feature.description = "Enable Mobile Apps for all employees"
  end

  time_tracking = Feature.find_or_create_by(key: "time_tracking") do |feature|
    feature.description = "Allow employees to clock in and out"
  end

  puts "Creating Plans"
  Plan.find_or_create_by(plan_name: "Entry") do |plan|
    plan.default = true
    plan.price = 0
  end

  Plan.find_or_create_by(plan_name: "Standard") do |plan|
    plan.price = 100
    plan.features = [wage_calculator, shift_trading, mobile_apps]
  end

  Plan.find_or_create_by(plan_name: "Advanced") do |plan|
    plan.price = 200
    plan.features = [
      wage_calculator,
      shift_trading,
      mobile_apps,
      time_tracking
    ]
  end
end # end chewy block
