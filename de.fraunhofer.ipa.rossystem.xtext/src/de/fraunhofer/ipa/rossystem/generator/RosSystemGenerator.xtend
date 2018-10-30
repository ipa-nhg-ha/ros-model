/*
 * generated by Xtext 2.13.0
 */
package de.fraunhofer.ipa.rossystem.generator

import componentInterface.ComponentInterface
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import ros.Publisher
import ros.ServiceClient
import ros.ServiceServer
import ros.Subscriber
import rossystem.RosSystem
import ros.Namespace

class RosSystemGenerator extends AbstractGenerator {

	String package_name	
	String package_impl
	Object artifact_name
	String artifact_impl
	
	boolean PackageSet
	
	boolean ArtifactSet

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {

		for (system : resource.allContents.toIterable.filter(RosSystem)){
				fsa.generateFile(system.getName()+".launch",system.compile)
				}
			}
	
	
	def compile(RosSystem system) '''«init()»
<?xml version="1.0"?>
<launch>
	«FOR component:system.rosComponent»
	<node pkg="«component.compile_pkg»" type="«component.compile_art»«init()»" name="«IF component.hasNS»«component.get_ns»_«ENDIF»«component.compile_art»"«IF component.hasNS» ns="«component.get_ns»"«ENDIF» cwd="node" respawn="false" output="screen">«init()»
		«FOR rosPublisher:component.rospublisher»
			«IF component.hasNS»
				«IF rosPublisher.name.contains(component.get_ns)»
				«ELSEIF rosPublisher.name.equals(rosPublisher.publisher.compile_topic_name()) »
				«ELSEIF !rosPublisher.name.contains(component.get_ns)»
		<remap from="«rosPublisher.publisher.compile_topic_name()»" to="«rosPublisher.name»" />
				«ELSEIF !rosPublisher.name.equals(rosPublisher.publisher.compile_topic_name()) »
		<remap from="«rosPublisher.publisher.compile_topic_name()»" to="«rosPublisher.name»" />
				«ENDIF»
			«ELSEIF rosPublisher.name.equals(rosPublisher.publisher.compile_topic_name()) »
			«ELSEIF !rosPublisher.name.equals(rosPublisher.publisher.compile_topic_name()) »
		<remap from="«rosPublisher.publisher.compile_topic_name()»" to="«rosPublisher.name»" />
			«ENDIF»
		«ENDFOR»
		«FOR rosSubscriber:component.rossubscriber»
			«IF component.hasNS»
				«IF rosSubscriber.name.contains(component.get_ns)»
				«ELSEIF rosSubscriber.name.equals(rosSubscriber.subscriber.compile_topic_name()) »
				«ELSEIF !rosSubscriber.name.contains(component.get_ns)»
		<remap from="«rosSubscriber.subscriber.compile_topic_name()»" to="«rosSubscriber.name»" />
				«ELSEIF !rosSubscriber.name.equals(rosSubscriber.subscriber.compile_topic_name()) »
		<remap from="«rosSubscriber.subscriber.compile_topic_name()»" to="«rosSubscriber.name»" />
				«ENDIF»
			«ELSEIF rosSubscriber.name.equals(rosSubscriber.subscriber.compile_topic_name()) »
			«ELSEIF !rosSubscriber.name.equals(rosSubscriber.subscriber.compile_topic_name()) »
		<remap from="«rosSubscriber.subscriber.compile_topic_name()»" to="«rosSubscriber.name»" />
			«ENDIF»
		«ENDFOR»
		«FOR rosServiceServer:component.rosserviceserver»
			«IF component.hasNS»
				«IF rosServiceServer.name.contains(component.get_ns)»
				«ELSEIF rosServiceServer.name.equals(rosServiceServer.srvserver.compile_service_name()) »
				«ELSEIF !rosServiceServer.name.contains(component.get_ns)»
		<remap from="«rosServiceServer.srvserver.compile_service_name()»" to="«rosServiceServer.name»" />
				«ELSEIF !rosServiceServer.name.equals(rosServiceServer.srvserver.compile_service_name()) »
		<remap from="«rosServiceServer.srvserver.compile_service_name()»" to="«rosServiceServer.name»" />
				«ENDIF»
			«ELSEIF rosServiceServer.name.equals(rosServiceServer.srvserver.compile_service_name()) »
			«ELSEIF !rosServiceServer.name.equals(rosServiceServer.srvserver.compile_service_name()) »
		<remap from="«rosServiceServer.srvserver.compile_service_name()»" to="«rosServiceServer.name»" />
			«ENDIF»
		«ENDFOR»
		«FOR rosServiceClient:component.rosserviceclient»
			«IF component.hasNS»
				«IF rosServiceClient.name.contains(component.get_ns)»
				«ELSEIF rosServiceClient.name.equals(rosServiceClient.srvclient.compile_service_name()) »
				«ELSEIF !rosServiceClient.name.contains(component.get_ns)»
		<remap from="«rosServiceClient.srvclient.compile_service_name()»" to="«rosServiceClient.name»" />
				«ELSEIF !rosServiceClient.name.equals(rosServiceClient.srvclient.compile_service_name()) »
		<remap from="«rosServiceClient.srvclient.compile_service_name()»" to="«rosServiceClient.name»" />
				«ENDIF»
			«ELSEIF rosServiceClient.name.equals(rosServiceClient.srvclient.compile_service_name()) »
			«ELSEIF !rosServiceClient.name.equals(rosServiceClient.srvclient.compile_service_name()) »
		<remap from="«rosServiceClient.srvclient.compile_service_name()»" to="«rosServiceClient.name»" />
			«ENDIF»
			«ENDFOR»
	</node>
	«ENDFOR»
</launch>
	'''
def boolean hasNS(ComponentInterface component){
	if(!component.eAllContents.toIterable.filter(Namespace).empty){
		return true;
	}else{
		return false
	}
}
def String get_ns(ComponentInterface component){
	return component.namespace.parts.get(0).replaceFirst("/","");
}

def compile_pkg(ComponentInterface component) 
'''«IF !PackageSet && !component.rospublisher.empty»«FOR Rospublisher:component.rospublisher»«IF !PackageSet»«Rospublisher.publisher.getPackage_pub()»«ENDIF»«ENDFOR»«ELSEIF !PackageSet && !component.rossubscriber.empty»«FOR Rossubscriber:component.rossubscriber»«IF !PackageSet»«Rossubscriber.subscriber.getPackage_sub()»«ENDIF»«ENDFOR»«ELSEIF !PackageSet && !component.rosserviceserver.empty»«FOR Rosserviceserver:component.rosserviceserver»«IF !PackageSet»«Rosserviceserver.srvserver.getPackage_srvserv()»«ENDIF»«ENDFOR»«ELSEIF !PackageSet && !component.rosserviceclient.empty»«FOR Rosserviceclient:component.rosserviceclient»«IF !PackageSet»«Rosserviceclient.srvclient.getPackage_srvcli()»«ENDIF»«ENDFOR»«ENDIF»'''
	
