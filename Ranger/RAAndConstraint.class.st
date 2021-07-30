Class {
	#name : #RAAndConstraint,
	#superclass : #RAConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #microzinc }
RAAndConstraint >> mzConstraintOnInterpreter: anInterpreter [
	
	^ (operands first mzConstraintOnInterpreter: anInterpreter)
		and: (operands second mzConstraintOnInterpreter: anInterpreter)
]

{ #category : #negating }
RAAndConstraint >> negated [
	
	^ RAOrConstraint operands: (operands collect: [ :e | e negated ])
]
