Class {
	#name : #RABooleanObjectOf,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #evaluating }
RABooleanObjectOf >> evaluateWith: anObjectBuilder [ 
	
	^ anObjectBuilder objectMemory booleanObjectOf: (operands first evaluateWith: anObjectBuilder)
]

{ #category : #testing }
RABooleanObjectOf >> isBooleanObjectOf [
	
	^ true
]
