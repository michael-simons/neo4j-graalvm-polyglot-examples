// This brings in the required classes
const GraphDatabase = Java.type('org.neo4j.driver.GraphDatabase')
const AuthTokens = Java.type('org.neo4j.driver.AuthTokens')
const Config = Java.type('org.neo4j.driver.Config')
const SessionConfig = Java.type('org.neo4j.driver.SessionConfig')

// This is a call to the static factory method named `driver`
const driver = GraphDatabase.driver(
    'bolt://localhost:7687',
    AuthTokens.basic('neo4j', 'secret'),
    Config.builder()
        .withMaxConnectionPoolSize(1) // Don't need a bigger pool size for a script
        // .withEncryption() // Uncomment this if you want to connect against https://neo4j.com/aura/
        .build()
)

function findConnections(driver) {
    const query = `
        MATCH (:Person {name:$name})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActor)
        RETURN DISTINCT coActor
    `

    const session = driver.session(SessionConfig.forDatabase("movies"))
    // The JavaScript map is automatically converted to a Java Map
    const records = session.run(query, {name: 'Tom Hanks'}).list()

    const coActors = Java.from(records).map(r => r.get('coActor').get('name').asString())
    session.close()
    return coActors
}

const results = findConnections(driver)

results.forEach(r => console.log(r))

driver.close()
