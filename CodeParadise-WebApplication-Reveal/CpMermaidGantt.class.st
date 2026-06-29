Class {
	#name : 'CpMermaidGantt',
	#superclass : 'CpMermaidDiagram',
	#instVars : [
		'title',
		'dateFormat',
		'sections',
		'currentSection'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Mermaid',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Mermaid'
}

{ #category : 'private' }
CpMermaidGantt >> addTaskLine: aLine [

	currentSection ifNil: [ self section: 'Tasks' ].
	(currentSection at: 2) add: aLine.
	^ self
]

{ #category : 'building' }
CpMermaidGantt >> dateFormat: aString [

	dateFormat := aString.
	^ self
]

{ #category : 'initialization' }
CpMermaidGantt >> initialize [

	super initialize.
	dateFormat := 'YYYY-MM-DD'.
	sections := OrderedCollection new
]

{ #category : 'generating' }
CpMermaidGantt >> mermaidText [

	| s |
	s := WriteStream on: String new.
	s
		nextPutAll: 'gantt';
		nextPut: Character lf.
	title ifNotNil: [
			s
				nextPutAll: '  title ';
				nextPutAll: title;
				nextPut: Character lf ].
	s
		nextPutAll: '  dateFormat ';
		nextPutAll: dateFormat;
		nextPut: Character lf.
	sections do: [ :sec |
			s
				nextPutAll: '  section ';
				nextPutAll: (sec at: 1);
				nextPut: Character lf.
			(sec at: 2) do: [ :t |
					s
						nextPutAll: '    ';
						nextPutAll: t;
						nextPut: Character lf ] ].
	^ s contents
]

{ #category : 'building' }
CpMermaidGantt >> section: aName [

	currentSection := Array with: aName with: OrderedCollection new.
	sections add: currentSection.
	^ self
]

{ #category : 'building' }
CpMermaidGantt >> task: aLabel after: anId duration: aDuration [

	^ self addTaskLine:
		  aLabel , ' :after ' , anId asString , ', ' , aDuration
]

{ #category : 'building' }
CpMermaidGantt >> task: aLabel id: anId start: aStart duration: aDuration [

	^ self addTaskLine:
		  aLabel , ' :' , anId asString , ', ' , aStart , ', ' , aDuration
]

{ #category : 'building' }
CpMermaidGantt >> task: aLabel start: aStart duration: aDuration [

	^ self addTaskLine: aLabel , ' : ' , aStart , ', ' , aDuration
]

{ #category : 'building' }
CpMermaidGantt >> title: aString [

	title := aString.
	^ self
]
