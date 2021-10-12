Class {
	#name : #RABitOrConstraint,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #evaluating }
RABitOrConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) bitOr: (operands second evaluateWith: anObjectBuilder)
]
