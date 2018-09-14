//
//  Uniform Cost Search.playground
//  Intelligent Systems
//
//  Created by Eduardo Valencia on 9/13/18.
//  Copyright © 2018 Eduardo Valencia. All rights reserved.
//

import UIKit

// MARK: - Heap Struct

/// Struct that declares our Heap data structure with generic type.
struct Heap<Element> {
	
	// MARK: - Computed Public Variables
	
	/**
		Computed variable that determines if the heap has elements.
		- returns: true if the heap has no elements; otherwise, false.
	*/
	public var isEmpty: Bool {
		return self.elements.isEmpty
	}
	
	/// Computed variables that returns the number of elements in the heap.
	public var count: Int {
		return elements.count
	}
	
	// MARK: - Initializers
	
	public init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
		self.elements = elements
		self.priorityFunction = priorityFunction
	}
	
	// MARK: - Private Variables
	
	/// Array of elements that exist in the heap.
	private var elements: [Element]
	
	/**
		Function that will determine which element has the highest priority
		- parameter A: First element to compare.
		- parameter B: second element to compare.
		- returns: true if A has a higher priority than B; otherwise, false.
	*/
	private let priorityFunction: (Element, Element) -> Bool
	
	// MARK: - Public Functions
	
	/**
		Function that gets the first element in the heap.
		- returns: First element of the heap.
	*/
	public func peek() -> Element? {
		return self.elements.first
	}
	
	// MARK: - Public Mutating Functions
	
	/**
		Function to add a new element to the heap.
		- parameter element: The element to be added to the heap.
	*/
	public mutating func enqueue(element: Element) {
		self.elements.append(element)
		self.siftUpElement(at: self.count - 1)
	}
	
	/**
		Function to remove and return the highest priority element in the heap.
		- returns: The element with the highest priority in the heap if isn't empty; otherwise, it returns **nil**.
	*/
	public mutating func dequeue() -> Element? {
		guard !self.isEmpty else {
			return nil
		}
		self.swapElement(at: 0, with: count - 1)
		let element = self.elements.removeLast()
		if !isEmpty {
			self.siftDownElement(at: 0)
		}
		return element
	}
	
	// MARK: - Private Functions
	
	/**
		Determines if the index is the root of the heap.
		- returns: true if the index is the root; otherwise, false.
	*/
	private func isRoot(index: Int) -> Bool {
		return index == 0
	}
	
	/**
		Determines the child to the left of a given node.
		- parameter index: An integer representing a position in the heap.
		- returns: An integer index of the child to the left of the given index.
	*/
	private func leftChildIndex(of index: Int) -> Int {
		return (2 * index) + 1
	}
	
	/**
		Determines the child to the right of a given node.
		- parameter index: An integer representing a position in the heap.
		- returns: An integer index of the child to the right of the given index.
	*/
	private func rightChildIndex(of index: Int) -> Int {
		return (2 * index) + 2
	}
	
	/**
		Determines the parent of a given node.
		- parameter index: An integer representing a position in the heap.
		- returns: An integer index of the parent of the node at the given index.
	*/
	private func parentIndex(of index: Int) -> Int {
		return (index - 1) / 2
	}
	
	/**
		Function that determines if the first index has a higher priority than the second one.
		- parameter firstIndex: An integer index that exists in the node.
		- parameter secondIndex: An integer index that exists in the node.
		- returns: **true** if *firstIndex* has a higher priority than *secondIndex*; otherwise, **false**.
	*/
	private func isHigherPriority(firstIndex: Int, than secondIndex: Int) -> Bool {
		return self.priorityFunction(self.elements[firstIndex], self.elements[secondIndex])
	}
	
	/**
		Function that determines the index that has the highest priority between a parent and its child.
		- parameter parentIndex: An integer index that corresponds to a parent node.
		- parameter parentIndex: An integer index that corresponds to a child node.
		- returns: The integer index with the highest priority.
	*/
	private func highestPriorityIndex(between parentIndex: Int, and childIndex: Int) -> Int {
		guard childIndex < self.count, isHigherPriority(firstIndex: childIndex, than: parentIndex) else {
			return parentIndex
		}
		return childIndex
	}
	
	/**
		Function that determines which child has the highest priority for a given index.
		- parameter parentIndex: An integer index that corresponds to a parent node.
		- returns: The integer index with the highest priority.
	*/
	private func highestPriorityIndex(for parentIndex: Int) -> Int {
		return self.highestPriorityIndex(between: self.highestPriorityIndex(between: parentIndex, and: self.leftChildIndex(of: parentIndex)), and: self.rightChildIndex(of: parentIndex))
	}
	
	// MARK: - Private Mutating Functions
	
	/**
		Function that orders the parent nodes and their children by their priority.
	*/
	private mutating func buildHeap() {
		for currentIndex in (0 ..< count / 2).reversed() {
			self.siftDownElement(at: currentIndex)
		}
	}
	
	/**
		Function that moves the elements at a given index with the ones that exist at another one.
		- parameter index: An integer index of the elements that will be swapped.
		- parameter newIndex: An integer index of the elements that will be swapped.
	*/
	private mutating func swapElement(at index: Int, with newIndex: Int) {
		guard index != newIndex else {
			return
		}
		self.elements.swapAt(index, newIndex)
	}
	
	/**
		Function that moves the node at a given index to its parent's former position if it has a higherPriority.
		- parameter index: An integer of the element we wish to compare against it parent.
	*/
	private mutating func siftUpElement(at index: Int) {
		// Find the parent index of the given index.
		let parentIndex = self.parentIndex(of: index)
		
		// If the index is the root of the heap or has a lower priority than the parent, then return.
		guard !self.isRoot(index: index), self.isHigherPriority(firstIndex: index, than: parentIndex) else {
			return
		}
		self.swapElement(at: index, with: parentIndex)
		self.siftUpElement(at: parentIndex)
	}
	
	/**
		Function that moves the highest priority child of a given index to such position if it has a higher priority.
		- parameter index: An integer of the element we wish to compare against it parent.
	*/
	private mutating func siftDownElement(at index: Int) {
		// Find the child index with the highest priority of the given index.
		let childIndex = self.highestPriorityIndex(for: index)
		if index == childIndex {
			return
		}
		self.swapElement(at: index, with: childIndex)
		self.siftDownElement(at: childIndex)
	}
}

