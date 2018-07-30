# docker-selenium-chrome-angular
A Selenium/standalone-chrome container with nodejs, npm, angular-cli ready for CI/CD testing

## Usage in GitLab-CI
You can select this image for use in GitLab-CI, like this (put in your `.gitlab-ci.yml` file):
```
[...]

develop_test:
  stage: test
  image: alexmazzariol/docker-selenium-chrome-angular
  script:
    - npm install
    - ng e2e

[...]
```

Make sure you set Protractor's config file to use the already-started Selenium instance, instead of spinning up one. Put something like this in your `e2e/protractor.conf.js`:
```
exports.config = {
[...]
  seleniumAddress: 'http://localhost:4444/wd/hub',
[...]
};
```
