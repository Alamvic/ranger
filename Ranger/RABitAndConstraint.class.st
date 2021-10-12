Class {
	#name : #RABitAndConstraint,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RABitAndConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) bitAnd: (operands second evaluateWith: anObjectBuilder)
]
