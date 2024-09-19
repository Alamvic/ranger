Class {
	#name : 'RAInvalidMemoryAccess',
	#superclass : 'RAInterpreterExitCondition',
	#category : 'Ranger-Interpreter',
	#package : 'Ranger',
	#tag : 'Interpreter'
}

{ #category : 'testing' }
RAInvalidMemoryAccess >> isInvalidIn: aTest [
	
	^ aTest isInvalidMemoryAccessInvalid
]
