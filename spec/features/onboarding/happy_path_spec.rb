require "rails_helper"

RSpec.describe "onboarding happy path", type: :feature do
  it "allows me to signup" do

    visit "/"

    expect(page).
      to have_content I18n.t("marketing.welcome.hero_section.title")

    click_on I18n.t("marketing.welcome.hero_section.call_to_action")

    expect(page).
      to have_content I18n.t("onboarding.registrations.new.title")
    expect(page).
      to have_content I18n.t("onboarding.registrations.new.description")

    click_on I18n.t("onboarding.registrations.form.submit");
    expect(page).to have_content("can't be blank", count: 4)


    fill_in "First Name", with: "Luna"
    fill_in "Last Name", with: "Lovegood"
    fill_in "Email", with: "Luna.Lovegood@example.com"
    fill_in "Password", with: "Password123"

    click_on I18n.t("onboarding.registrations.form.submit");

    expect(page).
      to have_content I18n.t("onboarding.companies.edit.title")

    click_on I18n.t("onboarding.companies.edit.next");
    expect(page).to have_content("can't be blank", count: 1)

    fill_in "Company Name", with: "Capybara Company"
    click_on I18n.t("onboarding.companies.edit.next");

    expect(page).
      to have_content I18n.t("onboarding.leads.new.title")
    expect(page).
      to have_content I18n.t("onboarding.leads.new.skip")

    fill_in "Any Additional Comments", with: "Hi this is my company"
    select "Phone", from: "Preferred Contact Method"

    click_on I18n.t("onboarding.leads.form.submit")
    expect(page).to have_content("please provide a phone number below")

    fill_in "Mobile Phone", with: "9788910597"
    click_on I18n.t("onboarding.leads.form.submit")

    expect(page).
      to have_content I18n.t("onboarding.leads.create.description")

    click_on I18n.t("onboarding.leads.create.continue")

    # ADD A LOCATION
    expect(page).
      to have_content I18n.t("onboarding.locations.instructions.title")
    expect(page).
      to have_content I18n.t("onboarding.locations.instructions.description")

    fill_in "Location Name", with: "Centre Street"
    fill_in "Address Line 1", with: "161 Huntington Ave Boston 02130"
    fill_in "City", with: "Boston"
    fill_in "State", with: "MA"
    fill_in "Postal Code", with: "02130"

    click_on "Save and Continue"

    expect(page).
      to have_content I18n.t("onboarding.scheduling_hours.show.title")
    expect(page).
      to have_content I18n.t("onboarding.scheduling_hours.show.description")
    # TODO change some stuff and make sure it works
    # TODO test disabling of fields
    click_on "Save and Continue"


    # POSITIONS
    expect(page).
      to have_content I18n.t("onboarding.positions.new.title")
    expect(page).
      to have_content I18n.t("onboarding.positions.new.description")

    fill_in "Position Name", with: "Manager"
    click_on "Add Position"

    expect(page).
      to have_content "Manager"

    # TODO: Ensure position can be deleted if needed
    click_on I18n.t("onboarding.positions.new.continue")

    # ADD USERS
    expect(page).
      to have_content I18n.t("onboarding.users.index.description")
    expect(page).
      to have_content I18n.t("onboarding.users.index.title")

    click_on I18n.t("onboarding.users.index.add")

    expect(page).
      to have_content I18n.t("onboarding.users.new.description")
    expect(page).
      to have_content I18n.t("onboarding.users.new.title")

    fill_in "First Name", with: "Harry"
    fill_in "Last Name", with: "Potter"
    fill_in "Email", with: "harry.potter@example.com"

    select "Manager", from: I18n.t("simple_form.labels.user.primary_position")

    click_on "Add Employee"
    expect(page).to have_content("Employee was successfully added!")
    click_on "View All Employees"
    expect(page).to have_content("Harry Potter")

    click_on I18n.t("onboarding.users.index.continue")

    expect(page).
      to have_content I18n.t("onboarding.schedule_settings.edit.description")
    expect(page).
      to have_content I18n.t("onboarding.schedule_settings.edit.title")

    # check going backwards
    click_on "Back"
    expect(page).to have_content("Harry Potter")

    # company positions
    click_on "Back"
    expect(page).to have_content I18n.t("onboarding.positions.new.title")
    expect(page).to have_content("Manager")

    click_on "Back"
    expect(page).
      to have_content I18n.t("onboarding.locations.instructions.title")
    expect(page).to have_field("Location Name", with: "Centre Street")

    click_on "Back"
    expect(page).
      to have_content I18n.t("onboarding.companies.edit.title")
    expect(page).to have_field("Company Name", with: "Capybara Company")

    click_on "Continue"
    click_on I18n.t("onboarding.leads.new.skip")
    click_on "Save and Continue"
    click_on "Save and Continue"
    click_on "Continue"
    click_on "Continue"
    click_on "Finish"

    expect(page).
      to have_content I18n.t("onboarding.schedule_settings.update.title")
    expect(page).
      to have_content I18n.t("onboarding.schedule_settings.update.line_1")

    click_on I18n.t("onboarding.schedule_settings.update.dashboard")
    expect(page).to have_content "Your Shifts"
    expect(page).to have_content "Calendar"
  end
end
