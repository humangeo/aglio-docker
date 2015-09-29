# Example App: docker-maven-plugin + aglio-docker

This project provides an example of using the [docker-maven-plugin](https://github.com/rhuss/docker-maven-plugin) to generated documentation with Aglio.


## Running the demo

To generate the docs:

	$ cd my_app
	$ mvn clean process-resources

This will convert `docs/my_rest_api.md` to `my_app/target/classes/html/my_rest_api.html`.