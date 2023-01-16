Class {
	#name : #RAIntegerObjectOf,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #evaluating }
RAIntegerObjectOf >> evaluateWith: anObjectBuilder [ 
	
	^ anObjectBuilder objectMemory integerObjectOf: (operands first evaluateWith: anObjectBuilder)
]

{ #category : #testing }
RAIntegerObjectOf >> isBooleanObjectOf [
	
	^ false
]

{ #category : #testing }
RAIntegerObjectOf >> isIntegerObjectOf [
	
	^ true
]
