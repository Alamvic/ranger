Class {
	#name : 'C2SequenceGraphVisitor',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'edges',
		'currentNode',
		'collector'
	],
	#category : 'Collector2',
	#package : 'Collector2'
}

{ #category : 'accessing' }
C2SequenceGraphVisitor >> collector [

	^ collector
]

{ #category : 'accessing' }
C2SequenceGraphVisitor >> collector: anObject [

	collector := anObject
]

{ #category : 'accessing' }
C2SequenceGraphVisitor >> edges [

	^ edges
]

{ #category : 'accessing' }
C2SequenceGraphVisitor >> edges: anObject [

	edges := anObject
]

{ #category : 'accessing' }
C2SequenceGraphVisitor >> initialize [

	edges := OrderedCollection new.
]

{ #category : 'accessing' }
C2SequenceGraphVisitor >> visitMessageNode: aMessageNode [

	"Visit recusively"
	super visitMessageNode: aMessageNode.

	"And add an adge to all "
	collector methods
		select: [ :m | m selector = aMessageNode selector ]
		thenDo: [ :m |
			| target |
			target := m ast body.
			self assert: target isSequence.
			edges add: { currentNode. target }. ].

]

{ #category : 'accessing' }
C2SequenceGraphVisitor >> visitSequenceNode: aSequenceNode [

	"Dot not visit sub-sequences, just mark an edge"
	currentNode ifNotNil: [
		edges add: { currentNode. aSequenceNode }.
		^ self ].
	
	currentNode := aSequenceNode.
	super visitSequenceNode: aSequenceNode.
	currentNode := nil.


]
