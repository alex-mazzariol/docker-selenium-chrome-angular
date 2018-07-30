# docker-selenium-chrome-angular
A Selenium/standalone-chrome container with nodejs, npm, angular-cli ready for CI/CD testing

## Usage in GitLab-CI
You can select this image for use in GitLab-CI to have a ready-to-use Selenium with Chrome standalone environment.

To use, please set the `image` parameter in your `.gitlab-ci.yml` to the correct repository/image, and don't forget to start the Selenium server before running e2e tests with `/opt/bin/entry_point.sh &`.
```
[...]

develop_test_e2e:
  stage: test
  image: alexmazzariol/docker-selenium-chrome-angular
  script:
    - npm i
    - /opt/bin/entry_point.sh &
    - ng e2e --protractorConfig="e2e/protractor.gitlab.conf.js"


develop_test_karma:
  stage: test
  image: alexmazzariol/docker-selenium-chrome-angular
  script:
    - npm i
    - /opt/bin/entry_point.sh &
    - ng test --karmaConfig="src/karma.gitlab.conf.js"

[...]
```

## Using with Protractor (e2e)
Make sure you set Protractor's config file to use the already-started Selenium instance, instead of spinning up one.

To do this, you must add a `seleniumAddress` value pointing to localhost, and remove/comment out the `directConnect` value.
Put something like this in your `e2e/protractor.conf.js` or an adequate copy of that (i.e. `e2e/protractor.gitlab.conf.js`), if you wish to keep using Protractor on the developers' workstations and on GitLab-CI:
```
exports.config = {
[...]
  directConnect: false,
  seleniumAddress: 'http://localhost:4444/wd/hub',
[...]
};
```

An example `e2e/protractor.gitlab.conf.js` from a recent Angular CLI (6.0.8) boilerplate project might then look like this:
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

## Using with Karma (unit tests)
A little more involved than with Protractor: you should first install the appropriate launcher plugin:
```
$ npm install karma-selenium-webdriver-launcher --save-dev
```
and then define a custom launcher in `src/karma.conf.js` (or an appropriate copy, like `src/karma.gitlab.conf.js`, as above):
```
const webdriver = require('selenium-webdriver');
[...]
module.exports = function (config) {
  config.set({
[...]
    browsers: ['Chrome-wd'],
    customLaunchers: {
        'Chrome-wd': {
            base: 'SeleniumWebdriver',
            browserName: 'Chrome',
            getDriver: function() {
                return new webdriver.Builder()
                    .forBrowser('chrome')
                    .usingServer('http://localhost:4444/wd/hub')
                    .build();
            }
	      }
    },
[...]
});
};
```
You may also want to set `singleRun` to `true`.

An example `src/karma.gitlab.conf.js` from a recent Angular CLI (6.0.8) boilerplate project might then look like this:
```
// Karma configuration file, see link for more information
// https://karma-runner.github.io/1.0/config/configuration-file.html
const webdriver = require('selenium-webdriver');

module.exports = function (config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine', '@angular-devkit/build-angular'],
    plugins: [
      require('karma-jasmine'),
      require('karma-chrome-launcher'),
      require('karma-selenium-webdriver-launcher'),
      require('karma-jasmine-html-reporter'),
      require('karma-coverage-istanbul-reporter'),
      require('@angular-devkit/build-angular/plugins/karma')
    ],
    client: {
      clearContext: false // leave Jasmine Spec Runner output visible in browser
    },
    coverageIstanbulReporter: {
      dir: require('path').join(__dirname, '../coverage'),
      reports: ['html', 'lcovonly'],
      fixWebpackSourcePaths: true
    },
    reporters: ['progress', 'kjhtml'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome-wd'],
    customLaunchers: {
        'Chrome-wd': {
            base: 'SeleniumWebdriver',
            browserName: 'Chrome',
            getDriver: function() {
                return new webdriver.Builder()
                    .forBrowser('chrome')
                    .usingServer('http://localhost:4444/wd/hub')
                    .build();
            }
        }
    },
    singleRun: true
  });
};
```
