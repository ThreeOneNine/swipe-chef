class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_categories, dependent: :destroy
  has_many :user_preferences, dependent: :destroy
  has_many :categories, through: :user_categories
end
