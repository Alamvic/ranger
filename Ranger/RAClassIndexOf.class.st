Class {
	#name : #RAClassIndexOf,
	#superclass : #RAValueConstraint,
	#category : #'Ranger-VMSpecificConstraints'
}

{ #category : #microzinc }
RAClassIndexOf >> mzConstraintOnInterpreter: interpreter [
	
	^ operands first classIndex
]
