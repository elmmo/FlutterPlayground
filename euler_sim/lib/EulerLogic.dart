main() {
  List<List<int>> eulerCycleGraph = 
    [[0,1,1,1,1],
    [1,0,1,0,0],
    [1,1,0,0,0],
    [1,0,0,0,1],
    [1,0,0,1,0],
    ];
  print(getEulerCycle(eulerCycleGraph)); 

  List<List<int>> eulerTrailGraph = 
   [[0,1,0,0,1],
  [1,0,1,1,0],
  [0,1,0,1,0],
  [0,1,1,0,0],
  [1,0,0,0,0],
  ];
  print(getEulerTrail(eulerTrailGraph)); 


}

// checks if the entire graph in the adjacency matrix is connected 
// @param g - the adjacency matrix to examine 
// @param excludeZeroDeg - whether to find connectedness excluding nodes with zero edges 
// @returns - List of the connected nodes (not including zero deg nodes) or null if unconnected
List getConnected(List<List<int>> g, {bool excludeZeroDeg}) {
  List visited = List.filled(g.length, 0); // represents nodes that can be reached 
  visited[0] = 1; 
  // traverse first row and explore adjacent vertices 
  for (int i = 0; i < g.length; i++) {
    if (g[0][i] == 1) {
      checkConnected(g, i, visited); 
    }
  }
  // sum visited list, should total the number of nodes if connected 
  int connectedNodes = visited.reduce(((value, element) => value+element));
  // if want to account for nodes of zero degree, treat them as if they're part of the connected graph
  if (excludeZeroDeg != null) {
    connectedNodes += getNumZeroDeg(g);
  }
  return (connectedNodes == visited.length) ? visited : null; 
}

// recursive helper function that marks visited nodes 
// @param g - the adjacency matrix 
// @param row - the adjacent node to examine 
// @param visited - list of visited nodes to update 
void checkConnected(List<List<int>> g, int row, List visited) {
  visited[row] = 1; 
  for (int i = 0; i < g.length; i++) {
    // if adjacent neighbor is not yet visited
    if (visited[i] == 0 && g[row][i] == 1) {
      checkConnected(g, i, visited); 
    }
  }
}

// checks if the entire graph in the adjacency matrix is connected 
// @param g - the adjacency matrix to examine 
// @param excludeZeroDeg - whether to find connectedness excluding nodes with zero edges 
// @returns - whether the graph is connected 
bool isConnected(List<List<int>> g, {bool excludeZeroDeg}) => getConnected(g, excludeZeroDeg: excludeZeroDeg) != null;

// takes an adjacency matrix and returns an int with the number of nodes of zero degree 
int getNumZeroDeg(List<List<int>> g) => getNodeDegrees(g).where((element) => element == 0).length; 

// takes an adjacency matrix and returns a bool with whether there's an euler cycle 
bool hasEulerCycle(List<List<int>> g) => getNodeDegrees(g).every((element) => element % 2 == 0 || element == 0); 

// takes an adjacency matrix and returns a bool with whether there's an euler trail 
bool hasEulerTrail(List<List<int>> g) {
  int oddDeg = 0; 
  // check how many vertices of odd degree there are 
  getNodeDegrees(g).forEach((element) {
    if (element % 2 != 0 && element != 0) {
      oddDeg++; 
    } 
  });
  return (oddDeg == 2); 
}

// takes an adjacency matrix and returns a list of degrees for each node in the graph 
List<int> getNodeDegrees(List<List<int>> g) {
  List<int> degrees = new List<int>(); 
  g.forEach((List<int> row) {
    // sums to get the number of connections for each node 
    int sum = 0; 
    for (int i = 0; i < row.length; i++) sum += row[i];
    degrees.add(sum); 
  });
  return degrees; 
}

// gets the Euler cycle present in the graph 
List<int> getEulerCycle(List<List<int>> g) {
  List<int> cycle = new List<int>(); 
  if (hasEulerCycle(g)) {
    // traverse first row and search each match 
    for (int i = 0; i < g.length; i++) {
      if (g[0][i] == 1) {
        checkCycle(g, 0, i, cycle);
      }
    }
    cycle.add(0); 
  }
  return cycle; 
}

// recursive helper function for traversing over the graph 
void checkCycle(List<List<int>> g, int row, int cell, List<int> cycle) {
  // push the given node onto the cycle path 
  cycle.add(row); 
  g[row][cell] = 0; 
  g[cell][row] = 0; 
  // search for more matches 
  for (int i = 0; i < g[cell].length; i++) {
    if (g[cell][i] == 1) {
      checkCycle(g, cell, i, cycle); 
    }
  }
}

List<int> getEulerTrail(List<List<int>> g) {
  List<int> stack = new List<int>(); // a list we treat as a stack 
  List<int> path = new List<int>(); 
  if (hasEulerTrail(g)) {
    List<int> degrees = getNodeDegrees(g);
    // start at the first node with an odd number of edges 
    int current = degrees.indexWhere((element) => element % 2 != 0); 
    checkTrail(g, current, degrees, stack, path); 
  }
  return path; 
}

// recursive helper function for finding an euler trail 
void checkTrail(List<List<int>> g, int current, List<int> degrees, List<int> stack, List<int> path) {
  // if the current node has a neighbor 
  if (degrees[current] >= 1) {
    stack.add(current); // store current for backtracking later  
    degrees[current]--; 
  }
  int next = g[current].indexWhere((element) => element > 0);
  if (next == -1) {
    // add to the trail and continue with the backtracked node 
    path.add(current); 
    next = stack.removeLast(); 
  } else {
    // remove connection between current and next 
    g[current][next] = 0; 
    g[next][current] = 0; 
    degrees[next]--; 
  }
  // continue to repeat until the stack is empty and the current node has no neighbors
  if (stack.isNotEmpty || !(degrees[next] == 0)) {
    checkTrail(g, next, degrees, stack, path); 
  }
}

