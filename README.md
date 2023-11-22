# Containerize and deploy Shiny app
This repository contains a file that define an R Shiny app (`app.R`) and a Containerfile (`containerfile`) that specifies the build steps to build a container image for the R Shiny app.

In the following sections, we list the steps required to deploy an R Shiny app as a containerized stand-alone app on [AdaLab](https://adamatics.com/index.php/platform-2/).

## Build the container image
First, open a terminal and make sure that the directory you are in is the folder that the repository was cloned into. Then, from the terminal, build the container image with the below command:

```docker build . -t containerized_shiny:1.0.0 -f containerfile```

The argument `-t containerized_shiny:1.0.0` specifies the name and tag to use for the built container image, and you can specify it as you wish. The only requirement is that a container image with this name does not already exist on your local computer, as this will cause an error, and that the name follows the [Open Container Initiative (OCI) naming convention](https://github.com/containers/image/blob/main/docker/reference/regexp.go). The build process will look as shown below if you have built this image before. Otherwise, there will be some more steps in which the various components need to be downloaded to the local compute resource.

<video src="/assets/testvid.mov"></video> 
<video src="/assets/testvid.mp4"></video> 
<video src="/assets/testvid.webm"></video> 


![Alt Text](/assets/testvid.mp4)

<video autoplay loop muted playsinline>
  <source src="/assets/testvid.webm" type="video/webm">
  <source src="/assets/testvid.mp4" type="video/mp4">
</video>



[!(renamed webm)](/assets/testvid.mov)

<video><source src='/assets/testvid.mov'></video> 

<a href="/assets/testvid.mov" target="_blank">
    <img class="no-shadow" src="/assets/testvid.mov"  style="margin: 0px 5px 50px 0px; center;" width="1000px"/>
</a>



[!(renamed webm)](/assets/testvid.mp4)

<video><source src='/assets/testvid.mp4'></video> 

<a href="/assets/testvid.mp4" target="_blank">
    <img class="no-shadow" src="/assets/testvid.mp4"  style="margin: 0px 5px 50px 0px; center;" width="1000px"/>
</a>

## Add metadata
Once the image building process is complete, you will have the container image available in your Lab on the AdaLab platform. One ways to view the container image file is with this command in a terminal, which can be executed from any location:

```docker images```

The next step is to add metadata to the container image, making it easier to find and manage. This also pushes the container image to a central storage location, making the app available for other users. You do this by heading to the Container Metadata page, as shown below:
