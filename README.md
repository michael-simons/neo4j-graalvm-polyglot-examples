## Usage

Start a Neo4j Docker instance

```
docker run --publish=7474:7474 --publish=7687:7687 -e 'NEO4J_AUTH=neo4j/secret' neo4j:4.0.1
```

## Installing GraalVM

Download the JDK 11 version for your operating system from
https://github.com/oracle/graal/releases

All community downloads are available on
https://github.com/graalvm/graalvm-ce-builds/releases

Here we used version 20.0.0

Follow the install instructions

Install the different languages (javascript is already bundled) using `gu` the graal updater:

- R,
- ruby,
- python

```
export GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-java11-20.0.0/Contents/Home
$GRAALVM_HOME/bin/gu install R python ruby

# List the installed versions
$GRAALVM_HOME/bin/gu list
```  

Be sure to check the FastR requirements: https://www.graalvm.org/docs/reference-manual/languages/r/

If stuff fails, there's a GraalVM tool helping you troubleshot:

```
$GRAALVM_HOME/languages/R/bin/configure_fastr
```

### SDKMAN

You can also install GraalVM using sdkman.io which automatically sets up the PATH and JAVA_HOME, making the whole process much easier.

```
sdk install java 20.0.0.r11-grl
gu install ruby R python
gu list
```

## Download Neo4j Driver

Download the required Neo4j 4.0 driver dependencies via the provided Gradle script:

```
./gradlew downloadDependencies
```

or on Windows 

```
gradlew.bat downloadDependencies
```

## Run Examples

All examples follow the same pattern:
Open up a connection, execute a query with a parameter, collect the results.
They include as first instructions an alternative method to the required Neo4j dependencies loaded.
This works through the GraalVM interoperability API.

We decided it would feel more natural not to do this and instead specify the two required jars on the GraalVM classpath with the `--vm.cp` argument as shown below.

All examples answer the question which actors acted with Tom Hanks in the same movie.

```
export CLASSPATH=./lib/neo4j-java-driver-4.0.0.jar:./lib/reactive-streams-1.0.2.jar

# R
$GRAALVM_HOME/bin/Rscript --jvm --vm.cp=$CLASSPATH neo4j-graalvm-fastr-example.R

# Javascript
$GRAALVM_HOME/bin/node --jvm --vm.cp=$CLASSPATH neo4j-graalvm-javascript-example.js

# Python
$GRAALVM_HOME/bin/graalpython --jvm --vm.cp=$CLASSPATH neo4j-graalvm-python-example.py

# Ruby
$GRAALVM_HOME/bin/truffleruby --jvm --vm.cp=$CLASSPATH neo4j-graalvm-ruby-example.rb
```

The examples also exists with `multidb` in their name.
They are identical, but make use of Neo4j 4.0 multi database feature.
As this is only available in the enterprise edition of Neo4j, you need to use a different docker image to start your instance:

```
docker run --publish=7474:7474 --publish=7687:7687 -e 'NEO4J_AUTH=neo4j/secret'  --env=NEO4J_ACCEPT_LICENSE_AGREEMENT=yes neo4j:4.0.1-enterprise                   
```

The `ee` examples run against a database called `movies`.

If you use Neo4j desktop, the enterprise edition is included.