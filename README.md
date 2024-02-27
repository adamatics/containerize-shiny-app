# Containerize and deploy Shiny app
This repository contains a file that defines an R Shiny app (`app.R`) and a Containerfile (`containerfile`) 
that specifies the build steps to build a container image for the R Shiny app.

For the videos to play, view this README.md on GitHub ([https://github.com/adamatics/containerize-shiny-app/](https://github.com/adamatics/containerize-shiny-app/)).

In the following sections, we list the steps required to deploy an R Shiny app as a containerized stand-alone 
app on [AdaLab](https://adamatics.com/index.php/platform-2/).

## Build the container image
First, open a terminal and make sure that the directory you are in is the folder that the repository was cloned into. 
To check you are in the correct directory, run the `pwd` command in the terminal. This will print your current
working directory. Check that the printed path is the folder name that you chose for the project. If the 
`docker build` command described below is run from the home directory, the build process will include the entire 
home directory, including files that require root permissions, which will in turn cause the build process to fail.

After having checked that you are in the correct location in the terminal with the `pwd` command, 
build the container image with the below command:

```docker build . -t containerized_shiny:1.0.0 -f containerfile```

The argument `-t containerized_shiny:1.0.0` specifies the name and tag to use for the built container image, 
and you can specify it as you wish. If you do not specify a tag (i.e. the part after the colon), the tag will be set to
'latest' automatically. If a tag called 'latest' already exists, the existing one will be overwritten by the new 
container image. The only requirement to the name (the part before the colon following the '-t' ), is that a container 
image with this name does not 
already exist in your local Lab, as this will cause an error, and that the name 
follows the [Open Container Initiative (OCI) naming convention](https://github.com/containers/image/blob/main/docker/reference/regexp.go). The build process will look as shown below if 
you have built this image before. Otherwise, there will be some more steps in which the various components are 
downloaded to your Lab.

[build_shiny_app_image.webm](https://github.com/adamatics/containerize-shiny-app/assets/149479200/f843be3d-ea55-4fd4-b55b-873fe248cc67)

### The containerfile
When building a container image, each build command (such as `FROM`, `LABEL`, `RUN`, `WORKDIR`, `COPY`, `USER`, 
`EXPOSE`, and `CMD`) defines what is referred to as a 'layer'. When building a container image, the built layers 
are saved in a cache folder (found in `~/.containers-cache` on Ubuntu systems, which e.g. 
[AdaLab](https://adamatics.com/index.php/platform/) runs on). This enables the build process to reuse previously built
layers if their definition is the same as that used in the original build, speeding up the build process. Since 
layers further down in the containerfile depend on previous layers, all layers after a modified layer will 
be rebuilt, and the cache cannot be used for these. For this reason, the order of layers in the containerfile 
should be in 
the order of least changing to most changing to be able to use the cache to the greatest extent possible, speeding up 
the build process.

#### The R version
In the example containerfile supplied in this repo, an image from the [Rocker Project](https://rocker-project.org/) 
is used as the base image. Available container image versions from this project can be found at 
[https://github.com/rocker-org/devcontainer-images/wiki](https://github.com/rocker-org/devcontainer-images/wiki).

### File system in container image
The set of files that the build process can access is referred to as the 
['build context'](https://docs.docker.com/build/building/context/). In the build command given above, the build 
context is defined as the current directory by the punctuation mark (`.`). This implies that the build process will 
use the current directory to look for the containerfile (as specified by the optional argument `-f`). It also means 
that the build process will have access to all folders and subfolders of the current directory during the build. 
However, only files and folders copied over to the container image during the build, e.g. with the commands `COPY` and 
`ADD`, will be available in the final, built container image.

### Check the container image
The built container image can be explored using the 
[`docker run`](https://docs.docker.com/reference/cli/docker/container/run/) command from the terminal using the 
optional arguments `--interactive` and `--entrypoint`, specifying a shell command as entrypoint, e.g. `sh` or 
`/bin/bash`. So, if the container image to be explored from a shell is called my_container_image, the command would be 
`docker run --interactive --entrypoint /bin/bash my_container_image`.

The [`docker --inspect`](https://docs.docker.com/reference/cli/docker/inspect/) command can also be used to view 
detailed information on a container image. 

### Secrets
Since a final container image is composed of all built layers, any information added to any layer will be findable 
in the built container image. Thus, even if a secret value is added in one layer and then removed in a later layer, 
the secret will still be retrievable since the layer in which it was added is part of the final container image. Thus, 
secrets should not be used in containerfiles. 

To use secrets in the container image build process, consider using the
[`--secret` argument](https://docs.docker.com/build/building/secrets/).

## Add metadata
Once the image building process is complete, you will have the container image available in your Lab on the 
AdaLab platform. One way to view the container image file is with this command in a terminal, which can be executed 
from any location:

```docker images```

The next step is to add metadata to the container image, making it easier to find and manage. 
This also pushes the container image to a central storage location, making the app available for other users. 
You do this by heading to the Container Metadata page, as shown below:

[add-metadata.webm](https://github.com/adamatics/containerize-shiny-app/assets/149479200/c9844b90-35b2-4cf3-8a1f-e0a96c5d65fc)

## Deploy
Once the metadata publishing process is complete, an action to deploy the container image as an app will be available 
in the triple dot menu. The status indicator square at the top of the logs window will turn green when the 
publishing process has finished. You can then click the "Deploy app" action and fill out the fields in the dialog box. 
The next step is to click the "Deploy App" button in the dialog box, which will start the deployment process and take 
you to the App Deployment overview page. The app will be available on the URL you specified immediately or after a 
short wait. As before, there are live logs available that allow you to follow the deployment process. Click the 
triple dot menu in the App Deployment page to view these logs. The process is shown below:

[deploy.webm](https://github.com/adamatics/containerize-shiny-app/assets/149479200/c3d2ea82-b8f3-4329-8d42-5a50603bdaea)

If you are following these steps to deploy a custom app (i.e. another .R file than the app.R file in this repository),
and the app deployment fails with the logs showing errors mentioning missing write permissions, check if your .R file 
defining your app is trying to install packages. To ensure that your app will continue to work as expected, it is 
best practice to install necessary packages in the containerfile. If packages are installed in the .R file, i.e. at 
runtime, the packages will be installed every time the app is started. This implies a longer start-up time, but, more 
importantly, it also implies the risk of new package versions being installed, that might not be compatible with the 
app code and other packages.

# References
The app.R file was copied from the repository https://github.com/ShinyEd/intro-stats 
(the file is in the folder https://github.com/ShinyEd/intro-stats/tree/master/CLT_mean).
