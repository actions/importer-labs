# Forecast Azure DevOps usage using Valet's forecast command
In this lab we will use the `forecast` command to forecast potential GitHub Actions usage by computing metrics from the historical pipeline data in Azure DevOps.  The metrics will be stored on disk in a markdown file and include job metrics for execution time, queue time, and concurrency.  We will look at each of these metrics in more depth later in this lab.

- [Prerequisites](#prerequisites)
- [Prepare for forecast](#prepare-for-forecast)
- [Perform a forecast](#perform-a-forecast)
- [Review forecast report](#review-forecast-report)
- [Forecasting multiple providers](#forecasting-multiple-providers)
- [Next steps](#next-steps)

## Prerequisites
1. Follow all steps [here](../azure_devops#readme) to set up your environment
2. Create or start a codespace in this repository (if not started)

## Prepare for forecast
Before we can run the forecast we need to answer a few questions so we can construct the correct command.
1) What is the date we want to start forecasting from?  __2022-03-02. This should be a date that will give enough data to get a good understanding of the typical usage.__
2) Where do we want to store the results? __./tmp/forecast_reports. This can be any valid path on the system, but for simplicity it is recommend to use a directory in the root of the codespace workspace.__ 
3) What project do we want to run the forecast for? __ValetBootStrap.  This is the default project name for the labs, if you choose a different name then use that instead.__

Using these answers our command becomes:
```
gh valet forecast azure-devops --output-dir ./tmp/forecast_reports --azure-devops-project YOUR_PROJECT_NAME_HERE --start-date "2022-03-02" 
```

## Perform a forecast
- Run the command generated in the previous step in the terminal.
- It will likely return "No Jobs" because we have no pipelines that ran during the timeframe we picked. Actually our demo project has never had any pipelines run so any date we pick will return no jobs.
![no-jobs](https://user-images.githubusercontent.com/18723510/187690315-6312088d-9888-4c55-9bbf-c6f2687fa547.png)
- lets use the `--source-file` option of the forecast command to generate a report that we can review. This option is normally used to create reports using data from multiple CI/CD providers, but in this case we can use it to create a report from sample Azure DevOps data.  We can view the `forecast` command options by using the help flag `gh valet forecast --help`
![help-menu](https://user-images.githubusercontent.com/18723510/187692843-623d4bdc-8970-4348-a632-73c8b00a40f8.png)
- Run `gh valet forecast azure-devops -o ./tmp/sample_report --source-file-path azure_devops/jobs_data.json`
- A report should be generated from the sample data!
![sample-report](https://user-images.githubusercontent.com/18723510/187694590-9121b997-0c89-4984-bbf2-84f3df2ed882.png)

## Review forecast report
Open the forecast report and review the calculated metrics. 
- From the codespace explorer pane find `./tmp/sample_report/forecast_report.md` and right-click, and select __Open Preview__.
![explorer-report](https://user-images.githubusercontent.com/18723510/187696893-6d503d8d-b512-427a-af42-bbf053fa4df4.png)
- The file should be similar to this.
  <details>
  <summary>example forecast_report.md</summary>
 
  # Forecast report for [Azure DevOps](https://dev.azure.com/jd-testing-org/ValetBootstrap/_build)

  - Valet version: **0.1.0.13529(efcc91120eaf5ecb40df6af034c64580cbcfd2e8)**
  - Performed at: **8/31/22 at 13:46**
  - Date range: **4/5/22 - 8/19/22**

  ## Total

  - Job count: **186**
  - Pipeline count: **60**

  - Execution time

    - Total: **153 minutes**
    - Median: **0 minutes**
    - P90: **1 minutes**
    - Min: **0 minutes**
    - Max: **4 minutes**

  - Queue time

    - Median: **0 minutes**
    - P90: **1 minutes**
    - Min: **0 minutes**
    - Max: **5 minutes**

  - Concurrent jobs

    - Median: **0**
    - P90: **0**
    - Min: **0**
    - Max: **4**

  ---

  ## Azure Pipelines

  - Job count: **183**
  - Pipeline count: **58**
  - Total consumption: **99%**

  - Execution time

    - Total: **151 minutes**
    - Median: **0 minutes**
    - P90: **1 minutes**
    - Min: **0 minutes**
    - Max: **4 minutes**

  - Queue time

    - Median: **0 minutes**
    - P90: **1 minutes**
    - Min: **0 minutes**
    - Max: **5 minutes**

  - Concurrent jobs

    - Median: **0**
    - P90: **0**
    - Min: **0**
    - Max: **4**

  ---

  ## Default

  - Job count: **3**
  - Pipeline count: **2**
  - Total consumption: **1%**

  - Execution time

    - Total: **1 minutes**
    - Median: **0 minutes**
    - P90: **0 minutes**
    - Min: **0 minutes**
    - Max: **0 minutes**

  - Queue time

    - Median: **0 minutes**
    - P90: **0 minutes**
    - Min: **0 minutes**
    - Max: **0 minutes**

  - Concurrent jobs

    - Median: **0**
    - P90: **0**
    - Min: **0**
    - Max: **1**

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
- This section shows the metrics for all of the jobs run in our sample data. 
   ## Total

   - Job count: **186**
   - Pipeline count: **60**
   ---
  We can see there were 60 pipelines that ran and they contained 186 jobs.  The number of jobs is expected to be equal or larger than pipelines because a pipeline is typically a collection of jobs.

-  `Execution time` shows the metrics for the time a job __took to run__. Looking closer we can see during our forecast timeframe the total job run time was 153 minutes, with 90% of the jobs finishing under 1 minute, and the longest job taking 4 minutes.  The `Min` and `Median` are 0 because they were less than a minute and was rounded down to 0.
     - Execution time
       - Total: **153 minutes**
       - Median: **0 minutes**
       - P90: **1 minutes**
       - Min: **0 minutes**
       - Max: **4 minutes**
    
- `Queue time` shows the metrics for how long jobs __waited__ for a runner to be available.  
     - Queue time
       - Median: **0 minutes**
       - P90: **1 minutes**
       - Min: **0 minutes**
       - Max: **5 minutes**
- `Concurrent jobs` show the metrics for how many jobs were run at the __same time__.
     - Concurrent jobs
       - Median: **0**
       - P90: **0**
       - Min: **0**
       - Max: **4**

### Runner Group Sections
- The preceding sections shows the same metrics as the `Total` section, but are broken out into runner groups. A runner group is a logical grouping of one or more runners.


## Forecasting multiple providers

## Next steps
