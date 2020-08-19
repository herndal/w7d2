# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#
class User < ApplicationRecord
    validates :email, :password_digest, :session_token, presence: true
    validates :email, uniqueness: true
    validates :password, length: {minimum: 6, allow_nil: true,  message: 'Password must be minimum 6 characters'}
    
    
    
    
    # validate :email_format

    # def email_format
    #     errors[:] "must have @ symbol" if !self.email.include?("@")
    # end


    

    def self.find_by_credentials(email, password)
        user = self.find_by(email: email)
        if user
            if is_password?(password)
                return user
            else
                user.errors[:password] << "does not match our record"
            end
        else
            user = User.new
            user.errors[:email] << "has no associated user"
            return user
        end
    end

    def is_password?(password)
        bcrypt = BCrypt::Password.new(self.password_digest)
        bcrypt.is_password?(password)
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def reset_session_token!
        self.session_token = self.class.generate_session_token
    end

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end

    after_initialize :ensure_session_token

    private
    attr_reader :password
    def self.generate_session_token
        SecureRandom::urlsafe_base64
    end
end


# F: find_by_credentials
    # I: is_password?
    # G: generate_session_token
    # V: validations
# A
    # P: password=
# O
# R


    # C: current_user
# E: ensure_logged_in   <----- what's the point?
    # L: login!
    # L: logout!
    # L: logged_in?