"
I build Mermaid sequence-diagram source.

  CpMermaidSequence new
    participant: #u as: 'User';
    participant: #s as: 'Server';
    message: #u to: #s text: 'request';
    reply: #s to: #u text: 'response';
    yourself
"
Class {
	#name : 'CpMermaidSequence',
	#superclass : 'CpMermaidDiagram',
	#instVars : [
		'participants',
		'messages'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Mermaid',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Mermaid'
}

{ #category : 'initialization' }
CpMermaidSequence >> initialize [

	super initialize.
	participants := OrderedCollection new.
	messages := OrderedCollection new
]

{ #category : 'generating' }
CpMermaidSequence >> mermaidText [

	| s |
	s := WriteStream on: String new.
	s
		nextPutAll: 'sequenceDiagram';
		nextPut: Character lf.
	participants do: [ :a |
			s
				nextPutAll: '  participant ';
				nextPutAll: a key asString;
				nextPutAll: ' as ';
				nextPutAll: a value;
				nextPut: Character lf ].
	messages do: [ :msg |
			s
				nextPutAll: '  ';
				nextPutAll: (msg at: 1) asString;
				nextPutAll: ((msg at: 4)
						 ifTrue: [ '-->>' ]
						 ifFalse: [ '->>' ]);
				nextPutAll: (msg at: 2) asString;
				nextPutAll: ': ';
				nextPutAll: (msg at: 3);
				nextPut: Character lf ].
	^ s contents
]

{ #category : 'building' }
CpMermaidSequence >> message: aFrom to: aTo text: aText [

	messages add: {
			aFrom.
			aTo.
			aText.
			false }.
	^ self
]

{ #category : 'building' }
CpMermaidSequence >> participant: anId as: aLabel [

	participants add: anId -> aLabel.
	^ self
]

{ #category : 'building' }
CpMermaidSequence >> reply: aFrom to: aTo text: aText [

	messages add: {
			aFrom.
			aTo.
			aText.
			true }.
	^ self
]
