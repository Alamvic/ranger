Class {
	#name : 'VMConstraint',
	#superclass : 'RAValueConstraint',
	#category : 'Ranger-VMSpecificConstraints',
	#package : 'Ranger',
	#tag : 'VMSpecificConstraints'
}

{ #category : 'printing' }
VMConstraint >> operator [

	self subclassResponsibility 
]

{ #category : 'printing' }
VMConstraint >> toString [ 

	^ self operator  , '( ' , self operands first toString , ' )'
]
