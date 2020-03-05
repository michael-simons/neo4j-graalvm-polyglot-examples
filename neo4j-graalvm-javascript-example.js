/*
 Download the jars beforehand via the provided gradle task (see README.md)
 node OR js --jvm --vm.cp=lib/neo4j-java-driver-4.0.0.jar:lib/reactive-streams-1.0.2.jar neo4j-graalvm-javascript-example.js 
*/

// Open up a connection
const GraphDatabase = Java.type('org.neo4j.driver.GraphDatabase')
const AuthTokens = Java.type('org.neo4j.driver.AuthTokens')
const Config = Java.type('org.neo4j.driver.Config')
const driver = GraphDatabase.driver('bolt://localhost:7687', AuthTokens.basic('neo4j', 'secret'), Config.defaultConfig())

function findConnections(driver) {
    const query=`
        MATCH (:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActor)
        RETURN DISTINCT coActor
    `

    const session = driver.session()
    const records = session.run(query).list()

    const coActors = Java.from(records).map(r => r.get('coActor').get('name').asString())
    session.close()
    return coActors
}

const results = findConnections(driver)

results.forEach(r => console.log(r))

driver.close()
