# Forecast the usage of a GitLab namespace
In this lab we will us the `forecast` command to forecast potential GitHub Actions usage by computing metrics from historical pipeline data from the GitLab instance.  The metrics will be stored on disk in a markdown file and include job metrics for execution time, queue time, and concurrency.  We will look at each of these metrics in more depth later in this lab.

- [Prerequisites](#prerequisites)
- [Prepare for forecast](#prepare-for-forecast)
- [Perform a forecast](#perform-a-forecast)
- [Review forecast output](#review-forecast-output)

## Prerequisites

1. Followed [steps](../gitlab#readme) to set up your codespace environment.
2. Completed the [configure lab](../gitlab/valet-configure-lab.md)

## Prepare for forecast
Before we can run the forecast we need to answer a few questions so we can construct the correct command
1) What namespace do we want to run the forecast for?  __Valet__. This is the only group in the demo GitLab instance.
2) What is the date we want to start forecasting from?  __08-02-2022__. This is around but before the time the data was populated on our demo GitLab instance.
3) Where do we want to store the results? __./tmp/forecast__. This can be any valid path on the system, but for simplicity it is recommend to use a directory in the root of the codespace workspace.

## Perform a forecast
### TBD



## Review forecast output
### TBD
