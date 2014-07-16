# Contribute to Lemyr

Thank you for your interest in contributing to Lemyr. This guide will details who they core team members are and how to contribute code back to the project. Our goal is to streamline the process of reporting bugs and merging pull requests so that we can build a better community and product. Following this guide is crucial to the success of that goal.

## Team members

Lemyr was built for [CoworkMYR](http://www.coworkmyr.com) and open sourced by [Startup.SC](http://www.startup.sc). Core team members include:
* [Paul Reynolds](https://github.com/mbgeek)
* [Mike Schroll](https://github.com/MikeSchroll)
* [Adam Michel](https://github.com/awmichel)


## Security

Please privately report all security flaws and issues to lemyr-security@startup.sc. This gives us time to patch the flaw and notify all users that a fix is available before the issues becomes public. Please do NOT publicy disclose any security issues until we have had time to patch them.

## Reporting Issues

Before reporting any issue, please be sure to thoroughly [search through all issues](issues) for a possible duplicate. If you find a duplicate issue please reply with a `:+1:` or join the discussion and contribute more information towards solving the issue. If the duplicate issue has already been closed, please open a new issue, include a reference to the previous issue, and tag the issue as a regression. Use the following guide for submitting new issues:

1. **Summary**: Summarize your issue in once sentence. (What did you expect to happen and what really happened.)
2. **Steps to Reproduce**: Include steps to reproduce the issue with a fresh Lemyr install.
3. **Expected Behavior**: Include more details as to what you expected to happen and what really happened. Expand on your previous summary with any more information you feel necessary to fixing the issue.
4. **Logs and Screenshots**: Include any relevant logging information or screenshots of the behavior. Be sure to wrap all logging information in code blocks (```) to make it easier to read.
5. **Environment Details**: Please provide additional details about your environment, such as: hosting provider (Digital Ocean, AWS, Heroku), operating system details ([see here](http://www.cyberciti.biz/faq/find-linux-distribution-name-version-number/)), Ruby version (`ruby -v`), latest Git commit (`git rev-parse HEAD` in Lemyr directory).
6. **Solutions**: Include any fixes or solutions to the issues that you may have discovered. If possible create the issue in the form of a pull request for quicker issue resolution.

## Pull Request Guidelines

Pull requests should all start by following the guidelines for [Reporting Issues](#Reporting-Issues) and then include the following steps for building the pull request:

1. Fork the project on GitHub.
2. Create a new branch for your feature or fix. Use a branch name that is descriptive towards what it is solving.
3. Write some code and if we have adopted testing at this point, write a few tests as well.
4. If you end up with multiple commits while developing your feature or fix, please [squash them](http://git-scm.com/book/en/Git-Tools-Rewriting-History#Squashing-Commits) before submitting your pull request.
5. Push your new branch back to GitHub and create a new pull request towards the master branch of Lemyr.
6. When writing the description for you pull requests, use the issue reporting as a guide while keeping the following notes in mind:
  * If your pull request includes UI changes, include before and after screenshots.
  * If your pull request includes CSS changes, include a list of the affected pages.
  * Include links to any relevant issues or previous pull requests.
7. Submit you pull request and be prepared to answer a few questsions about your pull request before it is merged. We do our best to review and field requsts on a regular basis, but it may be a couple weeks before we get to it. Please be patient with us. Refer to our [Security](#Security) section on reporting security issues that are time sensitive.

## Thank You for Contributing

Thank you for taking the time to read this contribution guide and following a few simple guidelines to improve our community. If you ever happen to be in [Myrtle Beach, SC](http://whynotthebeach.com/) feel free to contact mike@startup.sc and stop by one of our [coworking spaces](http://www.startup.sc/community/) in the area.
