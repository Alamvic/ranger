Class {
	#name : 'RABitAndConstraint',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-Constraints',
	#package : 'Ranger',
	#tag : 'Constraints'
}

{ #category : 'evaluating' }
RABitAndConstraint >> evaluateWith: anObjectBuilder [
	
	^ (operands first evaluateWith: anObjectBuilder) bitAnd: (operands second evaluateWith: anObjectBuilder)
]

{ #category : 'as yet unclassified' }
RABitAndConstraint >> mutate: mutator [

	^ mutator mutateBitAddConstraint: self
]

{ #category : 'printing' }
RABitAndConstraint >> operator [

	^ 'BIT_AND'
]