// MARK: - Node Class

/// Class that represents a graph node.
class Node {
	
	// MARK: - Public variables
	
	/// The name that identifies the node.
	public var name: String
	/// The inherent cost of the node.
	public var cost: Int
	/// The neighbors the node has.
	public var neighbors: [String : Int] = [:]
	
	// MARK: - Initializers
	
	public init(name: String, cost: Int = 0) {
		self.name = name
		self.cost = cost
	}
	
	// MARK: - Public Functions
	
	/**
		Function to add a neighbor to the current node.
		- parameter neighborName: A unique string that belongs to a neighbor node.
		- parameter cost: The integer cost between the current node and the neighbor.
	*/
	public func addNeighbor(neighborName: String, cost: Int = 0) {
		self.neighbors[neighborName] = cost
	}
	
	/**
		Function that returns all the neighbors of the current node.
		- returns: A string array of all the neighbors' names.
	*/
	public func getNeighbors() -> [String] {
		return Array(self.neighbors.keys)
	}
	
	/**
		Function that returns the cost between the current node and a given neighbor.
		- returns: The integer cost between the current node and a given neighbor.
	*/
	public func cost(to neighbor: String) -> Int? {
		return self.neighbors[neighbor]
	}
}

// MARK: - Graph Class

/// Class that represents a graph.
class Graph {
	
	// MARK: - Private Variables
	
	/// The edges that form the graph.
	private var edges: [String: Node] = [:]
	
	// MARK: - Public Functions
	
	/**
		Function that adds a new node to the current graph.
		- parameter name: A unique string that identifies a given node.
	*/
	public func addNode(name: String) {
		let node = Node(name: name)
		self.edges[name] = node
	}
	
	/**
		Function that adds a new edge between two nodes.
		- parameter nodeAName: A unique string that identifies the first node.
		- parameter nodeBName: A unique string that identifies the second node.
		- parameter cost: The cost between the two nodes.
	*/
	public func addEdge(from nodeAName: String, to nodeBName: String, with cost: Int = 0) {
		// If node A and/or node B are not already in the graph's edges, add them.
		if !self.edges.keys.contains(nodeAName) {
			self.addNode(name: nodeAName)
		}
		if !self.edges.keys.contains(nodeBName) {
			self.addNode(name: nodeBName)
		}
		// Add A as a neighbor of B with the given cost and vice versa.
		self.edges[nodeAName]?.addNeighbor(neighborName: nodeBName, cost: cost)
		self.edges[nodeBName]?.addNeighbor(neighborName: nodeAName, cost: cost)
	}
	
	/**
		Function that returns the neighbors of a node with a given name.
		- parameter name: The name of the node we are looking for.
	*/
	public func neighbors(for name: String) -> [String]? {
		return self.edges[name]?.getNeighbors()
	}
	
	/**
		Function that returns the cost between two nodes.
		- parameter nameA: The name of the first node we are looking for.
		- parameter nameB: The name of the second node we are looking for.
	*/
	public func cost(between nameA: String, and nameB: String) -> Int? {
		return self.edges[nameA]?.cost(to: nameB)
	}
}

// MARK: - FrontierElement Struct

/// Struct that represents the elements inside the frontier prioritized queue and that conforms to the Comparable protocol.
struct FrontierElement: Comparable {
	
	// MARK: - Public Attributes
	
	public let cost: Int
	public let nodeName: String
	public let solution: [String]
	
	
	// MARK: - Initializers
	
	public init(cost: Int, nodeName: String, solution: [String] = []) {
		self.cost = cost
		self.nodeName = nodeName
		self.solution = solution
	}
	
