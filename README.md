# Currency Converter

The currency converter app utilises the [fixer](fixer.io.) API to fetch and display currency data.

The app itself contains two pages:

- A page showing the conversion rates with a form to add new pairs
- A management page

## Instructions to run App

**1.** Clone this repo

`git clone https://github.com/hamlees93/currency_converter_app.git`

**2.** Change into the currency_converter directory

`cd currency_converter_app`

**3.** Install Dependencies

`bundle install`

**4.** Ensure you have your Postrgresql up and running

**5.** Initialise the database for the App

`rails db:create`

**6.** Migrate the database across to postgresql

`rails db:migrate`

**7.** This app also utilises a gem called [sidekiq](https://github.com/mperham/sidekiq), which relies on Redis as a dependency

    - If you do not have redis installed, either: `brew install redis` or [Follow these steps](https://redis.io/topics/quickstart)

**8.** In a new tab, start your redis server

`redis-server`

**9.** In a new tab, start sidekiq

`sidekiq`

**10.** In a new tab, start your rails server

`rails s`

**11.** To run tests, ensure you are in the root directory of the app, then run:

`rspec`

## Tech

- Rails
- Postgresql
- Redis

## Decisions

- One of the requirements, was to ensure the current rates were getting loaded into this app, but this could not be done through an API call on the page render. After much research, I landed on a gem called **sidekiq**, which relies on a **redis-server** running. Data is fetched in the following ways:
  - **application_helper.rb** - If the current rates in the database are more than 60 minutes old, an API call will be sent out to retrieve the new rates, which will be saved in the database. Initially, I did not want a database call every time a page renders, but I decided it would be best to sacrifice a tiny bit of performance for more accurate data
  - **rates_controller.rb** - Everytime a new currency pair is created or deleted, a request is sent out to retrieve the most recent rates. This request does not slow the app, as it is **asynchronous**. When the page is rendered again, it will pull from the database, which will be no less than 60 minutes old. Whilst this request could have been placed in the **index** method, and made eveytime the page was loaded, I made the final trade off to limit API calls, at the expense of a few minutes of data accuracy
  - **rate.rb** - Using redis to store the rates, the app is able to check this hash to see if the currency entered by the user is a valid one. If it is not, or if it is a repeatted pairing, an error message will be displayed to the user, and the pairing will not be saved
  - **rate_worker.rb** - Using **sidekiq**, this worker will go about it's request asynchronously, thus not impacting the loading time. The free tier of fixer did not allow the base rate to change, from EUR, on a request. So, when saving a rate, the EUR / currency_2 rate is divided by the EUR / currency_1 rate to get the current rate of the two pairs
- **Tests** - Have been set up to test the basic functionality of the app

### Additional Notes

This app relies on the Fixer.io API. If you need to load your own key, follow the steps below:

**1.** This App depends on an external services. To ensure functionality, head to [fixer](fixer.io.) and sign up for their API (you can use the free tier)

**2.** Securely store your access key in the credentials file by running the following command in your shell, Replacing &lt;YOUR_FAV_EDITOR&gt; with your favourite editor:

```bash
EDITOR=<YOUR_FAV_EDITOR> bin/rails credentials:edit
```

**3.** Once your editor loads up, add in the following code, once again replacing &lt;YOUR_ACCESS_KEY&gt; with, you guessed it, your access key from [fixer](fixer.io.):

```yml
fixer:
  access_key: <YOUR_ACCESS_KEY>
```
