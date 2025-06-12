class LinkObraSocialUser < ActiveRecord::Base
  has_many :user
  has_many :obra_social

  self.table_name = 'links_obra_social_user'

  validates :credential, uniqueness: true

  before_create :generate_credential

  private

  def generate_credential
      self.credential = loop do
      new_credential = Array.new(10) { rand(0..9) }.join
      break new_credential unless LinkObraSocialUser.exists?(credential: new_credential)
    end
  end
end