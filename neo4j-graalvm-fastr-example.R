# Download dependencies beforehand via the provided gradle task (see README.md)

# Open up a connection
graphDatabase <- java.type('org.neo4j.driver.GraphDatabase')
authTokens <- java.type('org.neo4j.driver.AuthTokens')
config <- java.type('org.neo4j.driver.Config')
driver <- graphDatabase$driver('bolt://localhost:7687', authTokens$basic('neo4j', 'secret'), config$defaultConfig())

findConnections <- function (driver) {
    
    query <- '
        MATCH (tom:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActor),
              (coActor)-[:ACTED_IN]->(m2)<-[:ACTED_IN]-(cruise:Person {name:"Tom Cruise"})
        RETURN DISTINCT coActor
    '

    session <- driver$session()
    coActorsRecords <- session$run(query)$list()

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