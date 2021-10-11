Class {
	#name : #RAIntegerToFloatConstraint,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #converting }
RAIntegerToFloatConstraint >> asMzValue [
	
	^ self
]

{ #category : #evaluating }
RAIntegerToFloatConstraint >> evaluate [
	
	^ operands first evaluate asFloat
]

{ #category : #evaluating }
RAIntegerToFloatConstraint >> evaluateWith: anObjectBuilder [ 

	^ (operands first evaluateWith: anObjectBuilder) asFloat
]

{ #category : #microzinc }
RAIntegerToFloatConstraint >> mzConstraintOnInterpreter: aCogVMSimulatorLSB [ 
	
	^ self
]
