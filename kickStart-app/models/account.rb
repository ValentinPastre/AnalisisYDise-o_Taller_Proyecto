require_relative 'virtual_debit_card'

class Account < ActiveRecord::Base
  belongs_to :user
  has_one :security_questions
  has_one :virtual_debit_card
  has_many :source_transactions, class_name: 'Transaction', foreign_key: :source_account_id
  has_many :savings, class_name: 'Saving'
  has_many :confident

  has_secure_password

  # verifica que el alias y cvu sean unicos
  validates :alias, uniqueness: true
  validates :cvu, uniqueness: true

  before_create :generate_cvu_and_alias
  after_create :generate_virtual_debit_card
  
  # logica de generacion de cvu y alias
  private

  def generate_cvu_and_alias
    self.cvu = generate_cvu
    self.alias = generate_alias
  end

  def generate_cvu
    loop do
      new_cvu = Array.new(22) { rand(0..9) }.join
      break new_cvu unless Account.exists?(cvu: new_cvu)
    end
  end

  def generate_alias
    adjectives = ["perro", "gato", "leon", "elefante", "mono", "loro"]
    nouns = ["desierto", "selva", "bosque", "tierra", "viento", "mar"]

    loop do
      new_alias = "#{adjectives.sample}.#{nouns.sample}.#{rand(100..999)}"
      break new_alias unless Account.exists?(alias: new_alias)
    end
  end

  def generate_virtual_debit_card
      create_virtual_debit_card!(
      card_number: Array.new(16) { rand(0..9) }.join,
      security_code: Array.new(3) { rand(0..9) }.join,
      expiration: Date.new(Date.today.next_year(7).year, 12, 31)
    )
  end
end