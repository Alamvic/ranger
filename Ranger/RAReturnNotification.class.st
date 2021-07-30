Class {
	#name : #RAReturnNotification,
	#superclass : #Exception,
	#instVars : [
		'frameToReturnTo'
	],
	#category : #Ranger
}

{ #category : #accessing }
RAReturnNotification class >> to: aFrame [

	^ self new
		frameToReturnTo: aFrame;
		yourself
]

{ #category : #accessing }
RAReturnNotification >> frameToReturnTo [

	^ frameToReturnTo
]

{ #category : #accessing }
RAReturnNotification >> frameToReturnTo: anObject [

	frameToReturnTo := anObject
]
