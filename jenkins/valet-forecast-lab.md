# Forecast the usage of a Jenkins namespace

In this lab we will use the `forecast` command to forecast potential GitHub Actions usage by computing metrics from the historical pipeline data in our Jenkins instance. The metrics will be stored on disk in a markdown file and include job metrics for execution time, queue time, and concurrency. We will look at each of these metrics in more depth later in this lab.

- [Prerequisites](#prerequisites)
- [Prepare for forecast](#prepare-for-forecast)
- [Perform a forecast](#perform-a-forecast)
- [Review forecast report](#review-forecast-report)
- [Forecasting multiple providers](#forecasting-multiple-providers)
- [Next steps](#next-steps)

## Prerequisites

1. Followed [steps](../jenkins#readme) to set up your codespace environment.
2. Completed the [configure lab](../Jenkins/valet-configure-lab.md).
3. Ran the setup script in the terminal to make sure the Jenkins instance is ready.

## Prepare for forecast

Before we can run the forecast we need to answer a few questions so we can construct the correct command.

1) Do we want to forecast the entire Jenkins instance, or just a single folder? __In this example we will be auditing the entire Jenkins instance, but in the future if you wanted to configure a specific folder to be audited add the `-f <folder_path>` flag to the forecast command__
2) What is the date we want to start forecasting from?  __2022-08-02. This date is before the time the data was populated on our demo Jenkins instance. In practice, this should be a date that will give you enough data to get a good understanding of the typical usage.  Too little data and the metrics might not give an accurate picture__
3) Where do we want to store the results? __./tmp/forecast_reports. This can be any valid path on the system, but for simplicity it is recommend to use a directory in the root of the codespace workspace.__

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
  We can see we ran 6 pipelines that contained 73 jobs. In the case of Jenkins, jobs refer to the concept of steps. The number of jobs(steps) is expected to be larger than the number of pipelines because a pipeline is typically a collection of jobs.
  
  For example `monas_freestyle` contains 3 jobs
  ![demo_pipeline](https://user-images.githubusercontent.com/19557880/186261368-d4dbbe8d-71e0-4084-bbbb-7557e9dbbb86.png)

- `Execution time` shows the metrics for the time a job __took to run__. Looking closer we can see during our forecast timeframe the total job run time was 27,057 minutes with 90% of the jobs finishing under 20 minutes, and the longest job taking 15,625 minutes.  The `min` is 0 because the quickest job took less than a minute and was rounded down to 0.
  - Execution time
    - Total: __27,057 minutes__
    - Median: __2 minutes__
    - P90: __19 minutes__
    - Min: __0 minutes__
    - Max: __15,625 minutes__

- `Queue time` shows the metrics for how long jobs __waited__ for a runner to be available.  
  - Queue time
    - Median: __0 minutes__
    - P90: __0 minutes__
    - Min: __0 minutes__
    - Max: __0 minutes__

- `Concurrent jobs` show the metrics for how many jobs were run at the __same time__.
  - Concurrent jobs
    - Median: __0__
    - P90: __3__
    - Min: __0__
    - Max: __29__

### Runner Group Sections

- The preceding section shows the same metrics as the `Total` section, but are grouped by runner group. A runner group is a machine (or group of machines) that each job runs on
- In this case we do not have any runner groups, so the metrics match under `N/A` match the `Total` section. If there were different groups we could possibly identify runner types that needed to be increased or decreased when moving to GitHub Actions.

## Forecasting multiple providers

If we examine the help for the `forecast` command by running `gh valet forecast --help` we can see a new option `--source-file-path`

![forecast-help](https://user-images.githubusercontent.com/19557880/186263140-f02c6cab-7979-417c-bdfe-b9590e9c5597.png)

Using `--source-file-path` we can combine data from multiple forecast runs into a single report.  This becomes useful if we are using multiple CI/CD providers, such as Azure DevOps and Jenkins, and wanted to get a holistic view of the runner usage across the providers.  The way this works is the forecast command creates a `.json` file in a `jobs` directory for each command execution.  The `--source-file-path` takes a space-delimited list of data file paths or a glob pattern that will match all of the data files we want to include and combine into a single report. We will use a glob pattern, which in general should match `OUTPUT_DIR/**/jobs/*.json` where the `OUTPUT_DIR` is the previous value used for `--output-dir`, which in this lab was `./tmp/forecast_reports`. We do not have multiple providers but we can still try it out because we have a data file at `tmp/forecast_reports/jobs/`!

- run `gh valet forecast --source-file-path tmp/**/jobs/*.json -o tmp/combined-forecast`
- Now we have a new report that was generated from all the data files that matched the glob pattern. Note this command does not introspect the CI/CD provider, it only operates on the data files it finds.  
![combined-report](https://user-images.githubusercontent.com/19557880/186264213-b3201710-8093-4ae5-9aef-5c7f95cc3951.png)

## Next steps

This concludes the Valet labs for Jenkins! If you are interested exploring the power of Valet more, you can leverage the demo Jenkins Instance and modify and add new projects that more closely match your needs and try out the commands again!
