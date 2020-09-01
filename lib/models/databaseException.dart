
class DatabaseException  implements Exception {
 
 final String _message;

 DatabaseException(this._message);
 
 String toString(){
   return this._message;
 }
}