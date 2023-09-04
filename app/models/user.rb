class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
 

  validates :password, presence: true

  def recent_posts(limit = 3)
    posts.order(created_at: :desc).limit(limit)
  end

  def admin?
    role == 'admin'
  end
end