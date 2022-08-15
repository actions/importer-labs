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
2. Follow all steps [here](../jenkins#valet-configure-lab) to configure Valet.

## Perform an audit

We will be performing an audit against a preconfigured Jenkins instance. Before running the command we need to collect some information:

  1. Do we want to audit the entire Jenkins instance, or just a single folder? __In this example we will be auditing the entire Jenkins instance, but in the future if you wanted to configure a specific folder to be audited add the `-f <folder_path>` flag to the audit command__
  2. Where do we want to store the result? __./tmp/audit.  This can be any valid path on the system.  In the case of codespaces it is generally best to use `./tmp/SOME_DIRECTORY_HERE` so the files show in explorer__

### Steps

1. Navigate to the codespace terminal.
2. Now, from root dirrectory, run the following Valet audit command:
  
```
gh valet audit jenkins --output-dir tmp/audit
```

3. Valet displays green log files to indicate a successful audit  

### Example

<img src="https://user-images.githubusercontent.com/19557880/184682347-b19760fa-36a6-423e-a445-bb30eda5ac59.png" alt="valet-audit-1"/>

## View audit output

The audit summary, logs, config files, jenkinsfiles, and transformed Actions Workflows should all be located within the `tmp/audit` folder.

1. Under the `audit` folder find the `audit_summary.md`
2. Right-click the `audit_summary.md` file and select `Open Preview`
3. The file contains details about your current pipelines and what can be migrated 100% automatically vs. what will need some manual intervention or aren't supported by GitHub Actions.
4. Review the file, it should look like the image below:

### Example

<img src="https://user-images.githubusercontent.com/19557880/184682836-3b8155ae-f302-491e-8ce6-27cc57f96468.png" alt="valet-audit-2"/>

## Review the pipelines

### Pipelines

The audit summary starts by giving a summary of the types of pipelines that were extracted from Jenkins.

- It shows that there are a total of 7 pipelines extracted.

- 42% pipelines were successful. This means that Valet knew how to map all the constructs of the Jenkins pipeline to a GitHub Actions equivalent. All of the build pluggins and triggers that are referenced were all successfully converted into a GitHub Actions equivalent.

- 42% pipelines were partially successful. This means that Valet knew how to map all the constructs of the Jenkins pipeline but there may be a plugin that was referenced that Valet wasn't able to automatically map to a Github Actions equivalent.

- 1% of these pipelines were unsupported. This means that the pipeline type is fundamentally unsupported by Valet. This is most likely a Jenkins scripted pipeline.

- 0% of these fail altogether. If there were any pipelines that would fall under this category, that would mean that those pipelines were misconfigured or there was an issue with Valet.

Under the `Job types` section, we can see that the `audit` command is able to support the conversion of project, freestyle (flow-defintion), and multibranch pipelines from Jenkins and convert them to a GitHub Actions workflow. Valet does not support converting [scripted pipelines](https://www.jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline) (e.g. pure Groovy).

#### Example

<img src="https://user-images.githubusercontent.com/19557880/184683664-81985baf-5c03-4765-a067-f4023416e3ea.png" alt="valet-audit-3"/>

### Build steps

Under the `Build steps` section we can see a breakdown of the build steps that were used in these pipelines.

- <b>Supported:</b> 12/16 discrete build steps are considered known by Valet. When Valet encounters a build step of this type, it knows exactly how to map that into a GitHub Actions equivalent.
- <b>Unknown:</b> 2/16 discrete build steps are considered unknown by Valet. When Valet enounters a build step of this type, it does not yet know to map this automatically to a GitHub Action equivalent.
- <b>Unsupported:</b> 1/16 discrete build steps are considered unsupported by Valet. This could mean one of three things:
    1. The way that plugin was configured for a given job is unsupported.
    2. The plugin itself is fundamentally not supported in GitHub Actions.
    3. It's supported by default in GitHub Actions.

Under the `Actions` section we have the list of the Actions that were used in order to implement the transformation of all of these build steps. Valet is a planning tool that can help in facilitating the migration into GitHub Actions and this list of Actions is a great place to understand what dependencies you would be taking on third-party Actions after this migration.

For example, if you are doing things like setting up the allow list of third-party Actions in a GitHub Enterprise server instance this list of Actions is a fantastic place to begin security reviews and audits of what third-party actions to depend on.

#### Example

<img src="https://user-images.githubusercontent.com/19557880/184684062-69ab0bde-5e32-45f8-a7dd-ed4655872975.png" alt="valet-audit-4"/>

### Trigger, Environment, Other

Similar to `Build steps`, there are `Trigger`, `Environment`, and a catch all `Other` section that breakdown each of their uses accross the audited pipelines.

### Example

<img src="https://user-images.githubusercontent.com/19557880/184684174-43caff58-6083-45e1-a36e-6899d99c136b.png" alt="valet-audit-5" height="400"/>

### Manual Tasks

Under the Manual task section you will find a list of all the manual tasks that the pipelines would surface in a migration. Manual tasks are Valet's way of indicating tasks a user needs to do in order for a pipeline to be functional, such as adding `secrets`, or setting up a `self-hosted` runner. We will see how these manual tasks appear on a pull request when we do a migration in a lab later on.

### Example

<img src="https://user-images.githubusercontent.com/19557880/184684249-9accfd94-c2df-4891-af56-dcff66beb557.png" alt="valet-audit-5" height="400"/>

### Files

At the end of the Audit Summary page you will find a list of all of the files that were written to disk. Generally, for any given pipeline, you’ll find 2 or 3 associated files. In these files are the actual converted GitHub Actions workflows.

In addition, you’ll see a file that shows the raw JSON data that we pull from Jenkins as well as any associated Jenkinsfiles for a given job. These files are really useful for engineering teams to help debug any issues and to understand what may have gone on in a transformation.

#### Example

<img src="https://user-images.githubusercontent.com/19557880/184684416-b3db774e-4ab8-46e0-91ad-e503632df5cb.png" alt="valet-audit-6" height="400"/>

### Next Lab

[Dry run the migration of a Jenkins pipeline to GitHub Actions](valet-dry-run-lab.md)
