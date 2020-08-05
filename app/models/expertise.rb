class Expertise < ApplicationRecord
  belongs_to :user
  validates :website_text, presence: true, uniqueness: { scope: :user_id }
end
