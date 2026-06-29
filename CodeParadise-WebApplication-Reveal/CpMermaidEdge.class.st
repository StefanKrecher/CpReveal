Class {
	#name : 'CpMermaidEdge',
	#superclass : 'Object',
	#instVars : [
		'from',
		'to',
		'label'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Mermaid',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Mermaid'
}

{ #category : 'instance creation' }
CpMermaidEdge class >> from: aFrom to: aTo label: aLabel [

	^ self new setFrom: aFrom to: aTo label: aLabel
]

{ #category : 'generating' }
CpMermaidEdge >> flowFragment [

	^ label isNil
		  ifTrue: [ from asString , ' --> ' , to asString ]
		  ifFalse: [ from asString , ' -->|' , label , '| ' , to asString ]
]

{ #category : 'initialization' }
CpMermaidEdge >> setFrom: aFrom to: aTo label: aLabel [

	from := aFrom.
	to := aTo.
	label := aLabel
]
