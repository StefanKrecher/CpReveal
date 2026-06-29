"
I am the abstract base of a content block on a slide. Subclasses: Title, Text, Bullets, Code, Markup, Image, Math, Mermaid, DoIt, Custom. Each implements #renderRevealOn: to emit its reveal.js HTML. Send #beFragment to make a whole block appear as a reveal.js fragment (step reveal).
"
Class {
	#name : 'CpRevealContent',
	#superclass : 'CpModel',
	#instVars : [
		'isFragment'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'accessing' }
CpRevealContent >> beFragment [
	"Mark this content as a fragment; answer self for chaining"

	isFragment := true.
	^ self
]

{ #category : 'accessing' }
CpRevealContent >> isFragment [
	"Answer whether this content appears as a reveal.js fragment (step reveal)"

	^ isFragment == true
]

{ #category : 'accessing' }
CpRevealContent >> isFragment: aBoolean [

	isFragment := aBoolean
]
