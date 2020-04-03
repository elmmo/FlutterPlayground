
class Core {
  String str;

  // stores string to parse from the calculator input 
  Core(this.str);

  

  // prints the pre-parsed string 
  void printInput() {
    print(str);
  }
}

void main() {
  Core h = new Core("Hello World");
  h.printInput(); 
}