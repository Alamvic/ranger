Extension { #name : 'CoverageResult' }

{ #category : '*Ranger' }
CoverageResult >> hasAllNodesCovered: aMethod [

	aMethod ast nodesDo: [ :node |
		node isSequence ifTrue: [ node hasBeenExecuted ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : '*Ranger' }
CoverageResult >> partiallyCoveredMethods [

	^ self methods select: [ :meth | (self hasAllNodesCovered: meth) not ]
]
