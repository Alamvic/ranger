Class {
	#name : 'RABooleanObjectOf',
	#superclass : 'VMConstraint',
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

{ #category : 'printing' }
RABooleanObjectOf >> operator [ 

	^ 'BoolObjOf'
]
