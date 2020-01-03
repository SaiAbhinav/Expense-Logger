import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_logger/models/expense.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');

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
  List<Expense> _expenseListFromSnapshot(QuerySnapshot snapshot) {     
    return snapshot.documents.map((doc) {      
      return Expense(
        uid: doc.documentID,
        date: doc.data['date'] ?? '',
        paymentType: doc.data['paymentType'] ?? '',
        category: doc.data['category'] ?? '',
        description: doc.data['description'] ?? '',
        amount: doc.data['amount'] ?? ''
      );
    }).toList();
  }

  // get expenses stream
  Stream<List<Expense>> get expenses {    
    return usersCollection.document(uid).collection('expenses').orderBy('date')
      .snapshots().map(_expenseListFromSnapshot);
  }

  // delete an expense
  Future deleteExpenseData(String docId) async {
    return await usersCollection.document(uid).collection('expenses')
      .document(docId).delete().whenComplete(() {
        print('Deleted !!!');
      });
  }
  
}
