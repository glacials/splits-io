class PasswordResetTokenMailer < ApplicationMailer
    def create_email
        @password_reset_token = params[:password_reset_token]
        @base_url = params[:base_url]
        mail(to: @password_reset_token.user.email, subject: 'Splits.io password reset')
    end
end
