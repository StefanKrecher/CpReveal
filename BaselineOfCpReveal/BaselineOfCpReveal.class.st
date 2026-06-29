Class {
	#name : 'BaselineOfCpReveal',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfCpReveal',
	#package : 'BaselineOfCpReveal'
}

{ #category : 'baselines' }
BaselineOfCpReveal >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Dependency: CodeParadise"
			spec
				baseline: 'CodeParadise'
				with: [
				spec repository: 'github://ErikOnBike/CodeParadise:master' ].
			"This project"
			spec
				package: 'CodeParadise-WebApplication-Reveal'
				with: [ spec requires: #( 'CodeParadise' ) ] ]
]
