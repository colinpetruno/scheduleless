class ManagePosition < ApplicationRecord
  belongs_to :position
  belongs_to :managee, foreign_key: :manages_id, class_name: "Position"
end
