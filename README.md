[![Lemyr Logo](doc/lemyr-logo.png)](http://lemyr.co)

Lemyr (lēmər): a web based platform for managing membership-based businesses. Originally designed for coworking spaces, Lemyr takes the tedium out of managing your members.

## Server Requirements

* Ubuntu/Debian based server
* Ruby 2.0+
* PostgreSQL 9.2+

For more details on setting up and configuring your server see our [Digital Ocean Setup Guide](wiki/Digital-Ocean-Setup-Guide).

## Installation

Below is a list of services that can be utilized within Lemyr. The required ones are marked in bold.

* [**AWS S3 Bucket**](http://aws.amazon.com) (Avatar Uploads)
* [**Stripe**](https://stripe.com) (Payments)
* **SMTP/Email Server** - We Recommend [Mandrill](http://mandrillapp.com) (Transactional Emails)
* [Facebook](https://developers.facebook.com) (OAuth/Checkin Location)[1]
* [Twitter](https://dev.twitter.com) (OAuth/Retweeting)[2]
* [Google+](https://code.google.com/apis/console/) (OAuth)
* [Google Analytics](http://www.google.com/analytics/)
* [Foursquare](https://developer.foursquare.com/) (OAuth/Checkin Location)
* [LinkedIn](http://developer.linkedin.com/) (OAuth)
* [Meetup](http://www.meetup.com/meetup_api/) (Upcoming Events)
* [MailChimp](http://mailchimp.com/) (Newsletter Subscriptions)

Once you have a server setup and prepared you can follow our [Application Setup Guide](wiki/Application-Setup) to perform the initial configuration of Lemyr and start accepting members.

**Notes**
[1]: Note when setting up your Facebook Page you need to create it as a Local Business so it will be assigned a Place ID for the checkins.
[2]: You may want to setup a separate Twitter account for the checkin mentions if you are concerned about diluting your primary brand.

## Testing

We currently have no automated tests for Lemyr. If you're looking for a easy place to start contributing, this is the place. We would prefer you to use RSpec for writing tests, but if you write a full test spec in anything else we would happily use that.

## Contribution/License

Lemyr uses the Affero GPL license as found [here](LICENSE). You can find a TL;DR version [here](https://tldrlegal.com/license/gnu-affero-general-public-license-v3-(agpl-3.0)), however this should not be used as legal reference.

You are free to modify the source as you wish and customize it as needed, as long as you provide public access to the source code with a detailed list of the changes you made. If you improve upon Lemyr we welcome you to contribute pull requests back to our repository, just remember to follow our [Contribution Guidelines](CONTRIBUTE.md).
