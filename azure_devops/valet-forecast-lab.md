# Forecast Azure DevOps usage using Valet's forecast command
In this lab we will use the `forecast` command to forecast potential GitHub Actions usage by computing metrics from the historical pipeline data in Azure DevOps.  The metrics will be stored on disk in a markdown file and include job metrics for execution time, queue time, and concurrency.  We will look at each of these metrics in more depth later in this lab.

- [Prerequisites](#prerequisites)
- [Prepare for forecast](#prepare-for-forecast)
- [Perform a forecast](#perform-a-forecast)
- [Review forecast report](#review-forecast-report)
- [Forecasting multiple providers](#forecasting-multiple-providers)
- [Next steps](#next-steps)

## Prerequisites
TBD

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
  
### Metric Definitions
|  Name | Description |
| ----- | ----------- |
| Median | The __middle__ value |
| P90 | 90% of the values are less than or equal to |
| Min | The lowest value |
| Max | The highest value |
   
### Total Section


### Runner Group Sections
- The preceding sections shows the same metrics as the `Total` section, but are broken out into runner groups. A runner group is a logical grouping of one or more runners.


## Forecasting multiple providers

## Next steps
