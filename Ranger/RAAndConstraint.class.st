Class {
	#name : #RAAndConstraint,
	#superclass : #RAConstraint,
	#category : #Ranger
}

{ #category : #adding }
RAAndConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	"In Cassowary this is by default an AND, no need to push another constraint"

	operands first
		addToSolver: aSolver
		withVariables: variables
		interpreter: interpreter.
	operands second
		addToSolver: aSolver
		withVariables: variables
		interpreter: interpreter
]
