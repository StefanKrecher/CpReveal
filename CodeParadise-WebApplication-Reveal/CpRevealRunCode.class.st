Class {
	#name : 'CpRevealRunCode',
	#superclass : 'Announcement',
	#instVars : [
		'index',
		'code'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Announcements',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
CpRevealRunCode class >> index: anIndex code: aString [

	^ self new setIndex: anIndex code: aString
]

{ #category : 'accessing' }
CpRevealRunCode >> code [

	^ code
]

{ #category : 'accessing' }
CpRevealRunCode >> index [

	^ index
]

{ #category : 'initialization' }
CpRevealRunCode >> setIndex: anIndex code: aString [

	index := anIndex.
	code := aString
]
