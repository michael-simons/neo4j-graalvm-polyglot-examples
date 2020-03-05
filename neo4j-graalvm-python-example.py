# Add the necessary dependencies
# Download them beforehand via the provided gradle task (see README.md)
# graalpython --jvm neo4j-graalvm-python-example.py 
# --vm.cp=lib/neo4j-java-driver-4.0.0.jar:lib/reactive-streams-1.0.2.jar
import java
import os

java.add_to_classpath("lib/reactive-streams-1.0.2.jar")
java.add_to_classpath("lib/neo4j-java-driver-4.0.0.jar")

# Open up a connection
graphDatabase = java.type('org.neo4j.driver.GraphDatabase')
authTokens = java.type('org.neo4j.driver.AuthTokens')
config = java.type('org.neo4j.driver.Config')
driver = graphDatabase.driver('bolt://localhost:7687', authTokens.basic('neo4j', 'secret'), config.defaultConfig())

def findConnections(driver):
    query="""
        MATCH (:Person {name:"Tom Hanks"})-[:ACTED_IN]->(m)<-[:ACTED_IN]-(coActor)
        RETURN DISTINCT coActor
    """

    session = driver.session()
    records = session.run(query).list()

    coActors = [r.get('coActor').get('name').asString() for r in records]
    
    session.close()
    return coActors

results = findConnections(driver)

for name in results: 
    print(name)


driver.close()
