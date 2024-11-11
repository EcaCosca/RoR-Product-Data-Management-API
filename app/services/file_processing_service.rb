require 'csv'

class FileProcessingService
  MAX_ROWS = 100_000
  BATCH_SIZE = 100

  def self.process_file(file)
    rows = parse_csv(file)
    raise 'CSV file has too many rows. Maximum allowed is 100000.' if rows.size > MAX_ROWS

    target_currencies = %w[eur cad ars cny jpy]
    exchange_rates = CurrencyService.get_exchange_rates(target_currencies)

    products_data = []
    rows.each do |row|
      product_data = transform_row(row, exchange_rates)
      next unless product_data # skip invalid rows

      products_data << product_data

      # Insert in batches to optimize performance
      if products_data.size >= BATCH_SIZE
        Product.insert_all(products_data)
        products_data.clear
      end
    end

    # Insert any remaining records that didn't reach the batch size
    Product.insert_all(products_data) if products_data.any?

    Rails.logger.info "#{rows.size} products processed and saved to database."
  end

  def self.parse_csv(file)
    sanitized_rows = []
    CSV.foreach(file.path, headers: true, col_sep: ';') do |row|
      sanitized_row = {
        name: sanitize_text(row['name']),
        price: parse_price(row['price']),
        expiration: parse_date(row['expiration'])
      }

      next if sanitized_row.values.any?(&:nil?) # skip rows with nil values

      sanitized_rows << sanitized_row
    end
    sanitized_rows
  end

  def self.transform_row(row, exchange_rates)
    return nil if row[:name].blank? || row[:price].nan?

    {
      name: row[:name],
      price: row[:price],
      currencies: calculate_currencies(row[:price], exchange_rates),
      expiration: row[:expiration],
      created_at: Time.current,
      updated_at: Time.current
    }
  end

  def self.calculate_currencies(price, exchange_rates)
    exchange_rates.transform_values { |rate| (price * rate).round(2) }
  end

  def self.sanitize_text(text)
    return '' if text.nil?
    text.gsub(/#\([^)]*\)/, '')
        .gsub(/[\u{1F600}-\u{1F64F}]/, '')
        .gsub(/[\u200B-\u200D\uFEFF]/, '')
        .gsub(/[^\x20-\x7E]/, '')
        .gsub(/[^a-zA-Z0-9\s\-]/, '')
        .strip
  end

  def self.parse_price(price_string)
    return nil if price_string.nil?
    price_string.gsub(/[^\d.]/, '').to_f
  end

  def self.parse_date(date_string)
    return nil if date_string.nil?
    Date.parse(date_string) rescue nil
  end
end