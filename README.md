# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:
Using Postman to hit endpoints

Get Started:

- `git clone https://github.com/TheeGrassHopper/blogger.git`
- `bundle install`
- `rails db:create`
- `rails db:migrate`
- `rails db:seed`
- `rspec`
- `rails s`

### Avaiable Endpoints

 - `GET /articles`
- ` GET /articles?search=foo`
  should filter article to only those containing string 'foo'
- ` GET /articles/:id`
- ` POST /articles`
  it should validate presence of title and body
  it should validate that title is at least 10 characters long
- ` PUT /articles`
  same as POST
- ` DELETE /articles/:id`

- ` GET /comments`
- ` GET /comments?article_id=1`
  should filter comments by specific article
- ` GET /comments/:id`
- ` POST /comments`
  it should validate presence of necceary attributes
- ` PUT /comments`
- ` DELETE /comments/:id`