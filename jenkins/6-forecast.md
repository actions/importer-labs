# Forecast the runner usage of a Jenkins instance

In this lab you will use the `forecast` command to forecast potential GitHub Actions usage by computing metrics from completed pipeline runs in your Jenkins server.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your Codespace environment and start a Jenkins server.
2. Completed the [configure lab](./1-configure-lab.md#configuring-credentials).

## Perform a forecast

We will need to answer the following questions before running the `forecast` command:

1. Do we want to forecast the entire Jenkins server or a single folder?
    - We will be forecasting the entire Jenkins server but we could optionally limit this by using the `-f <folder_path>` CLI option.

2. What is the date we want to start forecasting from?
    - __2022-08-02__. This date is needed as it is prior to when the data was seeded in Jenkins for these labs. This value defaults to the date one week ago, however, you should use a start date that will show a representative view of typical usage.

3. Where do we want to store the results?
    - `./tmp/forecast_reports`

### Steps

1. Navigate to the codespace terminal
2. Run the following command from the root directory:

    ```bash
    gh valet forecast jenkins --output-dir ./tmp/forecast_reports --start-date 2022-08-02
    ```

3. The command will list all the files written to disk when the command succeeds.

    ![img](https://user-images.githubusercontent.com/19557880/186223037-18556c82-5a29-4434-bc17-4b906d704967.png)

## Review the forecast report

The forecast report, logs, and completed job data will be located within the `tmp/forecast_reports` folder.

1. Find the `forecast_report.md` file in the file explorer.
2. Right-click the `forecast_report.md` file and select `Open Preview`.
3. This file contains metrics used to forecast potential GitHub Actions usage.


<!-- <details>
<summary>example forecast_report.md</summary>

# Forecast report for [Jenkins](http://localhost:8080)

- Valet version: __0.1.0.13448(2222622ecf83e372990e1657b1293e1ac552be21)__
- Performed at: __8/23/22 at 17:11__
- Date range: __8/2/22 - 8/23/22__

## Total

- Job count: __73__
- Pipeline count: __6__

- Execution time

  - Total: __27,057 minutes__
  - Median: __2 minutes__
  - P90: __19 minutes__
  - Min: __0 minutes__
  - Max: __15,625 minutes__

- Queue time

  - Median: __0 minutes__
  - P90: __0 minutes__
  - Min: __0 minutes__
  - Max: __0 minutes__

- Concurrent jobs

  - Median: __1__
  - P90: __3__
  - Min: __0__
  - Max: __29__

    ---

## N/A

- Job count: __73__
- Pipeline count: __6__

- Execution time

  - Total: __27,057 minutes__
  - Median: __2 minutes__
  - P90: __19 minutes__
  - Min: __0 minutes__
  - Max: __15,625 minutes__

- Queue time

  - Median: __0 minutes__
  - P90: __0 minutes__
  - Min: __0 minutes__
  - Max: __0 minutes__

- Concurrent jobs

  - Median: __1__
  - P90: __3__
  - Min: __0__
  - Max: __29__

    > Note: Concurrent jobs are calculated by using a sliding window of 1m 0s.

</details> -->


### Total

The "Total" section of the forecast report contains high level statistics related to all the jobs completed after the `--start-date` CLI option:

```md
- Job count: __73__
- Pipeline count: __6__

- Execution time

  - Total: __27,057 minutes__
  - Median: __2 minutes__
  - P90: __19 minutes__
  - Min: __0 minutes__
  - Max: __15,625 minutes__

- Queue time

  - Median: __0 minutes__
  - P90: __0 minutes__
  - Min: __0 minutes__
  - Max: __0 minutes__

- Concurrent jobs

  - Median: __1__
  - P90: __3__
  - Min: __0__
  - Max: __29__
```

Here are some key terms of items defined in the forecast report:

- The `job count` is the total number of completed jobs.
- The `pipeline count` is the number of unique pipelines used.
- `Execution time` describes the amount of time a runner spent on a job. This metric can be used to help plan for the cost of GitHub hosted runners.
  - This metric is correlated to how much you should expect to spend in GitHub Actions. This will vary depending on the hardware used for these minutes and the [Actions pricing calculator](https://github.com/pricing/calculator) should be used to estimate a dollar amount.
- `Queue time` metrics describe the amount of time a job spent waiting for a runner to be available to execute it.
- `Concurrent jobs` metrics describe the amount of jobs running at any given time. This metric can be used to define the number of runners a customer should configure.

Additionally, these metrics are defined for each queue of runners defined in Jenkins. This is especially useful if there are a mix of hosted/self-hosted runners or high/low spec machines to see metrics specific to different types of runners.

## Forecasting multiple providers

We can examine the available options for the `forecast` command by running `gh valet forecast --help`. When you do this you will see the `--source-file-path` option:

![img](https://user-images.githubusercontent.com/19557880/186263140-f02c6cab-7979-417c-bdfe-b9590e9c5597.png)

The `--source-file-path` CLI option can be used to combine data from multiple reports into a single report. This becomes useful if you use multiple CI/CD providers and wanted to get a holistic view of the runner usage. This works by using the `.json` files generated by `forecast` commands as space-delimited values for the `--source-file-path` CLI option. Optionally, this value could be a glob pattern to dynamically specify the list of files (e.g. `**/*.json`).

Run the following command from within the codespace terminal:

```bash
gh valet forecast --source-file-path tmp/**/jobs/*.json -o tmp/combined-forecast
```

You can now inspect the output of the command to see a forecast report using all of the files matching the `tmp/**/jobs/*.json` pattern.

## Next steps

This concludes all labs for migrating Jenkins pipelines to Actions with Valet!