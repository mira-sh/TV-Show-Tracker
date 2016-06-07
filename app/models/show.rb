class Show < ActiveRecord::Base
  has_many :episodes
  validates :name, presence: true,
                    length: { minimum: 3 }
end
