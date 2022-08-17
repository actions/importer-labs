# Forecast the usage of a GitLab namespace
In this lab we will us the `forecast` command to forecast potential GitHub Actions usage by computing metrics from historical pipeline data from the GitLab instance.  The metrics will be stored on disk in a markdown file and include job metrics for execution time, queue time, and concurrency.  We will look at each of these metrics in more depth later in this lab.

- [Prerequisites](#prerequisites)
- [Prepare for forecast](#prepare-for-forecast)
- [Perform a forecast](#perform-a-forecast)
- [Review forecast output](#review-forecast-output)

## Prerequisites

1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the [configure lab](../gitlab/valet-configure-lab.md).
3. Ran the setup script in the terminal to make sure the GitLab instance is ready .
   ```
   source gitlab/bootstrap/setup.sh
   ```

## Prepare for forecast
Before we can run the forecast we need to answer a few questions so we can construct the correct command.
1) What namespace do we want to run the forecast for?  __valet. This is the only group in the demo GitLab instance.__
2) What is the date we want to start forecasting from?  __08-02-2022. This is around but before the time the data was populated on our demo GitLab instance.__
3) Where do we want to store the results? __./tmp/forecast_reports. This can be any valid path on the system, but for simplicity it is recommend to use a directory in the root of the codespace workspace.__

## Perform a forecast
- Construct the command using the values from the questions above, it should look like:
```
gh valet forecast gitlab --output-dir ./tmp/forecast_reports --namespace valet --start-date 08-02-2022
```
- Run the command in the codespace terminal.
- Verify that you command outputed a similar result.
  ![forecast_output](https://user-images.githubusercontent.com/18723510/185232893-1ed46bca-f310-47dc-804c-40c13737f231.png)

## Review forecast report
Lets open the forecast report and look at the calculated metrics. 
- From the codespace explorer pane find `./tmp/forecast_reports/forecast_report.md` and click to open.
  ![forecast_explorer](https://user-images.githubusercontent.com/18723510/185234641-948a551b-316f-4cce-9e7d-4c078ae11a04.png)
- The file should be similar to this.
  <details>
  <summary>example forecast_report.md</summary>
  
  ```yaml
  # Forecast report for [GitLab](http://localhost/valet)

  - Valet version: **0.1.0.13432(03b5bc9370a8f0073c0cc1a4b25f6b81d0005c0f)**
  - Performed at: **8/17/22 at 20:00**
  - Date range: **2/8/22 - 8/17/22**

  ## Total

  - Job count: **57**
  - Pipeline count: **15**

  - Execution time

    - Total: **135 minutes**
    - Median: **0 minutes**
    - P90: **7 minutes**
    - Min: **0 minutes**
    - Max: **10 minutes**

  - Queue time

    - Median: **0 minutes**
    - P90: **5 minutes**
    - Min: **0 minutes**
    - Max: **42 minutes**

  - Concurrent jobs

    - Median: **0**
    - P90: **0**
    - Min: **0**
    - Max: **9**

  ---

  ## gitlab-runner

  - Job count: **57**
  - Pipeline count: **15**

  - Execution time

    - Total: **135 minutes**
    - Median: **0 minutes**
    - P90: **7 minutes**
    - Min: **0 minutes**
    - Max: **10 minutes**

  - Queue time

    - Median: **0 minutes**
    - P90: **5 minutes**
    - Min: **0 minutes**
    - Max: **42 minutes**

  - Concurrent jobs

    - Median: **0**
    - P90: **0**
    - Min: **0**
    - Max: **9**

  > Note: Concurrent jobs are calculated by using a sliding window of 1m 0s.
  ```
  ### Metrics
  
  ### Sections
  - `Total` shows the metrics using all of the known runners. 
  - `gitlab-runner` shows the metrics for the runners in the gitlab-runner group, if there were other groups they would show here under their own group heading.
  
  </details>
### TBD
