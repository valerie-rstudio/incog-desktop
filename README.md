Here's how to work with the docs in this folder:

1. [Install Quarto](https://quarto.org/docs/getting-started/installation.html). 
    * Download the CLI [here](https://github.com/quarto-dev/quarto-cli/releases/latest)
    * Install the Quarto R Package with `install.packages("quarto")`
2. Clone [rstudio-pro](https://github.com/rstudio/rstudio-pro)
3. Open up `rstudio-pro/docs/desktop` in your favorite IDE. 
    * There is an Rproj file in `rstudio-pro/docs/desktop`. Also, the daily build of RStudio has nice support for developing in Quarto.
4. Serve the project. 
    * From RStudio, enter `quarto::quarto_serve()`
    * From the command line, `quarto serve` from within the `rstudio-pro/docs/desktop` directory

This will serve the site to your web browser. Quarto will detect when you make changes to any of the `qmd` files and rerender that page. 
An exception to this is if the page contains code - Quarto will not rerender this during `quarto serve`. 
You need to render it manually with `quarto render file_name.qmd` (on the command line) or `quarto_render("file_name.qmd")` (in R). 
Note that you **do not** need to stop the server while doing this.

After making your changes, it is recommended that you [test the build locally](#test-local) and visually inspect the results (either in the `_site` directory or the resulting `rstudio-desktop-pro*zip` folder) to make sure that your changes will show up in the final site. Additionally, if you've made changes that could impact the build process, it is also recommended you [test against the build server](#test-build-server).

## <a id="test-local"></a>Testing the build locally

In order to test that the Jenkinsfile build works properly, do the following.

### <a id="generate"></a> Generate \_quarto.yml and \_variables.yml

```
cd docs/server
docker build --tag rstudio/docs .
docker run -it --mount type=bind,source="$(pwd)",target=/app rstudio/docs bash

cmake -E env RSTUDIO_BUILD_TYPE=TESTING RSTUDIO_VERSION_MAJOR=2021-08 RSTUDIO_VERSION_MINOR=0 RSTUDIO_VERSION_PATCH=291 RSTUDIO_VERSION_SUFFIX=420 cmake .
```
Note that the `cmake` command needs to be run in the `docs/desktop` folder.

This command populates the version number that appears in the final docs. 
Feel free to change the various `RSTUDIO_*` variables.
The final version number will be made from these variables and will show up in `_variables.yml` and `_quarto.yml`.

### <a id="local-run"></a>Run the build

Afterwards, exit the container, reenter the container from the project root directory, and `cd` back to the Quarto docs directory before running `make` to mimic the build pipeline on Jenkins: 

```
## Exit container & cd to root directory in order to test build in proper directory
cd ../..
docker run -it --mount type=bind,source="$(pwd)",target=/app rstudio/docs bash
cd app/docs/server
make
```

## <a id="test-build-server"></a>Testing against the build server

You can run `pro-docs-pipeline` against your branch by going to the [Jenkins Dashboard](https://build.rstudioservices.com/job/IDE/job/pro-docs-pipeline/build?delay=0sec) and putting the name of your branch in the `branch_name` field (and the `git_revision` build to be safe)
