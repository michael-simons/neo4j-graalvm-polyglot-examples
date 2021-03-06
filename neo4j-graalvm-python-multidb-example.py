import java

# This brings in the required classes
graphDatabase = java.type('org.neo4j.driver.GraphDatabase')
authTokens = java.type('org.neo4j.driver.AuthTokens')
config = java.type('org.neo4j.driver.Config')
sessionConfig = java.type('org.neo4j.driver.SessionConfig')

# This is a call to the static factory method named `driver`
driver = graphDatabase.driver(
    'bolt://localhost:7687', 
    authTokens.basic('neo4j', 'secret'), 
    config.builder()
        .withMaxConnectionPoolSize(1) # Don't need a bigger pool size for a script
        # .withEncryption() # Uncomment this if you want to connect against https://neo4j.com/aura/
        .build()
)

# Python dicts are not (yet?) automatically converted to Java maps, so we need to use Neo4j's Values for building parameters
values = java.type('org.neo4j.driver.Values')

def findConnections(driver):
    query = """
        MATCH (:Person {name:$name})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActor) 
        RETURN DISTINCT coActor
    """

    session = driver.session(sessionConfig.forDatabase("movies"))
    records = session.run(query, values.parameters("name", "Tom Hanks")).list()

    coActors = [r.get('coActor').get('name').asString() for r in records]
    
    session.close()
    return coActors

results = findConnections(driver)

for name in results: 
    print(name)

driver.close()
