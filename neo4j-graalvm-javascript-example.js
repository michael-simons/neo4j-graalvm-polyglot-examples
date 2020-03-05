// Alternative way to add Java libraries to GraalVM from JavaScript
Java.addToClasspath("lib/reactive-streams-1.0.2.jar")
Java.addToClasspath("lib/neo4j-java-driver-4.0.0.jar")

// This brings in the required classes
const GraphDatabase = Java.type('org.neo4j.driver.GraphDatabase')
const AuthTokens = Java.type('org.neo4j.driver.AuthTokens')
const Config = Java.type('org.neo4j.driver.Config')

// This is a call to the static factory method named `driver`
const driver = GraphDatabase.driver('bolt://localhost:7687', AuthTokens.basic('neo4j', 'secret'), Config.defaultConfig())

function findConnections(driver) {
    const query = `
        MATCH (:Person {name:$name})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActor) 
        RETURN DISTINCT coActor
    `

    const session = driver.session()
    // The JavaScript map is automatically converted to a Java Map 
    const records = session.run(query, {name: 'Tom Hanks'}).list()

    const coActors = Java.from(records).map(r => r.get('coActor').get('name').asString())
    session.close()
    return coActors
}

const results = findConnections(driver)

results.forEach(r => console.log(r))

driver.close()
