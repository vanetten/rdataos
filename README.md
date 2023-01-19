# rdataos

An experimental implementation of dataos in ruby.

## Development Environment

### Install Xcode CLI tools (if needed)

```bash
xcode-select --install
```

### Install Homebrew (if needed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install ruby (if needed)

```bash
brew update
brew install rbenv
rbenv init
rbenv install 2.7.1
```

### Install rails (if needed)

```bash
gem install rails
```

### Create and seed the database

```bash
rake db:create
rake db:seed
```

### Run the app locally

```bash
rails s
```

### Signup to the app with username and password through Postman
[http://127.0.0.1:3000/auth/signup](http://127.0.0.1:3000/auth/signup)

### Login to the app with username and password through Postman
[http://127.0.0.1:3000/auth/login](http://127.0.0.1:3000/auth/login)

## Steps used to create the application

### Create a rails API application

```bash
rails new rdataos --api
```

### Add rack-cors, jwt and bcrypt gems to Gemfile

```ruby
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"
# Use JWT gem for token-based authentication
gem 'jwt'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
```

```bash
bundle install
```

### Configure config/initializers/cors.rb to allow all hosts

```ruby
    origins "*"
```

### Create a user model with rails generator

```bash
rails g model user username:string password_digest:string
rake db:migrate
```

### Add validators to user model

```ruby
class User < ApplicationRecord
  require "securerandom"

  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
  
end
```

### Create a user controller with rails generator and add CRUD

```bash
rails g controller users
```
```ruby
class UsersController < ApplicationController

  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    unless @user.update(user_params)
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private

    def user_params
      params.permit(:username, :password)
    end

    def set_user
      @user = User.find(params[:id])
    end

end
```

### Author json_web_token.rb Concern

```ruby
require "jwt"

module JsonWebToken

  extend ActiveSupport::Concern
  SECRET_KEY = Rails.application.secret_key_base

  def jwt_encode(payload, exp: 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def jwt_decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end

end
```

### Add authenticate_request to application_controller

```ruby
class ApplicationController < ActionController::API

include JsonWebToken

before_action :authenticate_request

private

  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
  end

end
```

### Create Authentication Controller

```bash
rails g controller authentication
```

```ruby
class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  # POST /auth/signup
  def signup
    user = User.new(username: params[:username], password: params[:password])
    if user.save
      token = jwt_encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: {error: 'unauthorized'}, status: :unauthorized
    end
  end

  # POST /auth/login
  def login
    user = User.find_by_username(params[:username])
    if user&.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: {error: 'unauthorized'}, status: :unauthorized
    end
  end

end
```

### Update routes.rb

```ruby
  resources :users
  resources :insurances
  post '/auth/signup', to: 'authentication#signup'
  post '/auth/login', to: 'authentication#login'
```

## Create insurance model and controller

```bash
rails g model insurance age:integer sex:string bmi:decimal children:integer smoker:string region:string charges:decimal
rake db:migrate
```

### Add insurance.csv to lib/seeds
[insurance.csv](https://github.com/stedy/Machine-Learning-with-R-datasets/raw/master/insurance.csv)

### Modify db/seeds.rb to load insurance.csv

```ruby
require 'csv'
csv_text = File.read(Rails.root.join('lib', 'seeds', 'insurance.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  i = Insurance.new
  i.age = row['age']
  i.sex = row['sex']
  i.bmi = row['bmi']
  i.children = row['children']
  i.smoker = row['smoker']
  i.region = row['region']
  i.charges = row['charges']
  i.save
  puts "#{i.age}, #{i.sex} saved"
end

puts "There are now #{Insurance.count} rows in the insurances table"
```

### Load the insurance.csv seed

```bash
rake db:seed
```

### Create a insurances controller and add CRUD

```bash
rails g controller insurances
```

```ruby
class InsurancesController < ApplicationController

  # skip_before_action :authenticate_request
  before_action :set_insurance, only: [:show, :update, :destroy]

  def index
    @insurances = Insurance.all
    render json: @insurances, status: :ok
  end

  def show
    render json: @insurance, status: :ok
  end

  def create
    @insurance = Insurance.new(user_params)
    if @insurance.save
      render json: @insurance, status: :created
    else
      render json: {errors: @insurance.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    unless @insurance.update(insurance_params)
      render json: {errors: @insurance.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @insurance.destroy
  end

  private

    def insurance_params
      params.permit(:age, :sex, :bmi, :children, :smoker, :region, :charges)
    end

    def set_insurance
      @insurance = Insurance.find(params[:id])
    end

end
```

## Add swagger

### Add rswag to the Gemfile

```bash
gem 'rswag'
gem 'rspec-rails'
```

### Install rswag

```bash
bundle install
rails g rspec:install
rails g rswag:install
```

### Generate Insurances spec and author spec

```bash
rails g rspec:swagger API::UsersController
rails g rspec:swagger API::InsurancesController
```

### Generate Swagger JSON file

```bash
rake rswag:specs:swaggerize
```