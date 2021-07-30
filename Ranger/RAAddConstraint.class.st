Class {
	#name : #RAAddConstraint,
	#superclass : #RAValueConstraint,
	#category : #Ranger
}

{ #category : #adding }
RAAddConstraint >> addToSolver: aSolver withVariables: variables interpreter: interpreter [

	| leftOperand rightOperand leftValue rightValue |
	leftOperand := operands first
		               addToSolver: aSolver
		               withVariables: variables
		               interpreter: interpreter.
	rightOperand := operands second
		                addToSolver: aSolver
		                withVariables: variables
		                interpreter: interpreter.

	leftValue := leftOperand integerValue.
	rightValue := rightOperand integerValue.

	^ (RAObject named: UUID new asString)
		  typeTag: 17;
		  integerValue: leftValue + rightValue;
		  yourself "Native value"
]

{ #category : #adding }
RAAddConstraint >> prettyString [

	^ String streamContents: [ :str |
		self operands
			do: [ :op | str nextPutAll: op prettyString ]
			separatedBy: [ str nextPutAll: ' + ' ]]
]
