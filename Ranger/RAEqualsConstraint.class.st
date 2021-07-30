Class {
	#name : #RAEqualsConstraint,
	#superclass : #RAPathConstraint,
	#category : #Ranger
}

{ #category : #converting }
RAEqualsConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

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

	"Somehow, sometimes constants on the left do not work"
	operands first isConstant
		ifTrue: [ 
		aSolver addConstraint: (rightOperand cnEqual: leftOperand) ]
		ifFalse: [ 
		aSolver addConstraint: (leftOperand cnEqual: rightOperand) ]
]

{ #category : #converting }
RAEqualsConstraint >> invert [

	^ RAEqualsConstraint operands: self operands reversed
]

{ #category : #converting }
RAEqualsConstraint >> negated [

	^ RANotEqualsConstraint operands: self operands
]
