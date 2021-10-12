Class {
	#name : #RAInvalidFrameAccess,
	#superclass : #RAInterpreterExitCondition,
	#category : #'Ranger-Interpreter'
}

{ #category : #testing }
RAInvalidFrameAccess >> isInvalid [
	
	^ true
]

{ #category : #testing }
RAInvalidFrameAccess >> isInvalidIn: aTest [ 
	
	"Consider all invalid frame accesses as invalid created frames"
	^ true
]
