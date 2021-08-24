# Qulture.Rocks backend dev test

### Requirements

* Ruby 2.7.3
* PostgreSQL 12

### Setup

Follow the steps and run the commands inside the project root path.

1. Install the gems:

```shell
bundle install
```

2. Copy the `.env.example` file:

```shell
cp .env.example .env
```

Then you can set your own database variables. Check `config/database.yml` to see more about the configurations and default values.

3. Prepare the database:

```shell
rails db:prepare
```

4. Run the application with:

```shell
rails s
```

### Testing the API locally

You can test the GraphQL endpoints with [graphql_playground-rails gem](https://github.com/papodaca/graphql_playground-rails), already configured in this project. Access `http://localhost:3000/graphql_playground` (and follow the list of options to play with that!):

1. Change the endpoint URL to `http://localhost:3000/graphql`;
2. Here are some examples of queries and mutations (most of them). It will not appear in your local page, at least you add them;
3. Check the schema infos in the "schema" tab;
4. Note that you can also download it.

![Playground-graphql](https://user-images.githubusercontent.com/27731771/130633038-1cad74d5-7b45-4763-a399-d7b8f5dcf1f9.png)

### Test coverage

The current coverage of the project is 97.3%. GraphQL files are 99.38% covered, with one line missed at schema file (pratically 100%, considering the most important part of them).

 ![Test coverage](https://user-images.githubusercontent.com/27731771/130642398-48133dca-5f51-4a77-8acb-7e5ffcce42fe.png)

### Run automated tests

2. Run the tests with RSpec
```shell
rspec
```
