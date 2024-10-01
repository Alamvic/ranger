Class {
	#name : 'RABitOrConstraint',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'evaluating' }
RABitOrConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) bitOr: (operands second evaluateWith: anObjectBuilder)
]

{ #category : 'as yet unclassified' }
RABitOrConstraint >> mutate: mutator [

	^ mutator mutateBitOrConstraint: self
]

{ #category : 'printing' }
RABitOrConstraint >> operator [

	^ 'BIT_OR'
]
