# Forecast potential build runner usage

In this lab you will use the `forecast` command to forecast potential GitHub Actions usage by computing metrics from completed pipeline runs in your Azure DevOps project.

## Prerequisites

1. Followed the steps [here](./readme.md#configure-your-codespace) to set up your GitHub Codespaces environment and bootstrap an Azure DevOps project.
2. Completed the [configure lab](./1-configure.md#configuring-credentials).

## Perform a forecast

Answer the following questions before running the `forecast` command:

1. What is the Azure DevOps organization name that you want to audit?
    - __:organization__. This should be the same organization used in the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization)

2. What is the Azure DevOps project name that you want to audit?
    - __:project__. This should be the same project name used in the setup steps [here](./readme.md#bootstrap-your-azure-devops-organization)

3. Where do you want to store the results?
    - `tmp/forecast`

### Steps

1. Navigate to the codespace terminal.
2. Run the following command from the root directory:

    ```bash
    gh actions-importer forecast azure-devops --output-dir tmp/forecast
    ```

    __Note__: The Azure DevOps organization and project name can be omitted from the `forecast` command because they were persisted in the `.env.local` file in the [configure lab](./1-configure.md). You can optionally provide these arguments on the command line with the `--azure-devops-organization` and `--azure-devops-project` CLI options.

3. The command will output a message that says "No jobs found" because no jobs have been executed in your bootstrapped project.

    ```console
    $ gh actions-importer forecast azure-devops --output-dir tmp/forecast
    [2022-08-20 22:08:20] Logs: 'tmp/forecast/log/actions-importer-20220916-021004.log'
    [2022-08-20 22:08:20] Forecasting 'http://dev.azure.com/mona/actions-bootstrap/_build'
    [2022-08-20 22:08:20] No jobs found
    ```

4. If you inspect the help menu using the `gh actions-importer azure-devops forecast --help` command, you will see a `--source-file-path` option. You can use this option to perform a `forecast` using json files that are already present on the filesystem. These labs come bundled with sample json files located [here](./bootstrap/jobs.json).

    ```console
    $ gh actions-importer forecast azure-devops -h
    Options:
      -g, --azure-devops-organization <azure-devops-organization>  The Azure DevOps organization name.
      -p, --azure-devops-project <azure-devops-project>            The Azure DevOps project name.
      -u, --azure-devops-instance-url <azure-devops-instance-url>  The URL of the Azure DevOps instance.
      -t, --azure-devops-access-token <azure-devops-access-token>  Access token for the Azure DevOps instance.
      --source-file-path <source-file-path>                        The file path(s) to existing jobs data.
      -o, --output-dir <output-dir> (REQUIRED)                     The location for any output files.
      --start-date <start-date>                                    The start date of the forecast analysis in YYYY-MM-DD format. [default:
                                                                   10/31/2022 8:35:17 AM]
      --time-slice <time-slice>                                    The time slice in seconds to use for computing concurrency metrics.
                                                                   [default: 60]
      --credentials-file <credentials-file>                        The file containing the credentials to use.
      --no-telemetry                                               Boolean value to disallow telemetry.
      --no-ssl-verify                                              Disable ssl certificate verification.
      --no-http-cache                                              Disable caching of http responses.
      -?, -h, --help                                               Show help and usage information
    ```

5. Run the following `forecast` command while specifying the path to the sample json files:

    ```bash
    gh actions-importer forecast azure-devops --output-dir tmp/forecast --source-file-path azure_devops/bootstrap/jobs.json
    ```

6. The command will list all the files written to disk when the command succeeds.

    ```console
    $ gh actions-importer forecast azure-devops --output-dir tmp/forecast --source-file-path azure_devops/bootstrap/jobs.json
    [2022-08-20 22:08:20] Logs: 'tmp/forecast/log/actions-importer-20220916-021004.log'
    [2022-08-20 22:08:20] Forecasting 'http://dev.azure.com/mona/actions-bootstrap/_build'
    [2022-08-20 22:08:20] Outfile file(s):
    [2022-08-20 22:08:20]   ./tmp/forecast/forecast_report.md
    ```

## Review the forecast report

The forecast report, logs, and completed job data will be located within the `tmp/forecast` folder.

1. Find the `forecast_report.md` file in the file explorer.
2. Right-click the `forecast_report.md` file and select `Open Preview`.
3. This file contains metrics used to forecast potential GitHub Actions usage.

### Total

The `Total` section of the forecast report contains high level statistics related to all the jobs completed after the `--start-date` CLI option:

```md
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
```

Here are some key terms of items defined in the forecast report:

- The `Job count` is the total number of completed jobs.
- The `Pipeline count` is the number of unique pipelines used.
- `Execution time` describes the amount of time a runner spent on a job. This metric can be used to help plan for the cost of GitHub hosted runners.
  - This metric is correlated to how much you should expect to spend in GitHub Actions. This will vary depending on the hardware used for these minutes. You can use the [Actions pricing calculator](https://github.com/pricing/calculator) to estimate a dollar amount.
- `Queue time` metrics describe the amount of time a job spent waiting for a runner to be available to execute it.
- `Concurrent jobs` metrics describe the amount of jobs running at any given time. This metric can be used to define the number of runners a customer should configure.

Additionally, these metrics are defined for each queue of runners defined in Azure DevOps. This is especially useful if there are a mix of hosted/self-hosted runners or high/low spec machines to see metrics specific to different types of runners.

## Next steps

[Perform a dry-run migration of an Azure DevOps pipeline](4-dry-run.md)
