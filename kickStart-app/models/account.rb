require_relative 'virtual_debit_card'

class Account < ActiveRecord::Base
  belongs_to :user
  has_one :security_question
  has_many :source_transactions, class_name: 'Transaction', foreign_key: :source_account_id
  has_many :savings
  has_many :confidents
  has_one :virtual_debit_card, dependent: :destroy

  has_and_belongs_to_many :contacts, 
    class_name: 'Account', 
    join_table: 'accounts_contacts', 
    foreign_key: 'account_id',
    association_foreign_key: 'contact_id'

  has_secure_password

  # verifica que el alias y cvu sean unicos
  validates :alias, uniqueness: true
  validates :cvu, uniqueness: true
  validates :email, uniqueness: true

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
  return if virtual_debit_card.present? # Evitar duplicados

  build_virtual_debit_card(
    card_number: generate_unique_card_number,
    expiration_date: 3.years.from_now.to_date, # Ej: 3 años de validez
    cvv: rand(100..999).to_s,
    frontal_id: SecureRandom.hex(8).upcase
  ).save!
  end

  private

  def generate_unique_card_number
    loop do
      card_number = Array.new(16) { rand(0..9) }.join
      break card_number unless VirtualDebitCard.exists?(card_number: card_number)
    end
  end
end