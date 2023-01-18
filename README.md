# rdataos

An experimental implementation of dataos in ruby.

## Development Environment

### Install CLI tools (if needed)

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

## Steps used to create the application

### Create a rails API application

```bash
rails new rdataos --api
```

### Add jwt and bcrypt to Gemfile

```bash
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"
# Use JWT gem for token-based authentication
gem 'jwt'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
bundle install
```

### Configure cors.rb to allow all hosts

### Create a user model

```bash
rails g model user name:string user_name:string email:string password_digest:string
rake db:migrate
```

### Add validators to user model

```bash
  has_secure_password

  validates :user_name, presence: true, uniqueness: true
  validates :email, presence: true
  validates :password, presence: true
```

### Create a user controller and add CRUD

```bash
rails g controller users
```

### Author JwtToken Concern

### Add authenticate_user to application_controller

### Create Authentication Controller

```bash
rails g controller authentication
```

### Update route.rb

## Create insurance model and controller

```bash
rails g model insurance age:integer sex:string bmi:decimal children:integer smoker:string region:string charges:decimal
rake db:migrate
```

### Add insurance.csv to lib/seeds

### Modify db/migrate/seeds to load

```bash
rake db:seed
```
### Create a insurances controller and add CRUD

```bash
rails g controller insurances
```

## Add swagger

### Add rswag

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