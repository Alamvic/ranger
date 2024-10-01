Class {
	#name : 'RAClassIndexOf',
	#superclass : 'VMConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'as yet unclassified' }
RAClassIndexOf >> mutate: mutator [

	^ mutator mutateIsClassIndexOfConstraint: self
]

{ #category : 'microzinc' }
RAClassIndexOf >> mzConstraintOnInterpreter: interpreter [
	
	^ operands first classIndex
]

{ #category : 'printing' }
RAClassIndexOf >> operator [ 

	^ 'ClassIndexOf'
]
