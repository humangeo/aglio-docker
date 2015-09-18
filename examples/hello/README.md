# hello (docker-maven-plugin & aglio-docker demo)

This project provides an example of using the [docker-maven-plugin](https://github.com/rhuss/docker-maven-plugin) to generated documentation with Aglio.


## Running the demo

To generate the docs:

    $ mvn clean package

This will create the documentation for the fictional "hello" service in `target/html/index.html`
