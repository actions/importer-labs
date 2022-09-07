# Forecast Azure DevOps usage using Valet's forecast command
In this lab we will use the `forecast` command to forecast potential GitHub Actions usage by computing metrics from the historical pipeline data in Azure DevOps. The metrics will be stored on disk in a markdown file and include job metrics for execution time, queue time, and concurrency. We will look at each of these metrics in more depth later in this lab.

- [Prerequisites](#prerequisites)
- [Prepare for forecast](#prepare-for-forecast)
- [Perform a forecast](#perform-a-forecast)
- [Review forecast report](#review-forecast-report)
- [Next steps](#next-steps)

## Prerequisites
1. Follow all steps [here](../azure_devops#readme) to set up your environment
2. Create or start a codespace in this repository (if not started)

## Prepare for forecast
Before we can run the forecast we need to answer a few questions so we can construct the correct command:

1. Where do we want to store the results? 

- __./tmp/forecast_reports__. This can be any valid path on the system but for simplicity it is recommend to use a directory in the root of the Codespace workspace. 

2. What project do we want to run the forecast for? 

- __YOUR_PROJECT_NAME__. This is the project name you chose during the lab setup [here](../azure_devops/readme.md#bootstrap-your-azure-devops-organization).

Using these answers our command becomes:
```
gh valet forecast azure-devops --output-dir ./tmp/forecast_reports --azure-devops-project YOUR_PROJECT_NAME_HERE
```

## Perform a forecast
- Run the command generated in the previous step in the terminal.
- You should get "No jobs found" because we have no pipelines that ran during the timeframe we picked. Actually, our demo project has never had any pipelines run so any date we pick will return no jobs.
![no-jobs](https://user-images.githubusercontent.com/18723510/187690315-6312088d-9888-4c55-9bbf-c6f2687fa547.png)
- lets use the `--source-file` option of the forecast command to generate a report that we can review. This option is normally used to create reports using data from multiple CI/CD providers, but in this case we can use it to create a report from sample Azure DevOps data.  We can view the `forecast` command options by using the help flag `gh valet forecast --help`.
![help-menu](https://user-images.githubusercontent.com/18723510/187692843-623d4bdc-8970-4348-a632-73c8b00a40f8.png)
- Run the `forecast` command using the sample data.
  ```
  gh valet forecast azure-devops -o ./tmp/sample_report --source-file-path azure_devops/jobs_data.json
  ```
- A report should be generated from the sample data!
![sample-report](https://user-images.githubusercontent.com/18723510/187694590-9121b997-0c89-4984-bbf2-84f3df2ed882.png)

## Review forecast report
Open the forecast report and review the calculated metrics. 
- From the codespace explorer pane find `./tmp/sample_report/forecast_report.md` and right-click, and select __Open Preview__.

  ![explorer-report](https://user-images.githubusercontent.com/18723510/187696893-6d503d8d-b512-427a-af42-bbf053fa4df4.png)

- Verify your report looks similar.
  <details>
  <summary><em>click to expand example forecast_report.md</em></summary>
  
  # Forecast report for [Azure DevOps](https://dev.azure.com/jd-testing-org/ValetBootstrap/_build)

  - Valet version: **0.1.0.13529(efcc91120eaf5ecb40df6af034c64580cbcfd2e8)**
  - Performed at: **9/1/22 at 19:10**
  - Date range: **9/1/22 - 9/1/22**

  ## Total

  - Job count: **84**
  - Pipeline count: **32**

  - Execution time

    - Total: **82 minutes**
    - Median: **0 minutes**
    - P90: **2 minutes**
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
    - Max: **5**

  ---

  ## Azure Pipelines

  - Job count: **81**
  - Pipeline count: **30**
  - Total consumption: **98%**

  - Execution time

    - Total: **80 minutes**
    - Median: **0 minutes**
    - P90: **2 minutes**
    - Min: **0 minutes**
    - Max: **4 minutes**

  - Queue time

    - Median: **0 minutes**
    - P90: **2 minutes**
    - Min: **0 minutes**
    - Max: **5 minutes**

  - Concurrent jobs

    - Median: **0**
    - P90: **0**
    - Min: **0**
    - Max: **5**

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
| P90 | 90% of the values are less than or equal to this |
| Min | The lowest value |
| Max | The highest value |
   
### Total Section
- This section shows the metrics for all of the jobs run in our sample data. 
   ## Total
    - Job count: **84**
    - Pipeline count: **32**
   ---
  We can see there were 32 pipelines that ran and they contained 84 jobs.  The number of jobs is expected to be equal or larger than pipelines because a pipeline is typically a collection of jobs.

-  `Execution time` shows the metrics for the time a job __took to run__. Looking closer we can see during our forecast timeframe the total job run time was 82 minutes, with 90% of the jobs finishing in or under 2 minute, and the longest job took 4 minutes.  The `Min` and `Median` are 0 because they were less than a minute and were rounded down to 0.
     - Execution time
        - Total: **82 minutes**
        - Median: **0 minutes**
        - P90: **2 minutes**
        - Min: **0 minutes**
        - Max: **4 minutes**
    
- `Queue time` shows the metrics for how long jobs __waited__ for a runner to be available.  
     - Queue time
       - Median: **0 minutes**
       - P90: **1 minutes**
       - Min: **0 minutes**
       - Max: **5 minutes**
- `Concurrent jobs` show the metrics for how many jobs started or ended within the same 60 second time slice. The time slice window can be changed using the `--time-slice` option.
     - Concurrent jobs
       - Median: **0**
       - P90: **0**
       - Min: **0**
       - Max: **5**

### Runner Group Sections
- The preceding sections shows the same metrics as the `Total` section, but are broken out into runner groups. A runner group is a logical grouping in Azure DevOps of one or more runners. In our case we have groups named `Azure Pipelines` and `Default`.  These sections can be used to identify runner types that needed to be increased or decreased when moving to GitHub Actions.  Looking at the report the `Default` group was only used for 3 jobs and a ran for a total of 1 minute.  This might be a group of runners we do not need to migrate to Actions.

## Next steps
This concludes the Valet labs for Azure Devops, if you are interested exploring the power of Valet more. You can leverage the lab environment and modify and add new pipelines that more closely match your needs and try out the commands again!
