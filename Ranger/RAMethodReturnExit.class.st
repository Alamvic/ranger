Class {
	#name : #RAMethodReturnExit,
	#superclass : #RAInterpreterExitCondition,
	#instVars : [
		'returnValue'
	],
	#category : #'Ranger-Interpreter'
}

{ #category : #executing }
RAMethodReturnExit >> executeTest: aRAAutoTest [ 
	
	aRAAutoTest executeUntilReturn
]

{ #category : #testing }
RAMethodReturnExit >> isInvalidIn: aTest [

	"A method return is never invalid"
	^ false
]

{ #category : #accessing }
RAMethodReturnExit >> result [
	
	^ returnValue 
]

{ #category : #compiling }
RAMethodReturnExit >> returnResultInto: aTest [ 
	
	"Do nothing, I should already be compiled with a return"
]

{ #category : #accessing }
RAMethodReturnExit >> returnValue [

	^ returnValue
]

{ #category : #accessing }
RAMethodReturnExit >> returnValue: anObject [

	returnValue := anObject
]
