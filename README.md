# Lemyr

![Lemyr Logo](doc/lemyr-logo.png)
[Lemyr.co](http://www.lemyr.co)

Lemyr (lēmər): a web based platform for managing membership-based businesses. Originally designed for coworking spaces, Lemyr takes the tedium out of managing your members.

## Server Requirements

* Ubuntu/Debian based server
* Ruby 2.0+
* PostgreSQL 9.2+

For more details on setting up and configuring your server see our [Digital Ocean Setup Guide](wiki/Digital-Ocean-Setup-Guide).

## Installation

Once your server is setup and you have performed your initial deploy, run `rake lemyr:setup` to complete the install process.

## Testing

We currently have no automated tests for Lemyr. If you're looking for a easy place to start contributing, this is the place. We would prefer you to use RSpec and Capybara for writing tests, but if you write a full test spec in anything else we would happily switch to using that.

## Contribution/License

Lemyr uses the Affero GPL license as found [here](LICENSE). You can find a TL;DR version [here](https://tldrlegal.com/license/gnu-affero-general-public-license-v3-(agpl-3.0)), however this should not be used as legal reference.

You are free to modify the source as you wish and customize it as needed, as long as you provide public access to the source code with a detailed list of the changes you made. If you improve upon Lemyr we welcome you to contribute pull requests back to our repository, just remember to follow our [Contribution Guidelines](CONTRIBUTE.md).
