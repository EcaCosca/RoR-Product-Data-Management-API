class ProductsController < ApplicationController
  def index
    @products = Product.all
    render :index
  end

  def search
    @products = Product.all

    @products = @products.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    
    if params[:min_price].present? || params[:max_price].present?
      min_price = params[:min_price].to_f
      max_price = params[:max_price].to_f
      @products = @products.where("price >= ?", min_price) if params[:min_price].present?
      @products = @products.where("price <= ?", max_price) if params[:max_price].present?
    end
    
    if params[:min_expiration].present? || params[:max_expiration].present?
      min_date = Date.parse(params[:min_expiration]) rescue nil
      max_date = Date.parse(params[:max_expiration]) rescue nil
      @products = @products.where("expiration >= ?", min_date) if min_date
      @products = @products.where("expiration <= ?", max_date) if max_date
    end
    
    if params[:sort_field].present? && params[:sort_order].present?
      sort_field = %w[name price expiration].include?(params[:sort_field]) ? params[:sort_field] : "name"
      sort_order = %w[asc desc].include?(params[:sort_order]) ? params[:sort_order] : "asc"
      @products = @products.order("#{sort_field} #{sort_order}")
    else
      @products = @products.order(name: :asc)
    end

    render :index
  end

  def upload_file
    uploaded_file = params[:file]
    if uploaded_file.nil?
      render json: { error: 'No file uploaded' }, status: :unprocessable_entity
      return
    end

    begin
      saved_products = FileProcessingService.process_file(uploaded_file)

      render json: { message: 'File processed', products: saved_products }, status: :ok
    rescue => e
      Rails.logger.error("Error processing file: #{e.message}")
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end