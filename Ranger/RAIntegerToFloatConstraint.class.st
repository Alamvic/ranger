Class {
	#name : 'RAIntegerToFloatConstraint',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'converting' }
RAIntegerToFloatConstraint >> asMzValue [
	
	^ self
]

{ #category : 'evaluating' }
RAIntegerToFloatConstraint >> evaluate [
	
	^ operands first evaluate asFloat
]

{ #category : 'evaluating' }
RAIntegerToFloatConstraint >> evaluateWith: anObjectBuilder [ 

	^ (operands first evaluateWith: anObjectBuilder) asFloat
]

{ #category : 'as yet unclassified' }
RAIntegerToFloatConstraint >> mutate: mutator [

	^ mutator mutateIsIntegerToFloatConstraint: self
]

{ #category : 'microzinc' }
RAIntegerToFloatConstraint >> mzConstraintOnInterpreter: aCogVMSimulatorLSB [ 
	
	^ self
]
