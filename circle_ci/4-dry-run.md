# Perform a dry-run migration of a CircleCI pipeline

In this lab you will use the `dry-run` command to convert a CircleCI pipeline to its equivalent GitHub Actions workflow.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your Codespace environment.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).
3. Completed the [audit lab](./2-audit.md).

## Perform a dry run

You will be performing a dry run migration against a CircleCI project. Answer the following questions before running this command:

1. What project do you want to convert?
    - __circleci-demo-ruby-rails__.  This is one of the sample projects avaiable in the CircleCI valet-labs organization.

2. Where do you want to store the result?
    - __tmp/dry-run__. This can be any path within the working directory that Valet commands are executed from.

### Steps

1. Navigate to your codespace terminal
2. Run the following command from the root directory:

    ```bash
    gh valet dry-run circle-ci --output-dir tmp/dry-run --circle-ci-project circleci-demo-ruby-rails
    ```

3. The command will list all the files written to disk when the command succeeds.

    ```console
    $ gh valet dry-run circle-ci --output-dir tmp/dry-run --circle-ci-project circleci-demo-ruby-rails --circle-ci-organization valet-labs
    [2022-09-19 19:46:03] Logs: 'tmp/dry-run/log/valet-20220919-194603.log'     
    [2022-09-19 19:46:05] Output file(s):                                           
    [2022-09-19 19:46:05]   tmp/dry-run/valet-labs/circleci-demo-ruby-rails/build_and_test.yml
    ```

4. View the converted workflow:
    - Find `tmp/dry-run/valet-labs/circleci-demo-ruby-rails` in the file explorer pane in your codespace.
    - Click `build_and_test.yml` to open.

## Inspect the output files

The files generated from the `dry-run` command represent the equivalent Actions workflow for the CircleCI project. The CircleCI configuration and converted workflow can be seen below:

<details>
  <summary><em>CircleCI configuration 👇</em></summary>

```yaml
version: 2.1

orbs:
  ruby: circleci/ruby@1.1.0
  node: circleci/node@2

jobs:
  build:
    docker:
      - image: cimg/ruby:2.7.5-node
    steps:
      - checkout
      - ruby/install-deps
      # Store bundle cache
      - node/install-packages:
          pkg-manager: yarn
          cache-key: "yarn.lock"
  test:
    parallelism: 3
    docker:
      - image: cimg/ruby:2.7.5-node
      - image: circleci/postgres:9.5-alpine
        environment:
          POSTGRES_USER: circleci-demo-ruby
          POSTGRES_DB: rails_blog_test
          POSTGRES_PASSWORD: ""
    environment:
      BUNDLE_JOBS: "3"
      BUNDLE_RETRY: "3"
      PGHOST: 127.0.0.1
      PGUSER: circleci-demo-ruby
      PGPASSWORD: ""
      RAILS_ENV: test
    steps:
      - checkout
      - ruby/install-deps
      - node/install-packages:
          pkg-manager: yarn
          cache-key: "yarn.lock"
      - run:
          name: Wait for DB
          command: dockerize -wait tcp://localhost:5432 -timeout 1m
      - run:
          name: Database setup
          command: bundle exec rails db:schema:load --trace
      # Run rspec in parallel
      - ruby/rspec-test
      - ruby/rubocop-check

workflows:
  version: 2
  build_and_test:
    jobs:
      - build
      - test:
          requires:
            - build

```

</details>

<details>
  <summary><em>Converted workflow 👇</em></summary>
  
```yaml
name: valet-labs/circleci-demo-ruby-rails/build_and_test
on:
  push:
    branches:
    - master
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: cimg/ruby:2.7.5-node
    steps:
    - name: Set up bundler cache
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.0.2
        bundler-cache: true
    - uses: actions/checkout@v2
    - run: bundle check || bundle install
      env:
        BUNDLE_DEPLOYMENT: true
    - id: yarn-cache-dir-path
      run: echo "::set-output name=dir::$(yarn config get cacheFolder)"
    - uses: actions/cache@v2
      with:
        path: "${{ steps.yarn-cache-dir-path.outputs.dir }}"
        key: "${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}"
        restore-keys: "${{ runner.os }}-yarn-"
    - run: yarn install --frozen-lockfile
  test:
    runs-on: ubuntu-latest
    container:
      image: cimg/ruby:2.7.5-node
    services:
      postgres:
        image: postgres:9.5-alpine
        env:
          POSTGRES_USER: circleci-demo-ruby
          POSTGRES_DB: rails_blog_test
          POSTGRES_PASSWORD: ''
    needs:
    - build
    env:
      BUNDLE_JOBS: '3'
      BUNDLE_RETRY: '3'
      PGHOST: 127.0.0.1
      PGUSER: circleci-demo-ruby
      PGPASSWORD: ''
      RAILS_ENV: test
    steps:
    - name: Set up bundler cache
      uses: ruby/setup-ruby@v1
      with:
        ruby-version: 3.0.2
        bundler-cache: true
    - uses: actions/checkout@v2
    - run: bundle check || bundle install
      env:
        BUNDLE_DEPLOYMENT: true
    - id: yarn-cache-dir-path
      run: echo "::set-output name=dir::$(yarn config get cacheFolder)"
    - uses: actions/cache@v2
      with:
        path: "${{ steps.yarn-cache-dir-path.outputs.dir }}"
        key: "${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}"
        restore-keys: "${{ runner.os }}-yarn-"
    - run: yarn install --frozen-lockfile
    - name: Wait for DB
      run: dockerize -wait tcp://localhost:5432 -timeout 1m
    - name: Database setup
      run: bundle exec rails db:schema:load --trace
    - run: bundle exec rspec spec --profile 10 --format RspecJunitFormatter --out /tmp/test-results/rspec/results.xml --format progress
    - run: bundle exec rubocop --format progress
```

</details>

Despite these two pipelines using different syntax they will function equivalently.

## Next lab

[Use custom transformers to customize Valet's behavior](./5-custom-transformers.md)
