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
      check(g, i, visited); 
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
void check(List<List<int>> g, int row, List visited) {
  visited[row] = 1; 
  for (int i = 0; i < g.length; i++) {
    // if adjacent neighbor is not yet visited
    if (visited[i] == 0 && g[row][i] == 1) {
      check(g, i, visited); 
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
    degrees.add(row.reduce((value, element) => value + element));
  });
  return degrees; 
}


