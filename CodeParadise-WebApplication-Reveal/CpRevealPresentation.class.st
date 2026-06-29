"
I model a reveal.js presentation: an ordered list of slides plus theme, transition and config. I am the entry point of the slide-building DSL and inherit the slide protocol from CpRevealSectionList.

  (CpRevealPresentation titled: 'Demo')
    theme: #black;        ""black white league beige sky night serif simple solarized moon dracula""
    transition: #slide;   ""none fade slide convex concave zoom""
    title: 'Main Title' subtitle: 'Subtitle';
    slide: 'Heading' bullets: #('one' 'two' 'three');
    slide: 'Steps' bullets: { 'shown first' -> false. 'as fragment' -> true };
    slide: 'Code' code: 'foo ^ 42' language: #smalltalk;
    slide: 'Math' math: 'E = mc^2';
    slide: 'Diagram' mermaid: (CpMermaidFlowchart new node: #a label: 'A'; node: #b label: 'B'; edge: #a to: #b; yourself);
    slide: 'Live' doIt: '42 factorial';
    verticals: [ :v | v slide: 'Top' text: 'down arrow for more'. v slide: 'Below' bullets: #('x' 'y') ];
    slide: 'Custom' with: [ :s | s title: 'H' subtitle: 'sub'; bullets: #('a'); html: '<b>raw</b>' ];
    notesForLastSlide: 'speaker note';
    yourself

bullets: accepts plain Strings or text->isFragment Associations.
"
Class {
	#name : 'CpRevealPresentation',
	#superclass : 'CpRevealSectionList',
	#instVars : [
		'title',
		'theme',
		'transition',
		'config',
		'currentIndex'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealPresentation class >> titled: aString [

	^ self new setTitle: aString
]

{ #category : 'accessing' }
CpRevealPresentation >> config [

	^ config
]

{ #category : 'accessing' }
CpRevealPresentation >> config: aDictionary [

	config := aDictionary.
	^ self
]

{ #category : 'accessing' }
CpRevealPresentation >> configAt: aKey put: aValue [

	config at: aKey put: aValue.
	^ self
]

{ #category : 'accessing' }
CpRevealPresentation >> currentIndex [

	^ currentIndex
]

{ #category : 'accessing' }
CpRevealPresentation >> currentIndex: anInteger [

	currentIndex := anInteger
]

{ #category : 'initialization' }
CpRevealPresentation >> initialize [

	super initialize.
	theme := #black.
	transition := #slide.
	config := Dictionary new.
	currentIndex := 0
]

{ #category : 'accessing' }
CpRevealPresentation >> sectionCount [

	^ self sections size
]

{ #category : 'initialization' }
CpRevealPresentation >> setTitle: aString [

	title := aString
]

{ #category : 'actions' }
CpRevealPresentation >> start [
	"Initialise navigation state. reveal.js performs the actual navigation in the browser."

	currentIndex := 0.
	^ self
]

{ #category : 'accessing' }
CpRevealPresentation >> theme [

	^ theme
]

{ #category : 'accessing' }
CpRevealPresentation >> theme: aSymbol [

	theme := aSymbol.
	self valueChanged.
	^ self
]

{ #category : 'accessing' }
CpRevealPresentation >> title [

	^ title
]

{ #category : 'accessing' }
CpRevealPresentation >> transition [

	^ transition
]

{ #category : 'accessing' }
CpRevealPresentation >> transition: aSymbol [

	transition := aSymbol.
	^ self
]
