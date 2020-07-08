class User < ApplicationRecord
  # Direct associations

  has_many   :addresses,
             :dependent => :destroy

  # Indirect associations

  # Validations

  # Scopes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
