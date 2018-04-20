# aglio-docker

Use this image to run [aglio](https://github.com/danielgtaylor/aglio), a NodeJS
command-line tool that converts text files containing [Blueprint
API](https://apiblueprint.org/) markup to HTML files.

Why run aglio via Docker container instead of installing it "natively"?
Currently aglio only works with a fairly old version of NodeJS (see the GitHub
[issue](https://github.com/danielgtaylor/aglio/issues/172) for more info). By
using this image you are not forced to keep an old version of NodeJS on your
machine.


## Usage

There are several ways you can use this image to run Aglio. In all cases you
will need to mount a directory from your host system to the container so that
Aglio can see the files that you are trying to process.


### Use Case #1: Running Aglio Directly

To run aglio with the current directory mounted to `/docs`:

    $ docker run -ti --rm -v $PWD:/docs humangeo/aglio <path to your file>


### Use Case #2: Running Aglio From a Script

It may be easier to setup a script in your local environment to run Aglio,
rather than typing a long Docker command every time that you want to generate
docs:

* Create a script to launch Aglio

    Create a new script in `~/bin`:

        $ mkdir -p ~/bin
        $ touch ~/bin/aglio
        $ chmod +x ~/bin/aglio

    Add the following to `~/bin/aglio`:

        #!/bin/sh -eu
        script_dir=`pwd`
        container_dir=/docs

        docker run --rm -ti -v $script_dir:$container_dir humangeo/aglio "$@"


* Add the script to your path

    If you are using Bash, may need to add the following to your configuration
    (`~/.bashrc` or `~/.bash_profile`):

        # add local script to user's path
        if [ -d $HOME/bin ] then;
          export PATH=$HOME/bin:$PATH
        fi

* Generate your docs

        $ aglio <path to your file>


### Use Case #3: Running From Apache Maven

*aglio-docker* can be integrated into an Apache Maven build using the
[docker-maven-plugin](https://github.com/rhuss/docker-maven-plugin). This plugin
provides the means to pull/run a Docker container with a specific command.

> NOTE: The *docker-maven-plugin* plugin assumes that you have Docker installed
> and running on your host.

There is a Maven project in the `example` directory that demonstrates using the
*docker-maven-plugin* to generate HTML docs with Aglio.


### Processing all files in a directory

By default aglio only allows you to process one file at a time. However, this
image contains a custom "wrapper" shell script (`aglio-wrapper.sh`) which will
allow you to simply specify input and output directories; the wrapper script
will then call aglio on all `.md` files in the input directory and write HTML
files out using the same filename (but .html extension) to the output directory.

To use this wrapper script specify
`--entrypoint=/usr/local/bin/aglio-wrapper.sh`. Example:

```
docker run -ti -v /host/input_dir:/docker_in -v /host/output_dir:/docker_out --entrypoint=/usr/local/bin/aglio-wrapper.sh humangeo/aglio -i /docker_in -o /docker_out
```

> *NOTE*: Even though you use the same `-i` and `-o` options that you would with
> the regular `aglio` command, in this case you are calling `aglio-wrapper.sh`
> which is expecting the values of those options to be **directories** and not
> files.

Additionally, you can set the `-l` option to replace external assets with local
references (the `aglio-wrapper.sh` script will copy these assets into your
output directory).

If you have a markdown formated changelog, you wrap it with Aglio navigation
elements using the `-c` option. The file must be called `CHANGELOG` and it must
have a level one header. For example:

```md
# Example CHANGELOG

<aglio stuff goes here>

## 1.0.0
...
```
