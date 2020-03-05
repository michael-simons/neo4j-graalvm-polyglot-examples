# Add the necessary dependencies
# Download them beforehand via the provided gradle task (see README.md)
# truffleruby --jvm neo4j-graalvm-ruby-example.rb \ 
# --vm.cp=lib/neo4j-java-driver-4.0.0.jar:lib/reactive-streams-1.0.2.jar

#Java.add_to_classpath("lib/reactive-streams-1.0.2.jar")
#Java.add_to_classpath("lib/neo4j-java-driver-4.0.0.jar")

# Open up a connection
graphDatabase = Java.type('org.neo4j.driver.GraphDatabase')
authTokens = Java.type('org.neo4j.driver.AuthTokens')
config = Java.type('org.neo4j.driver.Config')
driver = graphDatabase.driver('bolt://localhost:7687', authTokens.basic('neo4j', 'secret'), config.defaultConfig())

def findConnections(driver)
    query = "MATCH (:Person {name:$name})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActor) RETURN DISTINCT coActor"
    
    session = driver.session()
    records = session.run(query, {:name=>"Tom Hanks"}).list()
    records = Polyglot.as_enumerable(records)

    coActors = records.collect{ |r| r.get('coActor').get('name').asString() }   
    session.close()
    coActors
end

results = findConnections(driver)

results.each { |name| puts name }

driver.close()
