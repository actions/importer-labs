# Audit Jenkins pipelines using the Valet audit command

In this lab, you will use Valet to `audit` a Jenkins organization. The `audit` command can be used to scan a CI server and output a summary of the current pipelines.

What happens behind the scenes is that Valet will perform a `dry-run` on each of the Jenkins pipelines.  Once that is complete, Valet will perform an aggregation of all of the transformed workflows. This aggregate summary can be used as a planning tool and help understand how complete of a migration is possible with Valet.

By the end of this lab you will have performed an audit on the demo Jenkins instance, and have a good understanding of the components that make up an audit.

- [Prerequisites](#prerequisites)
- [Perform an audit](#perform-an-audit)
- [View audit output](#view-audit-output)
- [Review the pipelines](#review-the-pipelines)
- [Next Lab](#next-lab)

## Prerequisites

1. Follow all steps [here](../jenkins#readme) to set up your environment.
2. Follow all steps [here](../jenkins#valet_configure_lab) to configure Valet.

## Perform an audit

We will be performing an audit against a preconfigured Jenkins instance. Before running the command we need to collect some information:

  1. Do we want to audit the entire Jenkins instance, or just a single folder? __In this example we will be auditing the entire Jenkins instance, but in the future if you wanted to  configure a specific folder to be audited add the `-f <folder_path> flag to the audit command__
  2. Where do we want to store the result? __./tmp/audit.  This can be any valid path on the system.  In the case of codespaces it is generally best to use `./tmp/SOME_DIRECTORY_HERE` so the files show in explorer__

### Steps

1. Navigate to the codespace terminal.
2. Now, from root dirrectory, run the following Valet audit command:
  
```
gh valet audit jenkins --output-dir tmp/audit
```

3. Valet displays green log files to indicate a successful audit  

### Example

![valet-audit-1](https://user-images.githubusercontent.com/19557880/184247823-77aa9fa0-da6a-48dc-b7a3-32e1a633045a.png)

## View audit output

The audit summary, logs, config files, jenkinsfiles, and transformed Actions Workflows should all be located within the `tmp/audit` folder.

1. Under the `audit` folder find the `audit_summary.md`
2. Right-click the `audit_summary.md` file and select `Open Preview`
3. The file contains details about your current pipelines and what can be migrated 100% automatically vs. what will need some manual intervention or aren't supported by GitHub Actions.
4. Review the file, it should like like the image below:

### Example

![valet-audit-2](https://user-images.githubusercontent.com/26442605/169615428-26f7a962-2064-46d0-8206-ea930109b252.png)

## Review the pipelines

### Pipelines

The audit summary starts by giving a summary of the types of pipelines that were extracted from Jenkins.

- It shows that there are a total of 4 pipelines extracted.

- 50% pipelines were successful. This means that Valet knew how to map all the constructs of the Jenkins pipeline to a GitHub Actions equivalent. All of the build pluggins and triggers that are referenced were all successfully converted into a GitHub Actions equivalent.

- 50% pipelines were partially successful. This means that Valet knew how to map all the constructs of the Jenkins pipeline but there may be a plugin that was referenced that Valet wasn't able to automatically map to a Github Actions equivalent.

- 0% of these pipelines are unsupported. If there were any that would fall under this category, that would mean that those pipelines were using a pipeline type that is fundamentally not supported by Valet. If a Jenkins instance had any scripted pipelines they would appear here.

- 0% of these fail altogether. If there were any pipelines that would fall under this category, that would mean that those pipelines were misconfigured or there was an issue with Valet.

Under the `Job types` section, we can see that the `audit` command is able to support the conversion of project, freestyle (flow-defintion), and multibranch pipelines from Jenkins and convert them to a GitHub Actions workflow. Valet does not support converting [scripted pipelines](https://www.jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline) (e.g. pure Groovy).

#### Example

![valet-audit-3](https://user-images.githubusercontent.com/19557880/184190501-6bb2ad34-1680-404a-9cb5-93012a25e0c8.png)

### Build steps

Under the `Build steps` section we can see a breakdown of the build steps that were used in these pipelines.

- <b>Supported:</b> 7/9 discrete build steps are considered known by Valet. When Valet encounters a build step of this type, it knows exactly how to map that into a GitHub Actions equivalent.
- <b>Unknown:</b> 2/9 discrete build steps are considered unknown by Valet. When Valet enounters a build step of this type, it does not yet know to map this automatically to a GitHub Action equivalent.
- <b>Unsupported:</b> There are currently no build steps that are unsupported so this category is not shown. If there were it would mean one of three things:
    1. The way that plugin was configured for a given job is unsupported.
    2. The plugin itself is fundamentally not supported in GitHub Actions.
    3. It's supported by default in GitHub Actions.

Under the `Actions` section we have the list of the Actions that were used in order to implement the transformation of all of these build steps. Valet is a planning tool that can help in facilitating the migration into GitHub Actions and this list of Actions is a great place to understand what dependencies you would be taking on third-party Actions after this migration.

For example, if you are doing things like setting up the allow list of third-party Actions in a GitHub Enterprise server instance this list of Actions is a fantastic place to begin security reviews and audits of what third-party actions to depend on.

#### Example

![valet-audit-4](https://user-images.githubusercontent.com/19557880/184191935-c29c3121-66e2-4c33-a71e-07ad1ef42b5c.png)

### Trigger, Environment, Other

Similar to `Build steps`, there are `Trigger`, `Environment`, a and catch all `Other` section that breakdown each of their uses accross the audited pipelines.

### Example

![valet-audit-4](https://user-images.githubusercontent.com/19557880/184197153-8477c147-646b-4d05-8988-29ce4d28241f.png)

### Manual Tasks

Under the Manual task section you will find a list of all the manual tasks that the pipelines would surface in a migration. Manual tasks are a Valet construct that denote what `secrets` and `self-hosted` runners were referenced in the pipeline and will need to be migrated manually. We will see how these manual tasks appear on a pull request when we do a migration in a lab later on.

### Files

At the end of the Audit Summary page you will find a list of all of the files that were written to disk. Generally, for any given pipeline, you’ll find 2 or 3 associated files. In these files are the actual converted GitHub Actions workflows.

In addition, you’ll see a file that shows the raw JSON data that we pull from Jenkins as well as any associated Jenkinsfiles for a given job. These files are really useful for engineering teams to help debug any issues and to understand what may have gone on in a transformation.

#### Example

![valet-audit-5](https://user-images.githubusercontent.com/19557880/184228434-4b57f77b-db93-43d6-8b8d-4eebfc445160.png)

### Next Lab

[Dry run the migration of a Jenkins pipeline to GitHub Actions](valet-dry-run-lab.md)
