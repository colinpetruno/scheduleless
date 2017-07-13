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







    # about your company has no label
    fill_in "user[leads_attributes][0][note]", with: "Hi this is my company"
    select "Phone", from: "Preferred contact"

    click_on I18n.t("onboarding.leads.form.submit")
    expect(page).to have_content("please provide a phone number below")

    fill_in "Mobile Phone", with: "9788910597"
    click_on I18n.t("onboarding.leads.form.submit")

    expect(page).
      to have_content I18n.t("onboarding.leads.create.description")

    click_on I18n.t("onboarding.leads.create.continue")

    expect(page).
      to have_content I18n.t("onboarding.positions.new.title")
    expect(page).
      to have_content I18n.t("onboarding.positions.new.description")

    fill_in "Position Name", with: "Manager"
    click_on "Create Position"

    expect(page).
      to have_content "Manager"

    # TODO: Ensure position can be deleted if needed
    click_on I18n.t("onboarding.positions.new.continue")

    expect(page).
      to have_content I18n.t("onboarding.locations.index.title")
    expect(page).
      to have_content I18n.t("onboarding.locations.index.description")

    click_on I18n.t("onboarding.locations.index.add_location")
    expect(page).
      to have_content I18n.t("onboarding.locations.new.title")
    expect(page).
      to have_content I18n.t("onboarding.locations.new.description")

    fill_in "Location Name", with: "Centre Street"
    fill_in "Address Line 1", with: "161 Huntington Ave Boston 02130"
    fill_in "City", with: "Boston"
    fill_in "State", with: "MA"
    fill_in "Postal Code", with: "02130"

    click_on "Create Location"
    expect(page).
      to have_content I18n.t("onboarding.users.new.description")
    expect(page).
      to have_content I18n.t("onboarding.users.new.title")
  end
end
