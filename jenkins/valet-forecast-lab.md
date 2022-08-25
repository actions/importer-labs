# Forecast the runner usage of a Jenkins instance

In this lab we will use the `forecast` command to forecast potential GitHub Actions usage by computing metrics from the historical pipeline data in our Jenkins instance. The metrics will be stored on disk in a markdown file and include job metrics for execution time, queue time, and concurrency. We will look at each of these metrics in more depth later in this lab.

- [Prerequisites](#prerequisites)
- [Prepare for forecast](#prepare-for-forecast)
- [Perform a forecast](#perform-a-forecast)
- [Review forecast report](#review-forecast-report)
- [Forecasting multiple providers](#forecasting-multiple-providers)
- [Next steps](#next-steps)

## Prerequisites

1. Followed [steps](../jenkins#readme) to set up your codespace environment.
2. Ran the setup script in the terminal to make sure the Jenkins instance is ready.
3. Completed the [configure lab](../Jenkins/valet-configure-lab.md).

## Prepare for forecast

Before we can run the forecast we need to answer a few questions so we can construct the correct command.

1. Do we want to forecast the entire Jenkins instance, or just a single folder?
- In this example we will be auditing the entire Jenkins instance, but in the future if you wanted to configure a specific folder to be audited add the `-f <folder_path>` flag to the forecast command.
2. What is the date we want to start forecasting from?
- __2022-08-02__. This date is before the time the data was populated in the Jenkins server running in these labs. This value defaults to the date one week ago, however, you should ensure a date is used that will capture enough data to get a representative view of typical usage.
3. Where do we want to store the results?
- `./tmp/forecast_reports`. This can be any valid path on the system, but for simplicity it is recommend to use a directory in the root of the workspace.

## Perform a forecast

- Using the answers above we get the following `forecast` command:

```
gh valet forecast jenkins --output-dir ./tmp/forecast_reports --start-date 2022-08-02
```

- Run the command in the codespace terminal.
- Verify that the command output is similar to this.
  ![forecast_output](https://user-images.githubusercontent.com/19557880/186223037-18556c82-5a29-4434-bc17-4b906d704967.png)

## Review forecast report

Open the forecast report and review the calculated metrics.

- From the codespace explorer pane find `./tmp/forecast_reports/forecast_report.md` and right-click, and select __Open Preview__.

![forecast_explorer](https://user-images.githubusercontent.com/18723510/185234641-948a551b-316f-4cce-9e7d-4c078ae11a04.png)

- The file should be similar to this.

<details>
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

</details>

### Metric Definitions

|  Name | Description |
| ----- | ----------- |
| Median | The __middle__ value |
| P90 | 90% of the values are less than or equal to |
| Min | The lowest value |
| Max | The highest value |

### Total Section

- This section shows the metrics for all of the jobs run within the Jenkins instance from 08/02/2022 to the time the command was executed.

## Total

- Job count: __73__
- Pipeline count: __6__

   ---

We can see there were 73 completed jobs across 6 unique pipelines. A pipeline can have one or more jobs and a pipeline may be executed multiple times in the date range included in the forecast.
  
  For example `monas_freestyle` contains 1 job.
  ![demo_pipeline](https://user-images.githubusercontent.com/19557880/186261368-d4dbbe8d-71e0-4084-bbbb-7557e9dbbb86.png)

Here are some key terms of items defined in the forecast report:

- The `job count` is the total number of completed jobs.
- The `pipeline count` is the number of unique pipelines used.
- `Execution time` describe the amount of time a runner spent on a job. This metric can be used for a customer to help set expectations for the cost of GitHub hosted runners.
  - This metric is correlated to the amount of spend a customer should expect in GitHub Actions. This will vary greatly depending on the hardware the customer uses for these minutes and the Actions pricing calculator should be used to get an estimate of the approximate spend the customer should expect.
  - Looking closer we can see during our forecast timeframe the total job run time was 27,057 minutes with 90% of the jobs finishing under 20 minutes, and the longest job taking 15,625 minutes.  The `min` is 0 because the quickest job took less than a minute and was rounded down to 0.

- `Queue time` metrics describe the amount of time a job spent waiting for a runner to be available to execute it.
- `Concurrent jobs` metrics describe the amount of jobs running at any given time. This metric can be used to define the number of runners a customer should configure.

Additionally, these metrics are defined for each queue of runners that a customer has defined in the CI/CD platform. This is especially useful for customers that use a mix of hosted and self-hosted runners to see runner utilization metrics that are specific to different types of runners.

### Runner Group Sections

- The preceding section shows the same metrics as the `Total` section, but are grouped by runner group. A runner group is a machine (or group of machines) that each job runs on
- In this case we do not have any runner groups, so the metrics match under `N/A` match the `Total` section. If there were different groups we could possibly identify runner types that needed to be increased or decreased when moving to GitHub Actions.

## Forecasting multiple providers

If we examine the help for the `forecast` command by running `gh valet forecast --help` we can see the option: `--source-file-path`

![forecast-help](https://user-images.githubusercontent.com/19557880/186263140-f02c6cab-7979-417c-bdfe-b9590e9c5597.png)

Using `--source-file-path` we can combine data from multiple forecast runs into a single report.  This becomes useful if we are using multiple CI/CD providers, such as Azure DevOps and Jenkins, and wanted to get a holistic view of the runner usage across the providers.  The way this works is the forecast command creates a `.json` file in a `jobs` directory for each command execution.  The `--source-file-path` takes a space-delimited list of data file paths or a glob pattern that will match all of the data files we want to include and combine into a single report. We will use a glob pattern, which in general should match `OUTPUT_DIR/**/jobs/*.json` where the `OUTPUT_DIR` is the previous value used for `--output-dir`, which in this lab was `./tmp/forecast_reports`. We do not have multiple providers but we can still try it out because we have a data file at `tmp/forecast_reports/jobs/`!

- run `gh valet forecast --source-file-path tmp/**/jobs/*.json -o tmp/combined-forecast`
- Now we have a new report that was generated from all the data files that matched the glob pattern. Note this command does not introspect the CI/CD provider, it only operates on the data files it finds.  
![combined-report](https://user-images.githubusercontent.com/19557880/186264213-b3201710-8093-4ae5-9aef-5c7f95cc3951.png)

## Next steps

This concludes the Valet labs for Jenkins! If you are interested exploring the power of Valet more, you can leverage the demo Jenkins Instance and modify and add new projects that more closely match your needs and try out the commands again!
