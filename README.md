# Product Data Manager - Ruby on Rails Version

## Overview

This application is built using Ruby on Rails and is designed to help businesses efficiently manage product data. Users can upload CSV files containing product details, which are sanitized, processed, and stored in a PostgreSQL database. Additionally, the app can retrieve product information and perform filtering, sorting, and multi-currency conversion using exchange rates fetched from an API.

## Features

- **CSV Upload**: Allows users to upload CSV files with product information.
- **Data Sanitization**: Cleans and validates data for consistency.
- **Multi-Currency Support**: Automatically converts prices to multiple currencies.
- **Product Search**: Users can filter and sort products by name, price, and expiration date.

## Components

- **Rails Backend**: Handles file upload, data processing, and currency conversions.
- **PostgreSQL Database**: Stores product information in a structured format.

## Models

### Product Model

```ruby
create_table "products", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.jsonb "currencies"
    t.date "expiration"
    t.timestamps
end
```

## API Endpoints

| HTTP Method | URL               | Request Body         | Success Status | Error Status | Description                                                   |
|-------------|-------------------|----------------------|----------------|--------------|---------------------------------------------------------------|
| POST        | /products/upload  | {file: csv}          | 200            | 400          | Uploads and processes a CSV file containing product data       |
| GET         | /products         | ?name&min_price&max_price&expiration&sort_field&sort_order | 200            | 404          | Retrieves a list of products with optional filtering and sorting options |

## Setup and Installation

### Prerequisites

- Ruby (version 3.x or higher)
- Rails (version 7.x or higher)
- PostgreSQL

### Steps

1. Clone the repository:
        ```sh
        git clone https://github.com/EcaCosca/RoR-Product-Data-Management-API.git
        ```

2. Install dependencies:
        ```sh
        bundle install
        ```

3. Set up the database:
        ```sh
        rails db:create
        rails db:migrate
        ```

4. Start the Rails server:
        ```sh
        rails server
        ```

5. Access the application at [http://localhost:3000](http://localhost:3000).

## Development

### Environment Variables

Create a `.env` file in the root directory and set up the following environment variables:

- `DATABASE_URL`: The connection string for your PostgreSQL database.
- `CURRENCY_API_URL`: The URL of the API providing currency exchange rates.

Example:

```env
DATABASE_URL=your_database_url
CURRENCY_API_URL=https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.json
```

## Links

### Technologies

- Ruby on Rails
- PostgreSQL