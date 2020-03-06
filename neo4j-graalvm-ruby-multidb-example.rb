# This brings in the required classes
graphDatabase = Java.type('org.neo4j.driver.GraphDatabase')
authTokens = Java.type('org.neo4j.driver.AuthTokens')
config = Java.type('org.neo4j.driver.Config')

# This is a call to the static factory method named `driver`
driver = graphDatabase.driver(
  'bolt://localhost:7687',
  authTokens.basic('neo4j', 'secret'),
  config.builder()
      .withMaxConnectionPoolSize(1) # Don't need a bigger pool size for a script
      .build()
      # .withEncryption().build() # Uncomment this if you want to connect against https://neo4j.com/aura/
)

def findConnections(driver)
    query = <<-CYPHER
      MATCH (:Person {name:$name})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActor)
      RETURN DISTINCT coActor
    CYPHER

    sessionConfig = Java.type('org.neo4j.driver.SessionConfig')
    session = driver.session(sessionConfig.forDatabase("movies"))
    records = session.run(query, {:name=>"Tom Hanks"}).list()
    records = Polyglot.as_enumerable(records)

    coActors = records.collect{ |r| r.get('coActor').get('name').asString() }
    session.close()
    coActors
end

results = findConnections(driver)

results.each { |name| puts name }

driver.close()
