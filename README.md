### 0xblockchain Rails Project [![Build Status](https://travis-ci.org/pyk/0xblockchain.svg?branch=master)](https://travis-ci.org/pyk/0xblockchain)

This is the source code of the site operating at
[https://0xblockchain.network](https://0xblockchain.network).
It is a Rails 5 codebase and uses a SQL (PostgreSQL in production) backend for the database.

While you are free to fork this code and modify it (according to the [license](https://github.com/pyk/0xblockchain/blob/master/LICENSE))
to run your own link aggregation website, this source code repository and bug
tracker are only for the site operating at [0xblockchain.network](https://0xblockchain.network/).
Please do not use the bug tracker for support related to operating your own
site unless you are contributing code that will also benefit [0xblockchain.network](https://0xblockchain.network/).

The [0xblockchain](https://0xblockchain.network) site is based on awesome [lobster](https://github.com/lobster/lobster) site.

#### Contributing bugfixes and new features

Please see the [CONTRIBUTING](https://github.com/pyk/0xblockchain/blob/master/CONTRIBUTING.md) file.

#### Initial setup

Use the steps below for a local install.

- Install Ruby 2.5.

- Checkout the 0xblockhain git tree from Github

  ```sh
  $ git clone git://github.com/pyk/0xblockchain.git
  $ cd 0xblockhain
  0xblockhain$
  ```

- Install Nodejs, needed (or other execjs) for uglifier

  ```sh
  Fedora: sudo yum install nodejs
  Ubuntu: sudo apt-get install nodejs
  OSX: brew install nodejs
  ```

- Run Bundler to install/bundle gems needed by the project:

  ```sh
  0xblockchain$ bundle install --path vendor/bundle
  ```

- Install postgresql locally using the following command:

  ```sh
  0xblockchain$ sudo apt install postgresql
  ```

- Create role for your current user:

  ```sh
  0xblockchain$ sudo -u postgres createuser $(whoami) -s -P
  ```

- Create `.env.development` inside root directory with the
  following content:

  ```sh
    DATABASE_URL="postgres://$(whoami):1234@localhost/0xblockchain_dev"
    DATABASE_TEST_URL="postgres://$(whoami):1234@localhost/0xblockchain_test"
    GITHUB_CLIENT_ID='UPDATE_HERE'
    GITHUB_CLIENT_SECRET='UPDATE_HERE'
  ```

- Load the schema into the new database:

  ```sh
  bundle exec rake db:schema:load
  ```

- If you have found a problem, run the following commands
  to debug the migrations:

  ```sh
  bin/rails db:environment:set RAILS_ENV=development
  bundle exec rake db:drop
  bundle exec rake db:create
  bundle exec rake db:migrate
  ```

then load the schema again.

- Create a `config/initializers/secret_token.rb` file, using a randomly
  generated key from the output of `bundle exec rake secret`:

  ```ruby
  0xblockhain::Application.config.secret_key_base = 'your random secret here'
  ```

- Define your site's name and default domain, which are used in various places,
  in a `config/initializers/production.rb` or similar file:

  ```ruby
  class << Rails.application
    def domain
        "example.com"
    end

    def name
        "Example News"
    end
  end

  Rails.application.routes.default_url_options[:host] = Rails.application.domain
  ```

- Put your site's custom CSS in `app/assets/stylesheets/local`.

- Seed the database to create the tags:

  ```sh
  bundle exec rake db:seed
  ```

- Run the Rails server in development mode. You should be able to login to
  `http://localhost:3000` with your new `test` user:

  ```sh
  0xblockhain$ bundle exec rails server
  ```

- In production, set up crontab or another scheduler to run regular jobs:

  ```sh
  */5 * * * *  cd /path/to/0xblockhain && env RAILS_ENV=production sh -c 'bundle exec ruby script/mail_new_activity; bundle exec ruby script/post_to_twitter'
  ```

- In production, see `config/initializers/production.rb.sample` for GitHub/Twitter integration help.

- Execute the following command to run the test:

  ```sh
  bundle exec rspec
  # Or individual spec
  bundle exec rspec spec/controllers/sessions_controller_spec.rb
  ```

#### Administration

Basic moderation happens on-site, but most other administrative tasks require use of the rails console in production.
Administrators can create and edit tags at `/tags`.

To grant admin access:

```sh
bundle exec rails console
```

Then find the user and grant the admin access:

```ruby
user = User.find_by(username: "username")
user.is_admin = true
user.save!
```

#### Heroku

To deploy on heroku, follow this step by step.

First, login to your account:

```sh
heroku login
```

Then create application:

```sh
heroku create
```

Then deploy to heroku:

```sh
git push heroku master
```

Migrate and seed the database if there are any changes:

```sh
heroku run rake db:migate
heroku run rake db:seed
```

To perform administrative task, run:

```
heroku run rails console
```

To use multiple environment (staging and production) on heroku
read the following [guide](https://devcenter.heroku.com/articles/multiple-environments).

To get the logs you can run the following command:

```
heroku logs --app APP_NAME
```

or to follow the logs:

```
heroku logs --app APP_NAME --tail
```
