class Product < ApplicationRecord
  validates :name, presence: true
  validates :price, numericality: true
  validates :expiration, presence: true
  validate :validate_currencies_format

  private

  def validate_currencies_format
    return if currencies.is_a?(Hash) && currencies.values.all? { |v| v.is_a?(Numeric) }

    errors.add(:currencies, 'must be a hash with numeric values for each currency')
  end
end