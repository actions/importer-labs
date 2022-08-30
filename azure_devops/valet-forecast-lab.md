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

Using these answers our command becomes:
```
gh valet forecast azure-devops --output-dir ./tmp/forecast_reports --start-date "2022-03-02" 
```

## Perform a forecast
Instead of using the command generated in the previous step.  We will instead use a different one that will `forecast` using data previously generated.  

The reason for this is that it is very likely that the ADO project generated for the Valet labs does not have any pipelines that have ran and probably no runners available.  So rather than setting up runners and triggering pipelines we will instead use the `--source-file` option of the `forecast` command. If you would like you can try the command above, it will likely return "no jobs"


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
