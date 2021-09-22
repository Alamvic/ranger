Class {
	#name : #RAInterpreterExitCondition,
	#superclass : #Object,
	#category : #'Ranger-Interpreter'
}

{ #category : #executing }
RAInterpreterExitCondition >> executeTest: aRAAutoTest [ 
	
	aRAAutoTest executeUntilReturn
]

{ #category : #testing }
RAInterpreterExitCondition >> isInvalid [
	
	^ false
]

{ #category : #accessing }
RAInterpreterExitCondition >> result [
	
	self subclassResponsibility
]
