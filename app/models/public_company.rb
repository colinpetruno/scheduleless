class PublicCompany < ApplicationRecord
  before_save :set_uuid

  update_index "company_search#public_company", :self


  enum category: {
    unclassified: 0, accounting: 1, adult_entertainment: 2,
    advertising_marketing: 3, aerospace_defense: 4, airlines: 5,
    animal_production: 6, architectural_engineering_services: 7,
    asphalt_products_manufacturing: 8, auctions_galleries: 9, audiovisual: 10,
    auto_repair_maintenance: 11, automotive_parts_accessories_stores: 12,
    banks_credit_unions: 13, bars_nightclubs: 14,
    beauty_personal_accessories_stores: 15, biotech_pharmaceuticals: 16,
    brokerage_services: 17, building_personnel_services: 18,
    bus_transportation_services: 19, business_service_centers_copy_shops: 20,
    cable_internet_telephone_providers: 21, car_rental: 22,
    casual_restaurants: 23, catering_food_service_contractors: 24,
    charter_air_travel: 25, chemical_manufacturing: 26, college_university: 27,
    colleges_universities: 28, commercial_equipment_rental: 29,
    commercial_equipment_repair_maintenance: 30, commercial_fishing: 31,
    commercial_printing: 32, computer_hardware_software: 33, construction: 34,
    consulting: 35, consumer_electronics_appliances_stores: 36,
    consumer_product_rental: 37, consumer_products_manufacturing: 38,
    contract: 39, convenience_stores_truck_stops: 40, cruise_ships: 41,
    department_clothing_shoe_stores: 42, drug_health_stores: 43,
    education_training_services: 44, electrical_electronic_manufacturing: 45,
    energy: 46, enterprise_software_network_solutions: 47,
    express_delivery_services: 48, farm_support_services: 49,
    fast_food_quick_service_restaurants: 50, federal_agencies: 51,
    financial_analytics_research: 52, financial_transaction_processing: 53,
    floral_nurseries: 54, food_beverage_manufacturing: 55,
    food_beverage_stores: 56, food_production: 57, funeral_services: 58,
    gambling: 59, gas_stations: 60, general_merchandise_superstores: 61,
    general_repair_maintenance: 62, gift_novelty_souvenir_stores: 63,
    government: 64, grantmaking_foundations: 65,
    grocery_stores_supermarkets: 66, health_care_products_manufacturing: 67,
    health_care_services_hospitals: 68, health_fundraising_organizations: 69,
    health_beauty_fitness: 70, home_centers_hardware_stores: 71,
    home_furniture_housewares_stores: 72, hospital: 73,
    hotels_motels_resorts: 74, industrial_manufacturing: 75,
    insurance_agencies_brokerages: 76, insurance_carriers: 77, internet: 78,
    investment_banking_asset_management: 79, it_services: 80,
    k_12_education: 81, laundry_dry_cleaning: 82, legal: 83,
    lending: 84, logistics_supply_chain: 85,
    media_entertainment_retail_stores: 86, membership_organizations: 87,
    metal_mineral_manufacturing: 88, metals_brokers: 89, mining: 90,
    miscellaneous_manufacturing: 91, motion_picture_production_distribution: 92,
    movie_theaters: 93, moving_services: 94, municipal_governments: 95,
    museums_zoos_amusement_parks: 96, music_production_distribution: 97,
    news_outlet: 98, nonprofit_organization: 99, office_supply_stores: 100,
    oil_gas_exploration_production: 101, oil_gas_services: 102,
    other_organization: 103, other_retail_stores: 104,
    parking_lots_garages: 105, passenger_rail: 106, performing_arts: 107,
    pet_pet_supplies_stores: 108, photography: 109, preschool_child_care: 110,
    private_practice_firm: 111, publishing: 112, radio: 113, rail: 114,
    real_estate: 115, religious_organizations: 116, research_development: 117,
    security_services: 118, self_storage_services: 119, shipping: 120,
    social_assistance: 121, sporting_goods_stores: 122, sports_recreation: 123,
    staffing_outsourcing: 124, state_regional_agencies: 125,
    stock_exchanges: 126, subsidiary_or_business_segment: 127,
    talent_modeling_agencies: 128, taxi_limousine_services: 129,
    telecommunications_manufacturing: 130, telecommunications_services: 131,
    ticket_sales: 132, timber_operations: 133, towing_services: 134,
    toy_hobby_stores: 135, transportation_equipment_manufacturing: 136,
    transportation_management: 137, travel_agencies: 138,
    truck_rental_leasing: 139, trucking: 140, tv_broadcast_cable_networks: 141,
    upscale_restaurants: 142, utilities: 143, vehicle_dealers: 144,
    venture_capital_private_equity: 145, veterinary_services: 146,
    video_games: 147, wholesale: 148, wood_product_manufacturing: 149
  }

  enum company_size: {
    unknown: 0,
    one_to_fifty: 1,
    fifty_to_two_hundred: 2,
    two_to_five_hundred: 3,
    five_hundred_to_one_thousand: 4,
    one_to_five_thousand: 5,
    five_to_ten_thousand: 6,
    over_ten_thousand: 7
  }

  enum revenue: {
    not_available: 0,
    less_than_one_mil: 1,
    one_to_five_mil: 2,
    five_to_ten_mil: 3,
    ten_to_twenty_five_mil: 4,
    twenty_five_to_fifty_mil: 5,
    fifty_to_one_hundred_mil: 6,
    one_hundred_to_five_hundred_mil: 7,
    five_hundred_mil_to_one_bil: 8,
    one_bil_to_two_bil: 9,
    two_bil_to_five_bil: 10,
    five_bil_to_ten_bil: 11,
    over_ten_bil: 12
  }

  def self.find_by!(hash)
    if hash[:uuid].present?
      hash[:uuid] = hash[:uuid].split("-").first
    end

    super(hash)
  end

  def as_json(_options={})
    {
      uuid: self.uuid,
      name: self.name,
      to_param: self.to_param
    }
  end

  def title_line
    [website, headquarters].compact.join(" / ")
  end

  def to_param
    "#{uuid}-harrassment-at-#{name.parameterize}"
  end

  private

  def set_uuid
    return if self.uuid.present?
    self.uuid = SecureRandom.hex(6)
  end
end
