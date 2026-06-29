Class {
	#name : 'CpRevealCustomContent',
	#superclass : 'CpRevealContent',
	#instVars : [
		'viewClass',
		'model'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Model',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CpRevealCustomContent class >> viewClass: aViewClass model: aModel [

	^ self new setViewClass: aViewClass model: aModel
]

{ #category : 'accessing' }
CpRevealCustomContent >> model [

	^ model
]

{ #category : 'rendering' }
CpRevealCustomContent >> renderRevealOn: r [

	r emit: '<div class="cp-custom"></div>'
]

{ #category : 'initialization' }
CpRevealCustomContent >> setViewClass: aViewClass model: aModel [

	viewClass := aViewClass.
	model := aModel
]

{ #category : 'accessing' }
CpRevealCustomContent >> viewClass [

	^ viewClass
]
