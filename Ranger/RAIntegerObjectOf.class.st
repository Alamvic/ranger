Class {
	#name : 'RAIntegerObjectOf',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'evaluating' }
RAIntegerObjectOf >> evaluateWith: anObjectBuilder [ 
	
	^ anObjectBuilder objectMemory integerObjectOf: (operands first evaluateWith: anObjectBuilder)
]

{ #category : 'testing' }
RAIntegerObjectOf >> isBooleanObjectOf [
	
	^ false
]

{ #category : 'testing' }
RAIntegerObjectOf >> isIntegerObjectOf [
	
	^ true
]

{ #category : 'as yet unclassified' }
RAIntegerObjectOf >> mutate: mutator [

	^ mutator mutateIsIntegerObjectOfConstraint: self
]
