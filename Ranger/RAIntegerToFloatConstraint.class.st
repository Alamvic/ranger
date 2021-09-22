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
RAIntegerToFloatConstraint >> evaluateWith: interpreter [ 

	^ (operands first evaluateWith: interpreter) asFloat
]

{ #category : #microzinc }
RAIntegerToFloatConstraint >> mzConstraintOnInterpreter: aCogVMSimulatorLSB [ 
	
	^ self
]
