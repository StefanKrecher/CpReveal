Class {
	#name : 'CpRevealApplySource',
	#superclass : 'Announcement',
	#instVars : [
		'code'
	],
	#category : 'CodeParadise-WebApplication-Reveal-Announcements',
	#package : 'CodeParadise-WebApplication-Reveal',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
CpRevealApplySource class >> code: aString [

	^ self new setCode: aString
]

{ #category : 'accessing' }
CpRevealApplySource >> code [

	^ code
]

{ #category : 'initialization' }
CpRevealApplySource >> setCode: aString [

	code := aString
]
