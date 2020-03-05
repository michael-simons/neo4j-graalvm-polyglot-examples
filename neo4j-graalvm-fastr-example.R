# Alternative way to add Java libraries to GraalVM from R
# java.addToClasspath("lib/reactive-streams-1.0.2.jar")
# java.addToClasspath("lib/neo4j-java-driver-4.0.0.jar")

# This brings in the required classes
graphDatabase <- java.type('org.neo4j.driver.GraphDatabase')
authTokens <- java.type('org.neo4j.driver.AuthTokens')
config <- java.type('org.neo4j.driver.Config')

# This is a call to the static factory method named `driver`
driver <- graphDatabase$driver('bolt://localhost:7687', authTokens$basic('neo4j', 'secret'), config$defaultConfig())

findConnections <- function (driver) {
    
    query <- '
        MATCH (:Person {name:$name})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActor) 
        RETURN DISTINCT coActor
    '

    session <- driver$session()
    # The R list (which behaves like an associative array) is automatically converted to a Java Map 
    coActorsRecords <- session$run(query, list(name="Tom Hanks"))$list()

    coActors <- list()
    i <- 1
    for (record in coActorsRecords) {
        coActors[[i]] <- record$get('coActor')$get('name')$asString()
        i <- i + 1
    }
    
    session$close()
    return(coActors)
}

connections <- findConnections(driver)

for(connection in connections) {
    print(connection)
}


driver$close()