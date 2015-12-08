class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :games, through: :user_games
  has_many :user_games
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
