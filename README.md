# docker-selenium-chrome-angular
A Selenium/standalone-chrome container with nodejs, npm, angular-cli ready for CI/CD testing

## Usage in GitLab-CI
You can select this image for use in GitLab-CI to have a ready-to-use Selenium with Chrome standalone environment.

To use, please set the `image` parameter in your `.gitlab-ci.yml` to the correct repository/image, and don't forget to start the Selenium server before running e2e tests with `/opt/bin/entry_point.sh &`.
```
[...]

develop_test:
  stage: test
  image: alexmazzariol/docker-selenium-chrome-angular
  script:
    - npm i
    - /opt/bin/entry_point.sh &
    - ng e2e

[...]
```

Make sure you set Protractor's config file to use the already-started Selenium instance, instead of spinning up one.

To do this, you must add a `seleniumAddress` value pointing to localhost, and remove/comment out the `directConnect` value.
Put something like this in your `e2e/protractor.conf.js`:
```
exports.config = {
[...]
  directConnect: false,
  seleniumAddress: 'http://localhost:4444/wd/hub',
[...]
};
```

An example `e2e/protractor.conf.js` from a recent Angular CLI (6.0.8) boilerplate project might then look like this:
```
// Protractor configuration file, see link for more information                                                                              
// https://github.com/angular/protractor/blob/master/lib/config.ts                                                                           

const { SpecReporter } = require('jasmine-spec-reporter');

exports.config = {
  allScriptsTimeout: 11000,
  specs: [
    './src/**/*.e2e-spec.ts'
  ],
  capabilities: {
    'browserName': 'chrome'
  },
  baseUrl: 'http://localhost:4200/',
  seleniumAddress: 'http://localhost:4444/wd/hub',
  framework: 'jasmine',
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000,
    print: function() {}
  },
  onPrepare() {
    require('ts-node').register({
      project: require('path').join(__dirname, './tsconfig.e2e.json')
    });
    jasmine.getEnv().addReporter(new SpecReporter({ spec: { displayStacktrace: true } }));
  }
};
```
