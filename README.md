# URL Shortener

[Spec](https://gist.github.com/aesnyder/b54f1bfd048b1788241d4661cd8a99ce)

## Development / Test
### Install / Configure
1. Ensure Ruby 2.6.3 is installed (preferably via [asdf](https://github.com/asdf-vm/asdf)). 
2. Ensure Postgres 9.6+ is installed.
3. Edit `config/database.yml` and change database connection parameters as needed.
4. Install gems and initialize database: `bundle install`, `rails db:create`, `rails db:migrate`
5. (Optionally) seed database: `rails db:seed`

### Run / Test
*From the project root directory:*
- Run test suite: `rspec`
- Run development server on port 3000: `rails s -p 3000`
- Send an API request to create a short link:  
```
curl -H "Content-Type: application/json" -X POST -d '{"long_url": "zombo.com", "user_id": 1}' http://localhost:3000/short_link
```
- Visit the short link returned by the API in your browser and be redirected to zombo.com.
- View short link analytics: `curl http://localhost:3000/{{short_link}}+`

## Production 
For low-hassle production deployment, pick one and follow its instructions:
- [Heroku](https://www.heroku.com)
- [Cloud66](https://www.cloud66.com)
- [Nanobox](https://nanobox.io)
- [AWS Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/)
- [Dokku](https://github.com/dokku/dokku) (DIY Heroku)
