Class {
	#name : 'RAIsCharacterObject',
	#superclass : 'VMConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'negating' }
RAIsCharacterObject >> isInCharacterRangeConstraintFor: valueConstraint inInterpreter: anInterpreter [

	"See isInRangeCharacterCode:"
	^ ((valueConstraint mzConstraintOnInterpreter: anInterpreter) 
		   greaterOrEquals: 0) 
		  and:
			  ((valueConstraint mzConstraintOnInterpreter: anInterpreter) 
				   lessOrEquals: (1 << 30) - 1)
]

{ #category : 'as yet unclassified' }
RAIsCharacterObject >> mutate: mutator [

	^ mutator mutateIsCharacterObjectConstraint: self
]

{ #category : 'negating' }
RAIsCharacterObject >> mzConstraintOnInterpreter: anInterpreter [

	^ (operands first typeTag equals: 2)
		and: (self
			   isInCharacterRangeConstraintFor: operands first integerValue
			   inInterpreter: anInterpreter)
]

{ #category : 'negating' }
RAIsCharacterObject >> negated [
	
	^ RAIsNonCharacterObject operands: self operands
]

{ #category : 'printing' }
RAIsCharacterObject >> operator [ 

	^ 'IsCharObj'
]