	// MARK: - Comparable Protocol Functions
	
	static func < (lhs: FrontierElement, rhs: FrontierElement) -> Bool {
		return lhs.cost < rhs.cost
	}
	
	static func > (lhs: FrontierElement, rhs: FrontierElement) -> Bool {
		return lhs.cost > rhs.cost
	}
	
	static func == (lhs: FrontierElement, rhs: FrontierElement) -> Bool {
		return lhs.cost == rhs.cost
	}
	
	static func != (lhs: FrontierElement, rhs: FrontierElement) -> Bool {
		return lhs.cost != rhs.cost
	}
	
}

// MARK: - Fileprivate Functions

/**
	Function that loads a file with a given name and extension from the main Bundle (i.e. Resources folder).
	- parameter name: A string that is the file's name.
	- parameter withExtension: A string that represents the file's type.
	- returns: A string with the contents of the file. If the file does not exist or can't be opened, then it returns **nil**.
*/
fileprivate func loadFile(named name: String, withExtension: String) -> String? {
	
	// Check if the file exists in the Main Bundle and if it does, store the file's URL.
	guard let fileURL = Bundle.main.url(forResource: name, withExtension: withExtension) else {
		return nil
	}
	do {
		// Get the contents using UTF-8 encoding.
		let content = try String(contentsOf: fileURL, encoding: .utf8)
		return content
	} catch {
		print(error.localizedDescription)
	}
	return nil
}

/**
	Function that finds the shortest path between two nodes in a given graph by using the uniform cost search algorithm.
	- parameter graph: The graph were the two nodes exist.
	- parameter start: The starting node for our path.
	- parameter goal: The node we wish to reach through the shortest path.
	- returns: A string array with the names of the nodes that conform the path. If no solution exits, then **nil** is returned.
*/
fileprivate func uniformCostSearch(graph: Graph, start: String, goal: String) -> [String]? {
	// Create a prioritized queue with the Heap struct by assigning no elements and < as the priority function.
	var frontier: Heap<FrontierElement> = Heap(elements: [], priorityFunction: <)
	
	// Add the start to the queue.
	frontier.enqueue(element: FrontierElement(cost: 0, nodeName: start))
	
	// Create an empty dictionary of explored places.
	var explored: [String : Int] = [:]
	
	// Iterate while our queue has elements.
	while !frontier.isEmpty {
		
		// Get the element with the highest priority from the frontier.
		guard let currentFrontierElement: FrontierElement = frontier.dequeue() else {
			continue
		}
		let currentCost = currentFrontierElement.cost
		let currentNodeName = currentFrontierElement.nodeName
		
		// If the current node has been visited and the cost is less than the cost of the current frontier element, we continue to the next iteration since we are looking for the smallest cost.
		if explored.keys.contains(currentNodeName), let cost = explored[currentNodeName], cost < currentCost {
			continue
		}
		
		// Add the current node to the solution array.
		var currentSolution = currentFrontierElement.solution
		currentSolution.append(currentNodeName)
		
		// If we have reached the goal then we return our solution array which is the shortest path.
		if currentNodeName == goal {
			return currentSolution
		}
		
		// We iterate through all the neighbors for the current node.
		for currentNeighbor in graph.neighbors(for: currentNodeName) ?? [] {
			
			// If the current neighbor hasn't been explored then we find the cost between the current node and the neighbor and add it to the current cost. Finally, we create a frontier element add it to our queue.
			if !explored.keys.contains(currentNeighbor) {
				let cost = currentCost + (graph.cost(between: currentNodeName, and: currentNeighbor) ?? 0)
				frontier.enqueue(element: FrontierElement(cost: cost, nodeName: currentNeighbor, solution: currentSolution))
			}
		}
		
		// We add the current node to the explored dictionary.
		explored[currentNodeName] = currentCost
	}
	return nil
}

// MARK: - Demo of Uniform Cost Search

// Create the graph.
let graph = Graph()

// Check if the file "espana.txt" exists.
if let fileContents = loadFile(named: "espana", withExtension: "txt") {
	
	// Separate the file contents string by new lines (i.e. \n) and iterate each one.
	for currentLine in fileContents.components(separatedBy: .newlines) {
		
		// Split each line by commas and cast the substrings to strings.
		let lineComponents: [String] = currentLine.split(separator: ",").map { (substring) -> String in
			return String(substring)
		}
		
		// If there are three components in the current line, then an edge is added to the graph.
		if lineComponents.count == 3, let nodeAName = lineComponents.first, let costString = lineComponents.last, let cost = Int(costString) {
			let nodeBName = lineComponents[1]
			graph.addEdge(from: nodeAName, to: nodeBName, with: cost)
		}
	}
	
	// Call the uniformCostSearch function, establish the starting and ending nodes and if found, print the solution path.
	print(uniformCostSearch(graph: graph, start: "Coruna", goal: "Valencia") ?? "No solution found")
} else {
	print("Something went wrong")
}


