import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_logger/models/expense.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  // insert expense data
  Future insertExpenseData(Expense expense) async {
    return await usersCollection.document(uid).collection('expenses').add({
      'date': expense.date,
      'paymentType': expense.paymentType,
      'category': expense.category,
      'description': expense.description,
      'amount': expense.amount
    });
  }

  // expenseList from snapshot
  

  // get expenses stream
  
}
