# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  auth_token             :string
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :apps
  has_one :invitation
  before_create :generate_auth_token
  # attr_accessor :invitation_token

  def generate_auth_token
    begin
      self.auth_token = SecureRandom.urlsafe_base64
    end while User.exists?(auth_token: self.auth_token)
  end


end
