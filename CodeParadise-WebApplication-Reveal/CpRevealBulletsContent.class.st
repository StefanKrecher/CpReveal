Class {
	#name : 'CpRevealBulletsContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'items',
		'ordered'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealBulletsContent class >> items: aCollection [
	"aCollection may contain Strings or Associations (text -> isFragmentBoolean)"

	^ self new setItems: aCollection
]

{ #category : 'accessing' }
CpRevealBulletsContent >> beOrdered [

	ordered := true.
	^ self
]

{ #category : 'accessing' }
CpRevealBulletsContent >> items [

	^ items
]

{ #category : 'accessing' }
CpRevealBulletsContent >> normalizedItems [
	"Answer a collection of Associations text -> isFragmentBoolean"

	^ items collect: [ :each |
			  each isString
				  ifTrue: [ each -> false ]
				  ifFalse: [ each key -> (each value == true) ] ]
]

{ #category : 'accessing' }
CpRevealBulletsContent >> ordered [

	^ ordered == true
]

{ #category : 'rendering' }
CpRevealBulletsContent >> renderRevealOn: r [

	| tag |
	tag := self ordered
		       ifTrue: [ 'ol' ]
		       ifFalse: [ 'ul' ].
	r
		emit: '<';
		emit: tag;
		emit: '>'.
	self normalizedItems do: [ :assoc |
			r emit: (assoc value
					 ifTrue: [ '<li class="fragment">' ]
					 ifFalse: [ '<li>' ]).
			r emit: (r escape: assoc key).
			r emit: '</li>' ].
	r
		emit: '</';
		emit: tag;
		emit: '>'
]

{ #category : 'initialization' }
CpRevealBulletsContent >> setItems: aCollection [

	items := aCollection asOrderedCollection
]