	def void init(){
		PackageSet=false
		ArtifactSet=false
	}
	def getPackage_pub(Publisher publisher){
		package_impl = publisher.eContainer.eContainer.eContainer.toString;
		return package_impl.getPackage;
	}
	def getPackage_sub(Subscriber subscriber){
		package_impl = subscriber.eContainer.eContainer.eContainer.toString;
		return package_impl.getPackage;
	}
	def getPackage_srvserv(ServiceServer serviceserver){
		package_impl = serviceserver.eContainer.eContainer.eContainer.toString;
		return package_impl.getPackage;
	}
	def getPackage_srvcli(ServiceClient serviceclient){
		package_impl = serviceclient.eContainer.eContainer.eContainer.toString;
		return package_impl.getPackage;
	}
	def getPackage(String package_impl){
			package_name = package_impl.substring(package_impl.indexOf("name")+6,package_impl.length-1)
			PackageSet=true;
			return package_name;
	}
	
	def compile_art(ComponentInterface component) 	
'''«IF !ArtifactSet && !component.rospublisher.empty»«FOR Rospublisher:component.rospublisher»«IF !ArtifactSet»«Rospublisher.publisher.getArtifact_pub()»«ENDIF»«ENDFOR»«ELSEIF !ArtifactSet && !component.rossubscriber.empty»«FOR Rossubscriber:component.rossubscriber»«IF !ArtifactSet»«Rossubscriber.subscriber.getArtifact_sub()»«ENDIF»«ENDFOR»«ELSEIF !ArtifactSet && !component.rosserviceserver.empty»«FOR Rosserviceserver:component.rosserviceserver»«IF !ArtifactSet»«Rosserviceserver.srvserver.getArtifact_srvserv()»«ENDIF»«ENDFOR»«ELSEIF !ArtifactSet && !component.rosserviceclient.empty»«FOR Rosserviceclient:component.rosserviceclient»«IF !ArtifactSet»«Rosserviceclient.srvclient.getArtifact_srvcli()»«ENDIF»«ENDFOR»«ENDIF»'''
	def getArtifact_pub(Publisher publisher){
		artifact_impl = publisher.eContainer.eContainer.toString;
		return artifact_impl.getArtifact;
	}
	def getArtifact_sub(Subscriber subscriber){
		artifact_impl = subscriber.eContainer.eContainer.toString;
		return artifact_impl.getArtifact;
	}
	def getArtifact_srvserv(ServiceServer serviceserver){
		artifact_impl = serviceserver.eContainer.eContainer.toString;
		return artifact_impl.getArtifact;
	}
	def getArtifact_srvcli(ServiceClient serviceclient){
		artifact_impl = serviceclient.eContainer.eContainer.toString;
		return artifact_impl.getArtifact;
	}
	def getArtifact(String artifact_impl){
		artifact_name = artifact_impl.substring(artifact_impl.indexOf("name")+6,artifact_impl.length-1)
		ArtifactSet=true;
		return artifact_name;
	}
	
	def compile_topic_name(Publisher publisher){
		return publisher.name;
	}
	def compile_topic_name(Subscriber subscriber){
		return subscriber.name;
	}
	def compile_service_name(ServiceServer serviceserver){
		return serviceserver.name;
	}
	def compile_service_name(ServiceClient serviceclient){
		return serviceclient.name;
	}
}
