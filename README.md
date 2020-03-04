## Build and run

Start a Neo4j Docker instance

```
docker run --publish=7474:7474 --publish=7687:7687 -e 'NEO4J_AUTH=neo4j/secret' -e NEO4J_ACCEPT_LICENSE_AGREEMENT=yes neo4j:4.0.1
```

Goto 

https://github.com/oracle/graal/releases

Download the JDK 11 version for your operating system 
https://github.com/graalvm/graalvm-ce-builds/releases/tag/vm-20.0.0

Follow their instructions to install

Install `R`

```
export GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-java11-20.0.0/Contents/Home 
$GRAALVM_HOME/bin/gu install R
```  

And while you are at it, you can install the native image tool as well:

```
$GRAALVM_HOME/bin/gu install native-image
```

Be sure to check the FastR requirements: https://www.graalvm.org/docs/reference-manual/languages/r/


Download the required Neo4j driver dependencies via the provided Gradle script:

```
./gradlew downloadDependencies
```

or 

```
gradlew.bat downloadDependencies
```

on windows

Run the script with:

```
$GRAALVM_HOME/bin/Rscript --jvm neo4-graalvm-fastr-example.R 
```

If stuff fails, there's a GraalVM tool helping you troubleshot:

```
$GRAALVM_HOME/languages/R/bin/configure_fastr
```
