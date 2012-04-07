class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.include? "@"
      record.errors[attribute] << "doesn't look like a valid email address"
    end
  end
end

class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation, :email
  attr_readonly :username
  
  validates :username, length: { in: 2..32 }, uniqueness: true
  validates :password, length: { minimum: 4 }, confirmation: true
  validates :email, length: { in: 5..100 }, email: true, uniqueness: true
  
  has_secure_password
  
  def to_param
    username
  end
  
  def gravatar_url(size = nil)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest email}".tap do |url|
      url << "?size=#{size}" if size
    end
  end
end