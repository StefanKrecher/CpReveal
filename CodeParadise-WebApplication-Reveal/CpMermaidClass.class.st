Class {
	#name : 'CpMermaidClass',
	#superclass : 'CpMermaidDiagram',
	#instVars : [
		'classNames',
		'members',
		'relations'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Mermaid',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Mermaid'
}

{ #category : 'building' }
CpMermaidClass >> class: aName [

	self ensureClass: aName.
	^ self
]

{ #category : 'building' }
CpMermaidClass >> class: aName attribute: anAttribute [

	(members at: (self ensureClass: aName)) add: '+' , anAttribute.
	^ self
]

{ #category : 'building' }
CpMermaidClass >> class: aName method: aMethod [

	| sig |
	sig := (aMethod includesSubstring: '(')
		       ifTrue: [ aMethod ]
		       ifFalse: [ aMethod , '()' ].
	(members at: (self ensureClass: aName)) add: '+' , sig.
	^ self
]

{ #category : 'private' }
CpMermaidClass >> ensureClass: aName [

	(classNames includes: aName asString) ifFalse: [
			classNames add: aName asString.
			members at: aName asString put: OrderedCollection new ].
	^ aName asString
]

{ #category : 'initialization' }
CpMermaidClass >> initialize [

	super initialize.
	classNames := OrderedCollection new.
	members := Dictionary new.
	relations := OrderedCollection new
]

{ #category : 'generating' }
CpMermaidClass >> mermaidText [

	| s |
	s := WriteStream on: String new.
	s
		nextPutAll: 'classDiagram';
		nextPut: Character lf.
	classNames do: [ :n |
			| mem |
			mem := members at: n.
			mem isEmpty
				ifTrue: [
						s
							nextPutAll: '  class ';
							nextPutAll: n;
							nextPut: Character lf ]
				ifFalse: [
						s
							nextPutAll: '  class ';
							nextPutAll: n;
							nextPutAll: ' {';
							nextPut: Character lf.
						mem do: [ :line |
								s
									nextPutAll: '    ';
									nextPutAll: line;
									nextPut: Character lf ].
						s
							nextPutAll: '  }';
							nextPut: Character lf ] ].
	relations do: [ :r |
			s
				nextPutAll: '  ';
				nextPutAll: r;
				nextPut: Character lf ].
	^ s contents
]

{ #category : 'building' }
CpMermaidClass >> relation: aClass association: anotherClass [

	relations add: aClass asString , ' --> ' , anotherClass asString.
	^ self
]

{ #category : 'building' }
CpMermaidClass >> relation: aClass association: anotherClass label: aLabel [

	relations add:
		aClass asString , ' --> ' , anotherClass asString , ' : ' , aLabel.
	^ self
]

{ #category : 'building' }
CpMermaidClass >> relation: aSubclass inherits: aSuperclass [

	self ensureClass: aSubclass.
	self ensureClass: aSuperclass.
	relations add: aSuperclass asString , ' <|-- ' , aSubclass asString.
	^ self
]
