Class {
	#name : #RANotEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #converting }
RANotEqualsConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand rightOperand |
	(operands first isConstant and: [ operands second isConstant ]) 
		ifTrue: [ ^ self "Do not add constraints with only constants" ].

	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.
	rightOperand := operands second
		                addToSolver: aSolver
		                withVariables: variables
		                interpreter: interpreter.

	"In Cassowary we can only express =.
	Interpret for now a ~= b as
	a >= b + 0.001
	This is not entirely true, as this only accounts for a > b, but not b > a"
	aSolver addConstraint: ((leftOperand - rightOperand) abs cnGEQ: 1)
]

{ #category : #transformations }
RANotEqualsConstraint >> invert [

	^ RANotEqualsConstraint operands: self operands reversed
]

{ #category : #negating }
RANotEqualsConstraint >> negated [

	^ RAEqualsConstraint operands: self operands
]
