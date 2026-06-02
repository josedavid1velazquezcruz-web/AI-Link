class User < ApplicationRecord

  has_many :campaigns, dependent: :destroy
  has_many :products, dependent: :destroy
  has_one_attached :avatar

devise :database_authenticatable,
       :registerable,
       :recoverable,
       :rememberable,
       :validatable

end