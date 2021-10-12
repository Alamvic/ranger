Class {
	#name : #RAInvalidMemoryAccess,
	#superclass : #RAInterpreterExitCondition,
	#category : #'Ranger-Interpreter'
}

{ #category : #testing }
RAInvalidMemoryAccess >> isInvalidIn: aTest [
	
	^ aTest isInvalidMemoryAccessInvalid
]
