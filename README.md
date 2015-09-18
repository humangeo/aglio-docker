# aglio-docker

[Aglio](https://github.com/danielgtaylor/aglio) installed in a Docker container.

This image can be used to run [Blueprint API](https://apiblueprint.org/)
formatted documentation through Aglio.


## Usage

There are several ways you can use this image to run Aglio. In all cases you
will need to mount a directory from your host system to the container so that
Aglio can see the files that you are trying to process.


### Use Case #1: Running Aglio Directly

To run aglio with the current directory mounted to `/docs`:

    $ docker run -ti --rm -v .:/docs humangeo/aglio


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
