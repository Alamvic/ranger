Class {
	#name : #RAOrConstraint,
	#superclass : #RAConstraint,
	#category : #'Ranger-Constraints'
}

{ #category : #adding }
RAOrConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	"In Cassowary this is by default an AND, no need to push another constraint"
1halt.
	operands first
		addToSolver: aSolver
		withVariables: variables
		interpreter: interpreter.
	operands second
		addToSolver: aSolver
		withVariables: variables
		interpreter: interpreter
]

{ #category : #microzinc }
RAOrConstraint >> mzConstraintOnInterpreter: anInterpreter [
	
	^ (operands first mzConstraintOnInterpreter: anInterpreter)
		or: (operands second mzConstraintOnInterpreter: anInterpreter)
]

{ #category : #negating }
RAOrConstraint >> negated [
	
	^ RAAndConstraint operands: (operands collect: [ :e | e negated ]) 
]
