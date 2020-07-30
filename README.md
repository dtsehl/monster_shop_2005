# Monsters Be Shoppin'

## [Live Site (Heroku Deployment)](https://monsters-be-shoppin.herokuapp.com/)

## Dev Team

### [Taija Warbelow](https://github.com/twarbelow)
### [Michael Evans](https://github.com/michaeljevans)
### [Alex Desjardins](https://github.com/moosehandlr)
### [Dan Sehl](https://github.com/dtsehl)

## Background and Description

"Monsters Be Shoppin'" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can fulfill items in an order; after the last merchant marks their items as 'fulfilled' the order will be able to get "shipped" by an admin. Each user role will have access to some or all CRUD functionality for resources.

## Schema

<img width="1440" alt="Monsters Be Shoppin' Schema" src="https://user-images.githubusercontent.com/62079009/88983325-eacddf80-d287-11ea-908c-a28aabc029a6.jpg">

## User Roles
- Visitor - default if not logged in or registered, anonymous. They are only allowed to view information on the website and add items to their cart, but can't do anything further without registering.
- Regular User - registered user with details including email, secure password, name and address. They are able to check out items in their cart, thereby placing an order and initiating the order fulfillment process.
- Merchant User - a registered that is associated with a merchant and can fulfill orders, create/update/delete items on behalf of that merchant, and update merchant information.
- Admin User - a registered user who has unrestricted assess to all parts of the application and can act on behalf of a regular user or merchant user.

## Implementation Instructions
Follow these instructions in your terminal:

Clone this repo:
```
  git clone git@github.com:twarbelow/monster_shop_2005.git
```
Install/update gems:
```
  bundle install
  bundle update
```
Create the database:
```
  rails db:{create,migrate,seed}
```
Run tests:
```
  bundle exec rspec
  open coverage/index.html
```
Start the server:
```
  rails s
```
Browse to the local deployment of the app by using your browser of choice to go to localhost:3000

To login as an admin user, please use the login credentials:
```
regularbob@me.com
secret
```
To login as a merchant user, please use the login credentials:
```
regularjim@me.com
alsosecret
```
To login as a default user, please click on the register page on the website and enter your own information!

## Learning Goals
  - Authentication, authorization
  - ActiveRecord
    - Use ActiveRecord queries instead of Ruby when manipulating data
  - Rails
    - Use ReSTful Routes wherever possible
    - Use Sessions to store data about a user and implement login/logout functionality
  - One to Many relationships
  - Many to Many relationships
  - Basics of styling with HTML, CSS
  - Try using `form_for` instead of `form_tag`
  - Use Partials when applicable
  - Use namespacing, resources

## Design Notes
  - We could have used more partials
  - We could have used more `form_for`
  - Some of our decisions worked under the time constraints we had, though they might not be the most elegant implementations
  - Could have more controllers which are namespaced
  - Would not have a `merchant` user role, but rather would change that to something like `employee`
    - Just because there already is a `merchants` resource; that would enhance readability

## Additional Gems Used
  - `orderly`...but we didn't end up using it
  - `bcrypt` - encrypts passwords
  - `database_cleaner` - when running `rails db:seed` it cleans the database up
  - `nyan-cat-formatter` - to make testing more enjoyable

## Screenshots

### Homepage
<img width="1440" alt="Monsters Be Shoppin' Homepage" src="https://user-images.githubusercontent.com/62079009/88980316-adb21f00-d280-11ea-96b8-309c543fa05b.jpeg">

### Admin Dashboard
<img width="1440" alt="Monsters Be Shoppin' Admin Dashboard" src="https://user-images.githubusercontent.com/62079009/88980489-16999700-d281-11ea-9336-dabb4fc14c8a.jpeg">

### Cart
<img width="1440" alt="Monsters Be Shoppin' Cart" src="https://user-images.githubusercontent.com/62079009/88980631-5fe9e680-d281-11ea-90a4-58a43d6637db.jpeg">

### Merchant Show Page
<img width="1440" alt="Monsters Be Shoppin' Merchant Show Page" src="https://user-images.githubusercontent.com/62079009/88980727-8d369480-d281-11ea-85ef-b199afc8a809.jpeg">
