Class {
	#name : 'CpMermaidNode',
	#superclass : 'Object',
	#instVars : [
		'id',
		'label',
		'shape'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Mermaid',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Mermaid'
}

{ #category : 'instance creation' }
CpMermaidNode class >> id: anId label: aLabel shape: aShape [

	^ self new setId: anId label: aLabel shape: aShape
]

{ #category : 'generating' }
CpMermaidNode >> mermaidFragment [

	| open close |
	shape = #round
		ifTrue: [
				open := '('.
				close := ')' ]
		ifFalse: [
				shape = #diamond
					ifTrue: [
							open := '{'.
							close := '}' ]
					ifFalse: [
							shape = #stadium
								ifTrue: [
										open := '(['.
										close := '])' ]
								ifFalse: [
										open := '['.
										close := ']' ] ] ].
	^ id asString , open , label , close
]

{ #category : 'initialization' }
CpMermaidNode >> setId: anId label: aLabel shape: aShape [

	id := anId.
	label := aLabel.
	shape := aShape
]
