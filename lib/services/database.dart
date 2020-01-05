import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_logger/models/expense.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  // insert expense data
  Future insertTransactionData(Expense expense) async {
    return await usersCollection.document(uid).setData({
      'transactions': {
        expense.date: FieldValue.arrayUnion([
          {
            'date': expense.date,
            'transactionType': expense.transactionType,
            'paymentType': expense.paymentType,
            'category': expense.category,
            'description': expense.description,
            'amount': expense.amount
          }
        ])
      }
    }, merge: true);
  }

  // get transactions stream
  Stream<DocumentSnapshot> get transactions {
    return usersCollection.document(uid).snapshots();
  }
}
