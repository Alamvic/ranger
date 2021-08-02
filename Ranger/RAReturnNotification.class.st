Class {
	#name : #RAReturnNotification,
	#superclass : #Error,
	#instVars : [
		'frameToReturnTo'
	],
	#category : #'Ranger-Interpreter'
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
