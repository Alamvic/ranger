Class {
	#name : #RABooleanObjectOf,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #evaluating }
RABooleanObjectOf >> evaluateWith: interpreter [ 
	
	^ interpreter objectMemory booleanObjectOf: (operands evaluateWith: interpreter)
]

{ #category : #testing }
RABooleanObjectOf >> isBooleanObjectOf [
	
	^ true
]
