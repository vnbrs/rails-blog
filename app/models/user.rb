class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :articles, dependent: :destroy
  before_save { email.downcase! }
  has_secure_password

  validates :username,
            uniqueness: { case_sensitive: false },
            presence: true,
            length: { minimum: 5, maximum: 25 }

  validates :email,
            uniqueness: { case_sensitive: false },
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            length: { minimum: 5, maximum: 100 }
end
