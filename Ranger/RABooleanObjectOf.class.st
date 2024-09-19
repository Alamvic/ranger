Class {
	#name : 'RABooleanObjectOf',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'evaluating' }
RABooleanObjectOf >> evaluateWith: anObjectBuilder [ 
	
	^ anObjectBuilder objectMemory booleanObjectOf: (operands first evaluateWith: anObjectBuilder)
]

{ #category : 'testing' }
RABooleanObjectOf >> isBooleanObjectOf [
	
	^ true
]

{ #category : 'as yet unclassified' }
RABooleanObjectOf >> mutate: mutator [

	^ mutator mutateIsBooleanObjectOfConstraint: self
]
