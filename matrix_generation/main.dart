// I did not share code or talk to other students about this exam
import 'dart:io';
import 'dart:math';

void main() {
  List<List<int>> matrix = getMatrix(0, 4, 5); 
  printMatrix(matrix);

}

// generates an adjacency matrix where there will be 0 if no edge, and the edge weight if there is an edge
// @param min: the minimum weight in the matrix 
// @param max: the maximum weight in the matrix 
// @param size: the dimensions of the matrix
List<List<int>> getMatrix(int min, int max, int size) {
  max = max+1; // so that the max will be inclusive 
  // get seed for random number 
  var time = new DateTime.now(); 
  Random rng = new Random(time.millisecondsSinceEpoch);
  // get first line of the matrix 
  List<int> tempList = new List<int>.generate(size, (index) => (index == 0) ? 0 : min + rng.nextInt(max-min)); 
  List<List<int>> matrix = [tempList]; 
  // populate rest of matrix 
  for (int i = 0; i < size-1; i++) {
    tempList = new List<int>.generate(size, (index) => (index < matrix.length) ? matrix.elementAt(index).elementAt(matrix.length) : min + rng.nextInt(max-min));
    matrix.add(tempList); 
  }
  // adjust to ensure no node is connected to itself
  for (int i = 1; i < size; i++) {
    matrix[i][i] = 0; 
  }
  return matrix; 
}

void printMatrix(List<List<int>> matrix) {
  print("\nRandomly generated input matrix:");
  for (int i = 0; i < matrix.length; i++) {
    matrix.elementAt(i).forEach((entry) => stdout.write("${entry} "));
    stdout.write("\n");
   }
   stdout.write("\n");
}
