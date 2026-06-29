Class {
	#name : 'CpRevealMathContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'tex',
		'displayMode'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealMathContent class >> tex: aString [

	^ self new setTex: aString
]

{ #category : 'accessing' }
CpRevealMathContent >> beInline [

	displayMode := false.
	^ self
]

{ #category : 'accessing' }
CpRevealMathContent >> displayMode [

	^ displayMode ~~ false
]

{ #category : 'rendering' }
CpRevealMathContent >> renderRevealOn: r [

	self displayMode
		ifTrue: [
				r
					emit: '<p>\[';
					emit: tex;
					emit: '\]</p>' ]
		ifFalse: [
				r
					emit: '\(';
					emit: tex;
					emit: '\)' ]
]

{ #category : 'initialization' }
CpRevealMathContent >> setTex: aString [

	tex := aString.
	displayMode := true
]

{ #category : 'accessing' }
CpRevealMathContent >> tex [

	^ tex
]
